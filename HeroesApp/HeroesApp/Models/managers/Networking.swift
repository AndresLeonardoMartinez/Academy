//
//  Networking.swift
//  HeroesApp
//
//  Created by Andres Leonardo Martinez on 13/03/2019.
//  Copyright © 2019 Andres Leonardo Martinez. All rights reserved.
//

import Foundation
import Alamofire
import CoreData

class Connectivity {
    class func isConnectedToInternet() ->Bool {
        return NetworkReachabilityManager()!.isReachable
    }
}

class Networking : Networkable{
    var context: NSManagedObjectContext
    var requestParameters:Parameters
    var offset: Int
    var total: Int
    let url: String
    
    init(context : NSManagedObjectContext){
        let publicKey = Bundle.main.object(forInfoDictionaryKey: "MarvelPublicKey") as! String
        let hash = Bundle.main.object(forInfoDictionaryKey: "MarvelHash") as! String
        self.requestParameters = ["ts":"1", "apikey":publicKey, "hash":hash, "offset": "0"]
        self.url = Bundle.main.object(forInfoDictionaryKey: "MarvelUrl") as! String
        offset = 0
        total = 100
        self.context = context

        
    }
    
    func getElements<T : Decodable>(url: String, toParse: T.Type, limit: Int = 50, completion:@escaping (_ toReturn : T)->Void) where T: EntityNameable, T: NSFetchRequestResult {
        if !Connectivity.isConnectedToInternet() {
            //fetch de la data
            let fetchRequest = NSFetchRequest<T>(entityName: T.entityName() )
            do {
                let data = try context.fetch(fetchRequest)
                print ("fetch exitoso")
                guard let first = data.first else {return}
                completion(first)
            }
            catch let error {
                print("FALLO EL FETCH :: \(error)")
            }
        }
        else{
            if offset > total {return}
            self.requestParameters["limit"] = String(limit)
            let myUrl = self.url + url
            Alamofire.request(URL(string:myUrl)!, parameters: requestParameters)
                .validate()
                .responseJSON{ response in
                    switch response.result{
                    case .success:
                        guard let dataRAW = response.data else {return}
                        do{
                            let decoder = JSONDecoder()
                            decoder.userInfo[CodingUserInfoKey.context!] = self.context
                            let data = try decoder.decode(T.self, from: dataRAW)
                            //delete old values
                            self.deleteCoreData(T.self)
                            //store data
                            do {
                                try self.context.save()
                                print("STORE EXITOSO!")
                            }
                            catch let error {
                                print("FALLO EL STORE :: \(error)")
                            }
                            // callback
                            completion(data)
                        } catch let error{
                            print (error)
                        }
                    case .failure(let error):
                        print (error)
                    }
                    
            }
        }
    }
    func updatePagginationValues(offset: Int, total: Int){
        self.offset = offset
        self.total = total
        requestParameters["offset"] = String(offset)
    }
    
    func deleteCoreData<T>(_ toDelete: T.Type) where T:EntityNameable,  T: NSFetchRequestResult {
        let fetchRequest = NSFetchRequest<T>(entityName: T.entityName() )
        let batchDelete = NSBatchDeleteRequest(fetchRequest: fetchRequest as! NSFetchRequest<NSFetchRequestResult>)
        do {
            try context.execute(batchDelete)
            print ("delete exitoso")
        }
        catch let error {
            print("FALLO EL DELETE :: \(error)")
        }
    }
    

}

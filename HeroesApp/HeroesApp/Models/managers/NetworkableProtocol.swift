//
//  NetworkableProtocol.swift
//  HeroesApp
//
//  Created by Andres Leonardo Martinez on 21/03/2019.
//  Copyright © 2019 Andres Leonardo Martinez. All rights reserved.
//

import Foundation
import CoreData

protocol Networkable{
    var requestParameters: [String: Any]  {get set}
    var offset: Int  { get set }
    var total: Int  { get set }
    var url: String  { get }
    var context : NSManagedObjectContext { get set }
    /*
     getElements function can work with any decodable type. When it ends call to completion callback with
     the type decoded
     parameters:
     * url is the endpoint
     * toParse is the type of the element
     * limit is optional. The default is 50. it is used for paggination issues
     * completion is the callback tha have a element type parameter
     */
    func getElements<T : Decodable>(url: String, toParse: T.Type, limit: Int, completion:@escaping (_ toReturn : T)->Void) where T: EntityNameable, T: NSFetchRequestResult
    
}
extension Networkable{
    /*
     update the offset
     */
    mutating func updatePagginationValues(offset: Int, total: Int){
        self.offset = offset
        self.total = total
        requestParameters["offset"] = String(offset)
    }
}

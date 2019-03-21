//
//  CreatorsViewController.swift
//  HeroesApp
//
//  Created by Andres Leonardo Martinez on 12/03/2019.
//  Copyright © 2019 Andres Leonardo Martinez. All rights reserved.
//

import UIKit

class CreatorsViewController: UIViewController {
    
    @IBOutlet weak var table : UITableView!
    @IBOutlet weak var noConnectionLabel : UILabel!

    var creators : [Creator]?
    var networking: Networkable?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        self.noConnectionLabel.isHidden = Connectivity.isConnectedToInternet()
        self.networking = Networking(context: context)
        self.networking?.getElements(url: "creators", toParse: ResponseCreator.self, limit: 50, completion: { [weak self]
            response in
            guard let strongSelf = self else {return}
            strongSelf.creators = response.data.results.filter({ (Creator) -> Bool in
                //filter to eliminate creators with empty name
                !Creator.fullName.isEmpty
            })
            
            strongSelf.table.reloadData()
        })
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destineViewController = segue.destination as? DetailsViewController
        guard let miSender = sender as? UITableViewCell else{return}
        guard let index = table.indexPath(for: miSender)?.row else {return}
        let miCreator = creators?[index]
        let wiki: URLElement? = miCreator!.urls.first(where: { $0.realType == .detail })
        let detail = Detail(name: miCreator?.fullName, description: nil, image: miCreator?.thumbnail, wiki : wiki?.url)
        destineViewController?.detail = detail
        
    }
}
extension CreatorsViewController : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return creators?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let myCelda = table.dequeueReusableCell(withIdentifier: "reusedCell") as! UITableViewCell
        myCelda.textLabel?.text = creators?[indexPath.row].fullName
        return myCelda
    }
}




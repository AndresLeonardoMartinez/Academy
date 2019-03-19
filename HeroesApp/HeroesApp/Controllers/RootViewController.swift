//
//  RootViewController.swift
//  HeroesApp
//
//  Created by Andres Leonardo Martinez on 27/02/2019.
//  Copyright © 2019 Andres Leonardo Martinez. All rights reserved.
//

import UIKit
import SDWebImage
import UserNotifications



class RootViewController: UIViewController {
    
    @IBOutlet weak var miTable : UITableView!
    @IBOutlet weak var miSearchTable : UISearchBar!
    @IBOutlet weak var isLoading : UIActivityIndicatorView!
    @IBOutlet weak var noConnectionLabel : UILabel!
    
    var heroes: [Heroe]?
    var isSearching = false
    var isFetchingData = false
    var heroesSearched: [Heroe]?
    var networking: Networking?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        //check connection
        self.noConnectionLabel.isHidden = Connectivity.isConnectedToInternet()
        self.networking = Networking(context: context)
        self.heroes = []
        isLoading.hidesWhenStopped = true
        isLoading.startAnimating()
        
        self.fetchData()

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let viewControllerDestine = segue.destination as? DetalleViewController
        guard let miSender = sender as? CustomCell else {return}
        guard let index = miTable.indexPath(for: miSender)?.row else {return}
        if isSearching{
            viewControllerDestine?.miHeroe = heroesSearched?[index]
        }
        else{
            viewControllerDestine?.miHeroe = heroes?[index]
        }
    }
 
}

//MARK: implementation of the table methods
extension RootViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching {
            return heroesSearched?.count ?? 0
        }
        else{
            return heroes?.count ?? 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = miTable.dequeueReusableCell(withIdentifier: "heroeCell", for: indexPath) as! CustomCell
        if (isSearching){
            cell.myLabel.text = heroesSearched?[indexPath.row].name
            if let imageURL = heroesSearched?[indexPath.row].thumbnail{
                let url = URL(string: imageURL.path + "." + imageURL.thumbnailExtension)
                cell.myImage.sd_setImage(with:  url, placeholderImage: nil, options: [], completed: nil)
            }
        }
        else{
            cell.myLabel.text = heroes?[indexPath.row].name
            if let imageURL = heroes?[indexPath.row].thumbnail{
                let url = URL(string: imageURL.path + "." + imageURL.thumbnailExtension)
                cell.myImage.sd_setImage(with: url, placeholderImage: nil, options: [], completed: nil)
            }
        }
        cell.myButton.tag = indexPath.row
        let selector = #selector(self.saveNotification(sender:))
        cell.myButton.addTarget(self, action: selector, for: .touchUpInside)
        return cell
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CustomCell.height
    }
}

//MARK: methods to resolve paggination issue
extension RootViewController : UIScrollViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let height = scrollView.frame.size.height
        let contentYoffset = scrollView.contentOffset.y
        let distanceFromBottom = scrollView.contentSize.height - contentYoffset
        if distanceFromBottom < height {
            if !isFetchingData && !isSearching && Connectivity.isConnectedToInternet() {
                isFetchingData = true
                self.fetchData()
            }
        }
    }
    func fetchData(){
       networking?.getElements(url: "characters", toParse: ResponseHeroes.self, completion: {
            response in
        self.heroes?.append(contentsOf: response.data.results.filter({ (Heroe) -> Bool in
            // filter to eliminate elements tha hasn't image
            let image = Heroe.thumbnail.path
            return !image.contains("image_not_available")
            
        }))
            self.miTable.reloadData()
            self.networking?.updatePagginationValues(offset: Int(response.data.offset + response.data.count), total: Int(response.data.total))
            self.isLoading.stopAnimating()
            self.isFetchingData = false
        })
    }
}


// MARK: functions of the search bar
extension RootViewController : UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            isSearching = false
            print ("termino la busqeda")
            
        }
        else{
        heroesSearched = heroes?.filter({ (Heroe) -> Bool in
            Heroe.name.prefix(searchText.count).lowercased() == searchText.lowercased()
        })
        isSearching = true
        }
        miTable.reloadData()

    }
    
   
}
// notification functions
extension RootViewController {
    @objc func saveNotification(sender: UIButton) {
        print ("se")
        let index = sender.tag
        let heroe : Heroe?
        if isSearching{
            heroe = heroesSearched?[index]
        }
        else{
            heroe = heroes?[index]
        }
        
        let notificationCenter = UNUserNotificationCenter.current()
        let content = UNMutableNotificationContent()
        content.title = "Remainder"
        if let name = heroe?.name{
        content.subtitle = "Is time to see the \(name) details"
        }
        //content.body = ""
        content.categoryIdentifier = "alarm"
        content.userInfo = ["heroe": try? JSONEncoder().encode(heroe!)]
        content.sound = UNNotificationSound.default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        let request = UNNotificationRequest(identifier: "HeroeDetails", content: content, trigger: trigger)
        notificationCenter.add(request, withCompletionHandler: nil)
        }
        
    }


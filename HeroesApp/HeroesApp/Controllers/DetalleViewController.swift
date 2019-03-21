//
//  DetalleViewController.swift
//  HeroesApp
//
//  Created by Andres Leonardo Martinez on 27/02/2019.
//  Copyright © 2019 Andres Leonardo Martinez. All rights reserved.
//

import UIKit
import SDWebImage
import NVActivityIndicatorView

class DetalleViewController: UIViewController {
    
    var miHeroe : Heroe?
    @IBOutlet weak var labelDescription : UILabel!
    @IBOutlet weak var imageToShow: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var miComicsCollection: UICollectionView!
    @IBOutlet weak var isLoading : UIActivityIndicatorView!
    var networking: Networking?
    var comics : [Comic] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //isLoading.hidesWhenStopped = true
       // isLoading.startAnimating()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        self.networking = Networking(context: context)
        fetchData()
        showHeroe()
    }
    func fetchData(){
        guard let id = miHeroe?.id else {return}
        let url = "characters/"+String(describing: id)+"/comics"
        networking?.getElements(url:url, toParse: ResponseComic.self, completion: {
            response in
            self.comics.append(contentsOf: response.data.results)
            self.miComicsCollection.reloadData()
            self.networking?.updatePagginationValues(offset: Int(response.data.offset + response.data.count), total: Int(response.data.total))
            //self.isLoading.stopAnimating()
        })
    }
    
    
    func showHeroe() {
        guard let heroeActual = miHeroe else {
            return
        }
        labelDescription.text = heroeActual.descriptionHeroe
        let image = heroeActual.thumbnail
        let url = URL(string: image.path + "." + image.thumbnailExtension)
        imageToShow.sd_setImage(with:  url, placeholderImage: nil, options: [], completed: nil)

        
        titleLabel.text = heroeActual.name
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let heroeActual = miHeroe else {
            return
        }
        if segue.identifier == "goToDetailsSegue"{
            let destineViewController = segue.destination as? ImageViewController
            destineViewController?.myThumbail = heroeActual.thumbnail
        }
        else if segue.identifier == "goToComicSegue"{
            let destineViewController = segue.destination as? DetailsViewController
            guard let miSender = sender as? CellToCarrousell else{return}
            guard let index = miComicsCollection.indexPath(for: miSender)?.row else {return}
            let miComic = comics[index]
            let detail = Detail(name: miComic.title, description: miComic.descriptionComic, image: miComic.thumbnail)
            destineViewController?.detail = detail

        }
    }


}

extension DetalleViewController: UICollectionViewDataSource, UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return comics.count ?? 0
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let myCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellToCarrousell", for: indexPath) as! CellToCarrousell
        let image = comics[indexPath.row].thumbnail
        let url = URL(string: image.path + "." + image.thumbnailExtension)
        myCell.myImage.sd_setImage(with:  url, placeholderImage: nil, options: [], completed: nil)
        return myCell
    }
}

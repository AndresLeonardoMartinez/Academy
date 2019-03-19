//
//  ComicViewController.swift
//  HeroesApp
//
//  Created by Andres Leonardo Martinez on 06/03/2019.
//  Copyright © 2019 Andres Leonardo Martinez. All rights reserved.
//

import UIKit
import SDWebImage

class DetailsViewController: UIViewController {
    
    var detail : Detail?
    @IBOutlet weak var comicImage : UIImageView!
    @IBOutlet weak var descriptionText : UILabel!
    @IBOutlet weak var titleLabel : UILabel!
    @IBOutlet weak var wikiLabel : UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.titleLabel.text = detail?.name
        self.descriptionText.text = detail?.description
        if let image = detail?.image {
            let url = URL(string: image.path + "." + image.thumbnailExtension)
            comicImage.sd_setImage(with:  url, placeholderImage: nil, options: [], completed: nil)
        }
        if let wiki = detail?.wiki {
            wikiLabel.isHidden = false
        }
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destineViewController = segue.destination as? WikiViewController
        destineViewController?.url = detail?.wiki
        
        
        
    }
    

  

}

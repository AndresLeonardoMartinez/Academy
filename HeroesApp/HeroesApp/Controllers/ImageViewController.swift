//
//  ImageViewController.swift
//  HeroesApp
//
//  Created by Andres Leonardo Martinez on 01/03/2019.
//  Copyright © 2019 Andres Leonardo Martinez. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController {
    @IBOutlet weak var myImage : UIImageView!
    var myThumbail : Thumbnail?
    override func viewDidLoad() {
        super.viewDidLoad()
        if let imageURL = myThumbail{
            let url = URL(string: imageURL.path + "." + imageURL.thumbnailExtension)
            myImage.sd_setImage(with: url, placeholderImage: nil, options: [], completed: nil)
        }
        
        
    }
    
    @IBAction func closeMe(_ sender: UITapGestureRecognizer) {
            self.dismiss(animated: true, completion : nil)
        }
    

}

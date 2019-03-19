//
//  CreditsViewController.swift
//  HeroesApp
//
//  Created by Andres Leonardo Martinez on 06/03/2019.
//  Copyright © 2019 Andres Leonardo Martinez. All rights reserved.
//

import UIKit

class CreditsViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    

    @IBAction func Animar(_ sender: UIButton) {
        UIView.animate(withDuration: 1, animations: {
            self.titleLabel.backgroundColor = UIColor.black
            self.titleLabel.textColor = UIColor.gray
            
        })
            
        
    }

}

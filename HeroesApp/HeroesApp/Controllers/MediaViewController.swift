//
//  MediaViewController.swift
//  HeroesApp
//
//  Created by Andres Leonardo Martinez on 06/03/2019.
//  Copyright © 2019 Andres Leonardo Martinez. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class MediaViewController: UIViewController {
    
    @IBOutlet var myView : UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let path = Bundle.main.path(forResource: "videoplayback", ofType:"mp4") else {
            debugPrint("video not found")
            return
        }
        let url = URL(fileURLWithPath: path)
        let player = AVPlayer(url: url)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        self.present(playerViewController, animated: true) {
            playerViewController.player?.play()
        }
        

    }
    


}

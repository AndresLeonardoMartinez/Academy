//
//  Detail.swift
//  HeroesApp
//
//  Created by Andres Leonardo Martinez on 13/03/2019.
//  Copyright © 2019 Andres Leonardo Martinez. All rights reserved.
//

import Foundation
struct Detail{
    let name: String?
    let description: String?
    let image: Thumbnail?
    let wiki: String?
    
    init (name: String?, description: String?, image: Thumbnail?, wiki: String? = nil){
        self.name = name
        self.description = description
        self.image = image
        self.wiki = wiki
    }
}

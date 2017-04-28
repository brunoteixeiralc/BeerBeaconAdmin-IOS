//
//  UntappdCell.swift
//  BeerBeaconAdmin
//
//  Created by Bruno Corrêa on 27/04/17.
//  Copyright © 2017 Br4Dev. All rights reserved.
//

import UIKit

class UntappdCell:UITableViewCell{
    
    @IBOutlet weak var cervejaria: UILabel!
    @IBOutlet weak var cerveja: UILabel!
    @IBOutlet weak var estilo: UILabel!
    @IBOutlet weak var cerveja_img: UIImageView!
    
    var tap:Tap!{
        didSet{
            cerveja.text = tap.cerveja
            cervejaria.text = tap.cervejaria
            estilo.text = tap.estilo
            
            let url = URL(string: tap.cerveja_img_url)
            cerveja_img.kf.setImage(with: url, options: [.transition(.fade(0.2))])
            cerveja_img.kf.indicatorType = .activity
            cerveja_img.kf.setImage(with: url)
        }
    }
}

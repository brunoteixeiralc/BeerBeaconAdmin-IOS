//
//  Medida.swift
//  BeerBeacon
//
//  Created by Bruno Lemgruber on 10/04/17.
//  Copyright © 2017 Bruno Lemgruber. All rights reserved.
//

import Foundation
import Firebase

class Medida {
    
    var preco = ""
    var quantidade = ""

    init(preco:String,quantidade:String){
        self.preco = preco
        self.quantidade = quantidade
    }
}


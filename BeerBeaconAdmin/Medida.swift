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
    
    var uid = ""
    var preco = ""
    var quantidade = ""

    init(uid:String,preco:String,quantidade:String){
        self.preco = preco
        self.quantidade = quantidade
        self.uid = uid
    }
    
    init(preco:String,quantidade:String){
        self.preco = preco
        self.quantidade = quantidade
    }
    
    init(dictionary:[String:Any],uid:String){
       self.uid = uid 
       self.preco = dictionary["preco"] as! String
       self.quantidade = dictionary["quantidade"] as! String
    }
    
    func toDictionary() -> [String:Any]{
        return [
            "preco": preco,
            "quantidade": quantidade
        ]
    }

}


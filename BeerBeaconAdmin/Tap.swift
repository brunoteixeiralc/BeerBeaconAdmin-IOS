//
//  Taps.swift
//  BeerBeacon
//
//  Created by Bruno Corrêa on 07/04/17.
//  Copyright © 2017 Bruno Lemgruber. All rights reserved.
//

import Foundation
import Firebase

extension Date {
    func toString(format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
}


class Tap {
    
    var abv = ""
    var ibu = 0
    var cerveja = ""
    var cervejaria = ""
    var estilo = ""
    var nota = ""
    var torneira = ""
    var data_entrada = 0
    var medidas = [Medida]()
    var data_plug = ""
    var hora_plug = ""
    var cervejaria_img_url = ""
    var cerveja_img_url = ""
    var bid = 0
    var em_producao = 0
    var descricao = ""
    var status = ""
    var uid = ""
    
    
    private let tapRef = FIRDatabase.database().reference().child("taps")
    
    init() {
    }
    
    init(abv:String,ibu:Int,cerveja:String,cervejaria:String,estilo:String,nota:String,torneira:String,medidas:[Medida],hora_plug:String,data_plug:String,cervejaria_img_url:String,cerveja_img_url:String,bid:Int) {
        self.abv = abv
        self.ibu = ibu
        self.cerveja = cerveja
        self.cervejaria = cervejaria
        self.estilo = estilo
        self.nota = nota
        self.torneira = torneira
        self.medidas = medidas
        self.hora_plug = hora_plug
        self.data_plug = data_plug
        self.cervejaria_img_url = cervejaria_img_url
        self.cerveja_img_url = cerveja_img_url
        self.bid = bid
    }
    

    init(abv:String,ibu:Int,cerveja:String,cervejaria:String,estilo:String,nota:String,cervejaria_img_url:String,cerveja_img_url:String,bid:Int,data_entrada:Int,status:String,medidas:[Medida]) {
        self.abv = abv
        self.ibu = ibu
        self.cerveja = cerveja
        self.cervejaria = cervejaria
        self.estilo = estilo
        self.nota = nota
        self.cervejaria_img_url = cervejaria_img_url
        self.cerveja_img_url = cerveja_img_url
        self.bid = bid
        self.data_entrada = data_entrada
        self.status = status
        self.medidas = medidas
    }
    
    init(snapshot: FIRDataSnapshot)
    {
        if let value = snapshot.value as? [String : Any] {
            torneira = snapshot.key
            abv = value["ABV"] as! String
            ibu = value["IBU"] as! Int
            cerveja = value["cerveja"] as! String
            cervejaria = value["cervejaria"] as! String
            estilo = value["estilo"] as! String
            nota = value["nota"] as! String
            data_entrada = Int(value["data_entrada"] as! NSNumber)
            cervejaria_img_url = value["img_cervejaria"] as! String
            cerveja_img_url = value["img_cerveja"] as! String
            status = value["status"] as! String
            
            let date = NSDate(timeIntervalSince1970: TimeInterval(data_entrada))
            NSTimeZone.default = TimeZone(abbreviation: "GMT")!
            let dtFmt = DateFormatter()
            dtFmt.timeZone = NSTimeZone.default
            
            dtFmt.dateFormat = "dd/MM/YY"
            data_plug = dtFmt.string(from: date as Date)
            
            dtFmt.dateFormat = "HH:mm:ss"
            hora_plug = dtFmt.string(from: date as Date)
            
            if let medidasDict = value["medidas"] as? [String:Any]{
                for(medidaKey,medidaDict) in medidasDict{
                    if let m = medidaDict as? [String:Any]{
                        medidas.append(Medida(dictionary: m,uid:medidaKey))
                    }
                }
            }
        }
    }
    
    func save(completion:@escaping (Error?) -> Void){
        
        let ref = tapRef.childByAutoId()
        ref.setValue(toDictionary())
        
        for medida in medidas{
            ref.child("medidas").childByAutoId().setValue(medida.toDictionary())
        }
    }
    
    func update(uid:String,completion:@escaping (Error?) -> Void){
        
        let ref = tapRef.child(uid)
        ref.setValue(toDictionary())
        
        for medida in medidas{
            ref.child("medidas").child(medida.uid).setValue(medida.toDictionary())
        }
    }
    
    func toDictionary() -> [String:Any]{
        
        return [
            "ABV": abv,
            "IBU": ibu,
            "estilo": estilo,
            "cerveja": cerveja,
            "cervejaria":cervejaria,
            "data_entrada":data_entrada,
            "img_cerveja":cerveja_img_url,
            "img_cervejaria":cervejaria_img_url,
            "nota":nota,
            "bid":bid,
            "status":status
        ]
    }

    
}



//
//  DemoCell.swift
//  FoldingCell
//
//  Created by Alex K. on 25/12/15.
//  Copyright © 2015 Alex K. All rights reserved.
//

import UIKit
import FoldingCell
import YBAlertController
import SCLAlertView
import OneSignal

extension Int {
    func format(f: String) -> String {
        return String(format: "%\(f)d", self)
    }
}

class DemoCell: FoldingCell {

  
  @IBOutlet weak var closeNumberLabel: UILabel!
  @IBOutlet weak var openNumberLabel: UILabel!
    
  var number: Int = 0 {
    didSet {
      closeNumberLabel.text = String((number + 1).format(f: "02"))
      openNumberLabel.text = "\((number + 1).format(f: "02"))"
    }
  }
  override func awakeFromNib() {
    
    foregroundView.layer.cornerRadius = 10
    foregroundView.layer.masksToBounds = true
    
    optionEnableDisable.addTarget(self, action: #selector(DemoCell.stateChangedOption), for: UIControlEvents.valueChanged)
    
    super.awakeFromNib()
  }
   
  override func animationDuration(_ itemIndex:NSInteger, type:AnimationType)-> TimeInterval {
    
    let durations = [0.26, 0.2, 0.2]
    return durations[itemIndex]
  }
    
  func stateChangedOption(){
        if(optionEnableDisable.isOn){
            
            UIView.animate(withDuration: 1, animations: {
                self.view_disable.alpha = 0
            }, completion: nil)

            OneSignal.postNotification(["contents": ["en": "A \(tap.cerveja) da \(tap.cervejaria) foi plugada em nossas torneiras. :)"],"include_player_ids" : ["7348f1b1-f1ed-4ac7-b5b4-195a01735abc","3600a1df-95c7-4f14-8ec8-0fa52aa8a4c7","786e88c5-db74-4dcc-a88b-daa38e653581"],
                                        "subtitle" :["en" : "Nova torneira disponível"],"ios_attachments" : ["id1" : tap.cerveja_img_url]], onSuccess: { (_: Any) in }, onFailure: { (error) in
                print(error as Any)
            })

        }else{
            
            UIView.animate(withDuration: 1, animations: {
                self.view_disable.alpha = 0.8
            }, completion: nil)
            
            OneSignal.postNotification(["contents": ["en": "A \(tap.cerveja) foi desativada para troca de barril ou manutenção. :/\nDaqui a pouco iremos plugar novamente."],"include_player_ids" : ["786e88c5-db74-4dcc-a88b-daa38e653581","3600a1df-95c7-4f14-8ec8-0fa52aa8a4c7","7348f1b1-f1ed-4ac7-b5b4-195a01735abc"],
                                        "subtitle" :["en" : "Torneira desativada"]], onSuccess: { (_: Any) in }, onFailure: { (error) in
                                            print(error as Any)
            })
        }
    
    let tapUpdate = Tap(abv: tap.abv, ibu: tap.ibu, cerveja: tap.cerveja, cervejaria: tap.cervejaria, estilo: tap.estilo, nota: tap.nota, cervejaria_img_url: tap.cervejaria_img_url, cerveja_img_url: tap.cerveja_img_url, bid: tap.bid, data_entrada:tap.data_entrada,status:optionEnableDisable.isOn == true ? "ativado" : "desativado",medidas:tap.medidas)
        tapUpdate.update(uid: tap.uid) { (error) in
            if error != nil {
                print(error!)
            }
        }
    }
}

extension DemoCell {
  
  @IBAction func buttonHandler(_ sender: AnyObject) {
    
    }
}

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

extension Int {
    func format(f: String) -> String {
        return String(format: "%\(f)d", self)
    }
}

class DemoCell: FoldingCell {

  
  @IBOutlet weak var closeNumberLabel: UILabel!
  @IBOutlet weak var openNumberLabel: UILabel!
  @IBOutlet weak var option1: UISwitch!
  @IBOutlet weak var option2: UISwitch!
    
  var number: Int = 0 {
    didSet {
      closeNumberLabel.text = String((number + 1).format(f: "02"))
      openNumberLabel.text = "\((number + 1).format(f: "02"))"
    }
  }
  override func awakeFromNib() {
    
    foregroundView.layer.cornerRadius = 10
    foregroundView.layer.masksToBounds = true
    
    option1.addTarget(self, action: #selector(DemoCell.stateChangedOption1), for: UIControlEvents.valueChanged)
    option2.addTarget(self, action: #selector(DemoCell.stateChangedOption2), for: UIControlEvents.valueChanged)
    
    optionEnableDisable.addTarget(self, action: #selector(DemoCell.stateChangedOption), for: UIControlEvents.valueChanged)
    
    super.awakeFromNib()
  }
   
  override func animationDuration(_ itemIndex:NSInteger, type:AnimationType)-> TimeInterval {
    
    let durations = [0.26, 0.2, 0.2]
    return durations[itemIndex]
  }
    
  func stateChangedOption1(){
    if(option2.isOn){
        option2.setOn(false, animated: true)
    }
  }
    
  func stateChangedOption2(){
    if(option1.isOn){
        option1.setOn(false, animated: true)
    }
  }
    
  func stateChangedOption(){
        if(optionEnableDisable.isOn){
            
            UIView.animate(withDuration: 1, animations: {
                self.view_disable.alpha = 0
            }, completion: nil)

        }else{
            
            UIView.animate(withDuration: 1, animations: {
                self.view_disable.alpha = 0.8
            }, completion: nil)
        }
    
    let tapStatusUpdate = Tap(abv: tap.abv, ibu: tap.ibu, cerveja: tap.cerveja, cervejaria: tap.cervejaria, estilo: tap.estilo, nota: tap.nota, cervejaria_img_url: tap.cervejaria_img_url, cerveja_img_url: tap.cerveja_img_url, bid: tap.bid, data_entrada:tap.data_entrada,status:optionEnableDisable.isOn == true ? "ativado" : "desativado")
        tapStatusUpdate.updateStatus(uid: tap.uid) { (error) in
            if error != nil {
                print(error!)
            }
        }
    }
}

extension DemoCell {
  
  @IBAction func buttonHandler(_ sender: AnyObject) {
    
    if(option1.isOn || option2.isOn){
        
        let alertController = YBAlertController(title: "Quantidade", message: "Quantas \(tap.cerveja) de \(option1.isOn ? tap.medidas[0].quantidade : tap.medidas[1].quantidade) deseja?", style: .actionSheet)
        alertController.touchingOutsideDismiss = true
        alertController.buttonIconColor = UIColor(red: 255/255, green: 212/255, blue: 0/255, alpha: 1.0)
        alertController.cancelButtonTitle = "Cancelar"
        for i in 1 ..< 6 {
            if(i == 1){
                alertController.addButton(UIImage(named: "cup"), title: "\(String(describing: String(i.format(f: "02"))))", action: {
                    
                    SCLAlertView().showTitle(
                        "Cheers!",
                        subTitle: "\(i) cerveja \nSeu pedido já foi enviado.\nDaqui a pouco seu cartão virtual irá ser chamado.",
                        duration: 0.0,
                        completeText: "Ok",
                        style: .success,
                        colorStyle: 0xFFD400,
                        colorTextButton: 0xFFFFFF
                    )
                    
                })
            }else{
                alertController.addButton(UIImage(named: "cup"), title: "\(String(describing: String(i.format(f: "02"))))", action: {
                    
                    SCLAlertView().showTitle(
                        "Cheers!",
                        subTitle: "\(i) cervejas \nSeu pedido já foi enviado.\nDaqui a pouco seu cartão virtual irá ser chamado.",
                        duration: 0.0,
                        completeText: "Ok",
                        style: .success,
                        colorStyle: 0xFFD400,
                        colorTextButton: 0xFFFFFF
                    )
                    
                })
            }
        }
        
        alertController.show()
        
    }else{
        
        SCLAlertView().showTitle(
            ":(",
            subTitle: "É preciso escolher uma das opções de medida.",
            duration: 0.0,
            completeText: "Ok",
            style: .info,
            colorStyle: 0xFFD400,
            colorTextButton: 0xFFFFFF
        )
    }
  }
}

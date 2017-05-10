//
//  MainQuantPrecoTableViewController.swift
//  BeerBeaconAdmin
//
//  Created by Bruno Corrêa on 09/05/17.
//  Copyright © 2017 Br4Dev. All rights reserved.
//

import UIKit
import Kingfisher

class MainQuantPrecoTableViewController: UITableViewController {

    @IBOutlet weak var cerveja_img: UIImageView!
    @IBOutlet weak var op01Slide: UISlider!
    @IBOutlet weak var op01TextField: UITextField!
    @IBOutlet weak var op02Slide: UISlider!
    @IBOutlet weak var op02TextField: UITextField!
    @IBOutlet weak var op01Ml: UILabel!
    @IBOutlet weak var op02Ml: UILabel!
    
    var tapSelecionado = Tap()
    let step: Float = 5
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.backBarButtonItem?.title = tapSelecionado.cerveja
        
        if(!self.tapSelecionado.cerveja_img_url.isEmpty){
            let urlCv = URL(string: self.tapSelecionado.cerveja_img_url)
            self.cerveja_img.kf.setImage(with: urlCv, options: [.transition(.fade(0.2))])
            self.cerveja_img.kf.indicatorType = .activity
            self.cerveja_img.kf.setImage(with: urlCv)
        }
        
        op01TextField.addTarget(self, action: #selector(op01TextFieldDidChange), for: .editingChanged)
        op02TextField.addTarget(self, action: #selector(op02TextFieldDidChange), for: .editingChanged)
        
        op01Slide.addTarget(self, action: #selector(sliderValueChangedOp01), for: .valueChanged)
        op02Slide.addTarget(self, action: #selector(sliderValueChangedOp02), for: .valueChanged)

    }
    
    func op01TextFieldDidChange(_ textField: UITextField) {
        
        if let amountString = textField.text?.currencyInputFormatting() {
            textField.text = amountString
        }
    }
    
    func op02TextFieldDidChange(_ textField: UITextField) {
        
        if let amountString = textField.text?.currencyInputFormatting() {
            textField.text = amountString
        }
    }
    
    @IBAction func sliderValueChangedOp01(sender: UISlider) {
        let currentValue = round(sender.value / step) * step
        sender.value = currentValue
        op01Ml.text = "\(Int(currentValue))"
    }
    
    @IBAction func sliderValueChangedOp02(sender: UISlider) {
        let currentValue = round(sender.value / step) * step
        sender.value = currentValue
        op02Ml.text = "\(Int(currentValue))"
    }

    @IBAction func buttonHandler(_ sender: AnyObject) {
        
        
        let medida = Medida(preco: op01TextField.text!, quantidade: "\(op01Ml.text!) ml")
        let medida2 = Medida(preco: op02TextField.text!, quantidade: "\(op02Ml.text!) ml")
        
        var med = [Medida]()
        med.append(medida)
        med.append(medida2)
        
        let newTap = Tap(abv: tapSelecionado.abv, ibu: tapSelecionado.ibu, cerveja: tapSelecionado.cerveja, cervejaria: tapSelecionado.cervejaria, estilo: tapSelecionado.estilo, nota: (Double(self.tapSelecionado.nota)?.format(f: ".2"))!, cervejaria_img_url: tapSelecionado.cervejaria_img_url, cerveja_img_url: tapSelecionado.cerveja_img_url, bid: tapSelecionado.bid, data_entrada: Int(Date().timeIntervalSince1970),status:"desativado",medidas:med)
        
        newTap.save { (error) in
            if error != nil{
                print(error!)
            }
        }
    }
}

extension String {
    
    // formatting text for currency textField
    func currencyInputFormatting() -> String {
        
        var number: NSNumber!
        let formatter = NumberFormatter()
        formatter.numberStyle = .currencyAccounting
        formatter.currencySymbol = "R$ "
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        
        var amountWithPrefix = self
        
        // remove from String: "$", ".", ","
        let regex = try! NSRegularExpression(pattern: "[^0-9]", options: .caseInsensitive)
        amountWithPrefix = regex.stringByReplacingMatches(in: amountWithPrefix, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.characters.count), withTemplate: "")
        
        let double = (amountWithPrefix as NSString).doubleValue
        number = NSNumber(value: (double / 100))
        
        // if first number is 0 or all numbers were deleted
        guard number != 0 as NSNumber else {
            return ""
        }
        
        return formatter.string(from: number)!
    }
}

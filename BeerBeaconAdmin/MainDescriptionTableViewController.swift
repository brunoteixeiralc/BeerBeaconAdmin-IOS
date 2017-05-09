//
//  MainDescriptionTableViewController.swift
//  BeerBeaconAdmin
//
//  Created by Bruno Lemgruber on 05/05/17.
//  Copyright © 2017 Br4Dev. All rights reserved.
//

import UIKit
import KVNProgress
import Alamofire
import Kingfisher

extension Double {
    func format(f: String) -> String {
        return String(format: "%\(f)f", self)
    }
}


class MainDescriptionTableViewController: UITableViewController {

    @IBOutlet weak var cervejariaLabel: UILabel!
    @IBOutlet weak var emProducaoLabel: UILabel!
    @IBOutlet weak var abvLabel: UILabel!
    @IBOutlet weak var ibuLabel: UILabel!
    @IBOutlet weak var estiloLabel: UILabel!
    @IBOutlet weak var mediaLabel: UILabel!
    @IBOutlet weak var descricaoLabel: UITextView!
    @IBOutlet weak var cerveja_img: UIImageView!
    @IBOutlet weak var plugarBtn: UIButton!

    var tapSelecionado = Tap()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupConfig()
        KVNProgress.show(withStatus: "Carregando", on: view)
        
        getBeer(bid: tapSelecionado.bid)
    }
    
    @IBAction func buttonHandler(_ sender: AnyObject) {
        
        let newTap = Tap(abv: tapSelecionado.abv, ibu: tapSelecionado.ibu, cerveja: tapSelecionado.cerveja, cervejaria: tapSelecionado.cervejaria, estilo: tapSelecionado.estilo, nota: (Double(self.tapSelecionado.nota)?.format(f: ".2"))!, cervejaria_img_url: tapSelecionado.cervejaria_img_url, cerveja_img_url: tapSelecionado.cerveja_img_url, bid: tapSelecionado.bid, data_entrada: Int(Date().timeIntervalSince1970),status:"desativado")
        newTap.save { (error) in
            if error != nil{
               print(error!)
            }
        }
    }
    
    func getBeer(bid:Int){
        
        let p: Parameters = ["client_secret":"E0897A98862FB4E023CE3C0DD7E374103CEFF5A0",
                             "client_id":"06E50AB61747E247A8E9B6FE61B219C527770491"]
        
        Alamofire.request("https://api.untappd.com/v4/beer/info/\(bid)",parameters:p).validate().responseJSON { ( response) in
            print(response.request ?? "")  // original URL request
            print(response.response ?? "") // HTTP URL response
            print(response.data ?? "")     // server data
            print(response.result)   // result of response serialization
            
            guard response.result.isSuccess else {
                print("Error while fetching: \(String(describing: response.result.error))")
                return
            }
            
            guard let responseJSON = response.result.value as? [String: Any],
                let results = responseJSON["response"] as? [String: Any],
                let beer = results["beer"] as? [String:Any] else {return}
            
            
                self.tapSelecionado.descricao = beer["beer_description"] as! String
                self.tapSelecionado.em_producao = beer["is_in_production"] as! Int
                self.tapSelecionado.nota = String(beer["rating_score"] as! Double)
                self.tapSelecionado.cerveja_img_url = beer["beer_label_hd"] as! String
            
            
                self.cervejariaLabel.text = self.tapSelecionado.cervejaria
                self.abvLabel.text = "\(self.tapSelecionado.abv)%"
                self.ibuLabel.text = String(self.tapSelecionado.ibu)
                self.estiloLabel.text = self.tapSelecionado.estilo
                self.emProducaoLabel.text = self.tapSelecionado.em_producao == 1 ? "Sim" : "Não"
                self.mediaLabel.text = Double(self.tapSelecionado.nota)?.format(f: ".2")
                self.descricaoLabel.text = self.tapSelecionado.descricao.isEmpty ? "Nenhuma descrição" : self.tapSelecionado.descricao
            
                let urlCv = URL(string: self.tapSelecionado.cerveja_img_url)
                self.cerveja_img.kf.setImage(with: urlCv, options: [.transition(.fade(0.2))])
                self.cerveja_img.kf.indicatorType = .activity
                self.cerveja_img.kf.setImage(with: urlCv)
            
                KVNProgress.dismiss()
        }

    }
    
    func setupConfig() {
        let Basic = KVNProgressConfiguration()
        Basic.statusColor = UIColor.white
        Basic.circleStrokeForegroundColor = UIColor.white
        Basic.circleStrokeBackgroundColor = UIColor.white
        Basic.circleSize = 80.0
        Basic.lineWidth = 1.5
        Basic.isFullScreen = false
        Basic.backgroundFillColor = UIColor(red: 255/255, green: 212/255, blue: 0/255, alpha: 0.9)
        
        KVNProgress.setConfiguration(Basic)
    }
}

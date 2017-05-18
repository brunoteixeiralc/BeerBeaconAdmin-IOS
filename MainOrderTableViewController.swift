//
//  MainOrderTableViewController.swift
//  BeerBeaconAdmin
//
//  Created by Bruno Corrêa on 15/05/17.
//  Copyright © 2017 Br4Dev. All rights reserved.
//

import UIKit
import OneSignal

class MainOrderTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderCell", for: indexPath) as! OrderCell
        
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            
            OneSignal.postNotification(["contents": ["en": "O seu pedido já foi feito. Daqui a pouco você irá receber sua cerveja.Cheers!"],"include_player_ids" : ["7348f1b1-f1ed-4ac7-b5b4-195a01735abc","3600a1df-95c7-4f14-8ec8-0fa52aa8a4c7","786e88c5-db74-4dcc-a88b-daa38e653581"],
                                        "subtitle" :["en" : "Cartão Virtual : 01"]], onSuccess: { (_: Any) in }, onFailure: { (error) in
                                            print(error as Any)
            })

            tableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "Pronto!"
    }

}

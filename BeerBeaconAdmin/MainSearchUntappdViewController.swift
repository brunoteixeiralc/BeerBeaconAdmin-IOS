//
//  MainSearchUntappdViewController.swift
//  BeerBeaconAdmin
//
//  Created by Bruno Corrêa on 26/04/17.
//  Copyright © 2017 Br4Dev. All rights reserved.
//

import UIKit

class MainSearchUntappdViewController:UITableViewController{
 
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.extendedLayoutIncludesOpaqueBars = true
        
        searchController.searchResultsUpdater = self as? UISearchResultsUpdating
        searchController.hidesNavigationBarDuringPresentation = true
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Cervejas, Cervejarias"
        searchController.searchBar.sizeToFit()
        searchController.searchBar.tintColor = UIColor(red: 255/255, green: 212/255, blue: 0/255, alpha: 1.0)
        searchController.searchBar.barTintColor = UIColor.white
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar

    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "untappdCell", for: indexPath)
        
        return cell
    }
}

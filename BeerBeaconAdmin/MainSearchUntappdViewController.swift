//
//  MainSearchUntappdViewController.swift
//  BeerBeaconAdmin
//
//  Created by Bruno Corrêa on 26/04/17.
//  Copyright © 2017 Br4Dev. All rights reserved.
//

import UIKit
import Alamofire
import KVNProgress

class MainSearchUntappdViewController:UITableViewController{
 
    let searchController = UISearchController(searchResultsController: nil)
    var taps = [Tap]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupConfig()

        self.extendedLayoutIncludesOpaqueBars = true
        
        searchController.searchResultsUpdater = self
        searchController.hidesNavigationBarDuringPresentation = true
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Cervejas, Cervejarias"
        searchController.searchBar.sizeToFit()
        searchController.searchBar.tintColor = UIColor(red: 255/255, green: 212/255, blue: 0/255, alpha: 1.0)
        searchController.searchBar.barTintColor = UIColor.white
        searchController.searchBar.delegate = self
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar

    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.taps.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "UntappdCell", for: indexPath) as! UntappdCell
        
        cell.tap = taps[(indexPath as NSIndexPath).row]
        
        return cell

    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func filterContentForSearchText(searchText: String) {
        
       // if(searchText.characters.count >= 4){
           KVNProgress.show(withStatus: "Procurando", on: view)
           getBeer(query: searchText)
       // }

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

    
    func getBeer(query:String){
        
        self.taps.removeAll()
        
        let p: Parameters = ["q":query,
                                      "client_secret":"E0897A98862FB4E023CE3C0DD7E374103CEFF5A0",
                                      "client_id":"06E50AB61747E247A8E9B6FE61B219C527770491"]

        Alamofire.request("https://api.untappd.com/v4/search/beer",parameters:p).validate().responseJSON { ( response) in
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
                let beers = results["beers"] as? [String:Any],
                let items = beers["items"] as? [[String:Any]] else {return}
            
                for item in items{
                    
                    let tap:Tap = Tap()
                    
                    let beer = item["beer"] as? [String:Any]
                    tap.cerveja = beer?["beer_name"] as! String
                    tap.estilo = beer?["beer_style"] as! String
                    tap.cerveja_img_url = beer?["beer_label"] as! String
                    
                    let brewery = item["brewery"] as? [String:Any]
                    tap.cervejaria = brewery?["brewery_name"] as! String
                    
                    self.taps.append(tap)
                }
            
                KVNProgress.dismiss()
                self.tableView.reloadData()
            }

        }
  
  }

extension MainSearchUntappdViewController:UISearchResultsUpdating,UISearchBarDelegate{
    @available(iOS 8.0, *)
    func updateSearchResults(for searchController: UISearchController) {
        //filterContentForSearchText(searchText: searchController.searchBar.text!)
    }

    func updateSearchResultsForSearchController(searchController: UISearchController) {
        //filterContentForSearchText(searchText: searchController.searchBar.text!)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        KVNProgress.show(withStatus: "Procurando", on: view)
        getBeer(query: searchController.searchBar.text!)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(self.callWsUntappd), object: nil)
        self.perform(#selector(self.callWsUntappd), with: nil, afterDelay: 1.5)
    }
    
    func callWsUntappd() {
        filterContentForSearchText(searchText: searchController.searchBar.text!)
    }
    
}



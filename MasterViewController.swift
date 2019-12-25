//
//  MasterViewController.swift
//  App
//
//  Created by Shaun Yang on 11/21/19.
//  Copyright © 2019 Shaun Yang. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class MasterViewController: UIViewController,UISearchBarDelegate {
    
    
    @IBOutlet weak var newTopSearchTableView: UITableView!
    var Predictions = JSON()
    var selectedData :JSON!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()        
        self.newTopSearchTableView.layer.cornerRadius = 10;
        
        
        setNaviBarSearch()
        setTopsearchResultTable()
    }
    
    
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        print("reload here")
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    func setNaviBarSearch(){
        let searchBar = UISearchBar()
        searchBar.sizeToFit()
        searchBar.delegate = self
        searchBar.placeholder = "Enter City Name"
        self.navigationItem.titleView = searchBar
        
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        self.ViewControllerHome = self.homeVC?.RootVC
        self.newTopSearchTableView.dataSource = self
        self.newTopSearchTableView.delegate = self
        if (searchText == ""){

            self.newTopSearchTableView.isHidden = true

        }else{
            self.newTopSearchTableView.isHidden = false
            self.sendAutocomplete(searchText)
        }


    }
    
    func sendAutocomplete(_ data:String){
        AF.request("https://hw7-nodejs.appspot.com/autocomplete?text=" + data).responseJSON { (responseData) -> Void in
            if((responseData.data) != nil) {
                let swiftyJsonVar = JSON(responseData.data!)
                self.Predictions = swiftyJsonVar["predictions"]
                DispatchQueue.main.async{
                    self.newTopSearchTableView.reloadData()
                }
                
            }
            
            
        }
        
        
    }
    
    var IsItHomePage:Bool!
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destination = segue.destination
        
        if let vc = destination as? SearchResultViewController {
            vc.cityText = self.selectedData["description"].stringValue
            
            
        }
        
    }
    
    func setTopsearchResultTable(){
        self.newTopSearchTableView.register(TopSearchCellView.self, forCellReuseIdentifier: "topSearchID")
        self.newTopSearchTableView.isHidden = true
        
    }
    
}



extension MasterViewController:UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (tableView ==  self.newTopSearchTableView){
            let celldata = self.Predictions[indexPath.row]
            self.selectedData = celldata
            
            self.newTopSearchTableView.isHidden = true
            self.performSegue(withIdentifier: "SearchResultPage", sender: self)
            
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if (tableView ==  self.newTopSearchTableView){
            if ( self.Predictions.count == 0){
                self.newTopSearchTableView.isHidden = true
            }else{
                
                self.newTopSearchTableView.isHidden = false
            }
            return  self.Predictions.count
        }
        return 0
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if (tableView ==  self.newTopSearchTableView){
            
            let celldata =  self.Predictions[indexPath.row]
            let cellView = tableView.dequeueReusableCell(withIdentifier: "topSearchID") as! TopSearchCellView
            cellView.setTopcell(JSON(celldata))
            return cellView
            
        }
        
        return UITableViewCell()
        
    }
    
}

//
//  SearchResultViewController.swift
//  App
//
//  Created by Shaun Yang on 11/20/19.
//  Copyright © 2019 Shaun Yang. All rights reserved.
//

import UIKit
import SwiftyJSON
import Toast_Swift
import SwiftSpinner
class SearchResultViewController: UIViewController {
    
    var cityText : String?=""
    var myPageViewController: PageViewController?
    var ChildView:ViewController!
    override func viewDidLoad() {
        self.demoSpinner()
        super.viewDidLoad()
        
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destination = segue.destination
        if let vc = destination as? ViewController {
            self.ChildView = vc
            vc.isSearchByText = true
            vc.searchResultVC = self
            vc.SearchText = cityText!
            
            
            
            
        }
        
    }
    
    
    
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        SwiftSpinner.show("")
        return true
    }
    func delay(seconds: Double, completion: @escaping () -> ()) {
        let popTime = DispatchTime.now() + Double(Int64( Double(NSEC_PER_SEC) * seconds )) / Double(NSEC_PER_SEC)
        
        DispatchQueue.main.asyncAfter(deadline: popTime) {
            completion()
        }
    }
    func demoSpinner() {
        UIView.animate(withDuration:1) {
            self.view.transform = .identity
        }
        SwiftSpinner.show(delay: 0.0, title: "Fetching Weather Details for " + cityText! + "...", animated: true)
        
        self.delay(seconds: 2.0,completion: {
            SwiftSpinner.hide()
        })
        
    }
    
    
    
    
    
    
    
    
    
}

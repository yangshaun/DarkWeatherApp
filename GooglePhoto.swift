//
//  GooglePhoto.swift
//  App
//
//  Created by Shaun Yang on 11/18/19.
//  Copyright © 2019 Shaun Yang. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import SwiftSpinner
class GooglePhoto: UIViewController,UIScrollViewDelegate {

    @IBOutlet weak var ScrollerView: UIScrollView!
    var CityName :String!=""
    
    override func viewDidLoad() {
        demoSpinner()
        super.viewDidLoad()
//        setGooglePhoto()
        sendHttpRequest()
        ScrollerView.delegate = self
        
    }
    
    func fetchPhoto(_ LinkArray:[String]){
        
        var size = 0.0
        var yPosition = 0.0
        let imageContentHeight = 450.0
        for i in 0..<LinkArray.count{
            let imageView = UIImageView()
            let newImage = UIImage(data: try! Data(contentsOf:  URL(string:  LinkArray[i])!))
            imageView.image = newImage
            imageView.frame = CGRect(x: 0, y: CGFloat(yPosition), width: ScrollerView.frame.width, height: CGFloat(imageContentHeight))
            imageView.contentMode = .scaleToFill
            
            yPosition = yPosition + Double(imageContentHeight)
            size = size + Double(imageContentHeight)
            ScrollerView.addSubview(imageView)
            print(imageContentHeight)
            print(size)
            print(yPosition)
        }
        ScrollerView.contentSize.height = CGFloat(size)
        
        
    }
    func getallLink(_ data:JSON){
        let datalist = data.arrayValue
        let mini = min(5, datalist.count)
        var URLlist = [String]()
        for i in 0..<mini{
            URLlist.append(datalist[i]["link"].rawString()!)
        }
        fetchPhoto(URLlist)
    }
    func sendHttpRequest(){
        AF.request("https://hw7-nodejs.appspot.com/customsearchALL?text=picture+of+"+String(self.CityName).replacingOccurrences(of: " ", with: "+")).responseJSON { (responseData) -> Void in
            
            if((responseData.data) != nil) {
                let swiftyJsonVar = JSON(responseData.data!)
                self.getallLink(swiftyJsonVar["items"])
                DispatchQueue.main.async {
                    
                }
                
                
            }
            
            
        }
        
    }
    
    
    
  
    
    
    
    func delay(seconds: Double, completion: @escaping () -> ()) {
        let popTime = DispatchTime.now() + Double(Int64( Double(NSEC_PER_SEC) * seconds )) / Double(NSEC_PER_SEC)
        
        DispatchQueue.main.asyncAfter(deadline: popTime) {
            completion()
        }
    }
    
    func demoSpinner() {
        UIView.animate(withDuration: 1) {
            self.ScrollerView.transform = .identity
        }
        SwiftSpinner.show(delay: 0.0, title: "Fetching Google Images...", animated: true)
        
        self.delay(seconds: 2.0,completion: {
            SwiftSpinner.hide()
        })
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
}

//
//  DetailToday.swift
//  App
//
//  Created by Shaun Yang on 11/17/19.
//  Copyright © 2019 Shaun Yang. All rights reserved.
//

import UIKit
import SwiftyJSON
class DetailToday: UIViewController {

    var today:JSON!
    var cityname:String!
    var temperature:String!
    var Summary:String!
    
    @IBOutlet weak var IconText: UILabel!
    @IBOutlet weak var IconImage: UIImageView!
    
    
    @IBOutlet weak var WindSpeedText: UILabel!
    @IBOutlet weak var PressureText: UILabel!
    @IBOutlet weak var PrecipitationText: UILabel!
    @IBOutlet weak var TemperatureText: UILabel!
    @IBOutlet weak var HumidityText: UILabel!
    @IBOutlet weak var VisibilityText: UILabel!
    @IBOutlet weak var CloudCoverText: UILabel!
    @IBOutlet weak var OzoneText: UILabel!
    
    
    @IBOutlet weak var DetailWindSpeedView: UIView!
    @IBOutlet weak var DetailPressureView: UIView!
    @IBOutlet weak var DetailPrecipitationView: UIView!
    @IBOutlet weak var DetaulTemperatureView: UIView!
    @IBOutlet weak var DetailSummaryView: UIView!
    
    @IBOutlet weak var DetailHumidityView: UIView!
    @IBOutlet weak var DetailVisibilityView: UIView!
    @IBOutlet weak var DetailCloudoverView: UIView!
    @IBOutlet weak var DetailOzoneView: UIView!
    
    
    var CopyVC:ViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setCompopentView()
        
        if CopyVC.isSearchByText == true {
            let backItem = UIBarButtonItem()
            backItem.title =  self.cityname
            self.navigationController?.navigationBar.topItem?.backBarButtonItem = backItem
            
        }else{
            
            let backItem = UIBarButtonItem()
            backItem.title = "Weather"
            self.navigationController?.navigationBar.topItem?.backBarButtonItem = backItem
            
        }
        
        self.setImgText()
    }
    @objc func sayHello(sender: UIBarButtonItem) {
        
        let twitter_text = "https://twitter.com/intent/tweet?text=The Current Weather at " + self.cityname + " is " + self.temperature + "°F. The weather condition are " + self.Summary + ". #CSCI571WeatherSearch";
        
        let url = URL(string: twitter_text.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
        print (twitter_text)
    }
    func setImgText(){
        
        
        
        
        let navLabel = UILabel()
        let navTitle = NSMutableAttributedString(string: self.cityname, attributes:[
            NSAttributedString.Key.foregroundColor: UIColor.black,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17.0, weight: UIFont.Weight.semibold)])
        
        navLabel.attributedText = navTitle
        self.parent!.navigationItem.titleView = navLabel;
        
        
//        let imageView = UIImageView()
        
        let myImage = UIImage(named: "twitter")?.imageWithColor(color: UIColor(red:0.11, green:0.63, blue:0.95, alpha:1.0))
        myImage!.withRenderingMode(.alwaysTemplate)
        
        let btn = UIButton(type: .custom)
        btn.setImage(myImage, for: .normal)
        btn.addTarget(self, action: #selector(sayHello), for: .touchUpInside)
        
        let buttonItem = UIBarButtonItem(customView: btn)
        
        
        self.parent!.navigationItem.rightBarButtonItem = buttonItem
       
        
        
        //====================
        
        
        IconImage.image = self.setCurrentImg(today!["icon"].rawString()!)
        IconText.text = today!["summary"].rawString()!
        
        //====================
    
        
        
        
        var winSpeedstr : String? = ""
        var Pressurestr : String? = ""
        var Precipitationstr : String? = ""
        var Temperaturestr : String? = ""
        var Humiditystr : String? = ""
        var Visibilitystr : String? = ""
        var CloudCoverstr : String? = ""
        var Ozonestr : String? = ""
        
        if !(today["windSpeed"].stringValue ?? "").isEmpty{
            winSpeedstr = String(Double(round(Double(today["windSpeed"].stringValue)! * 100)/100.0))
        }
        if !(today["pressure"].stringValue ?? "").isEmpty{
            Pressurestr =  String(Double(round(Double(today["pressure"].stringValue)! * 100)/100.0))
        }
        if !(today["precipIntensity"].stringValue ?? "").isEmpty{
            Precipitationstr =   String(Double(round(Double(today["precipIntensity"].stringValue)! * 100)/100.0))
        }
        
        if !(today["temperature"].stringValue ?? "").isEmpty{
            Temperaturestr =  String(Double(round(Double(today["temperature"].stringValue)! * 100)/100.0))
        }
        
        if !(today["humidity"].stringValue ?? "").isEmpty{
            Humiditystr =  String(Double(round(Double(today["humidity"].stringValue)! * 100)/100.0))
        }
        
        
        if !(today["visibility"].stringValue ?? "").isEmpty{
            Visibilitystr =  String(Double(round(Double(today["visibility"].stringValue)! * 100)/100.0))
        }
        
        
        if !(today["cloudCover"].stringValue ?? "").isEmpty{
            CloudCoverstr =  String(Double(round(Double(today["cloudCover"].stringValue)! * 100)/100.0))
        }
        
        if !(today["ozone"].stringValue ?? "").isEmpty{
            Ozonestr =  String(Double(round(Double(today["ozone"].stringValue)! * 100)/100.0))
        }
        
        
        WindSpeedText.text = winSpeedstr! + " mph"
        WindSpeedText.sizeToFit()
        PressureText.text = Pressurestr! + " mb"
        PressureText.sizeToFit()
        PrecipitationText.text = Precipitationstr! + " mmph"
        PrecipitationText.sizeToFit()
        TemperatureText.text = Temperaturestr! + " °F"
        TemperatureText.sizeToFit()
        HumidityText.text = Humiditystr! + " %"
        HumidityText.sizeToFit()
        VisibilityText.text = Visibilitystr! + " km"
        VisibilityText.sizeToFit()
        CloudCoverText.text = CloudCoverstr! + " %"
        CloudCoverText.sizeToFit()
        OzoneText.text = Ozonestr! + " DU"
        OzoneText.sizeToFit()
        
    }
    
    func setCompopentView(){
        DetailWindSpeedView.layer.cornerRadius = 7;
        DetailPressureView.layer.cornerRadius = 7;
        DetailPrecipitationView.layer.cornerRadius = 7;
        DetaulTemperatureView.layer.cornerRadius = 7;
        DetailSummaryView.layer.cornerRadius = 7;
        DetailHumidityView.layer.cornerRadius = 7;
        DetailVisibilityView.layer.cornerRadius = 7;
        DetailCloudoverView.layer.cornerRadius = 7;
        DetailOzoneView.layer.cornerRadius = 7;

    }
    
    func setCurrentImg(_ icon:String)-> UIImage{
        if icon == "clear-day"{
            return UIImage(named: "weather-sunny")!
        }
        else if icon == "clear-night"{
            return  UIImage(named: "weather-night")!
        }else if icon == "rain"{
            return  UIImage(named: "weather-rainy")!
        }else if icon == "snow"{
            return  UIImage(named: "weather-snowy")!
        }else if icon == "sleet"{
            return  UIImage(named: "weather-partly-snowy-rainy")!
        }else if icon == "wind"{
            return  UIImage(named: "weather-windy")!
        }else if icon == "fog"{
            return UIImage(named: "weather-fog")!
        }else if icon == "cloudy"{
            return  UIImage(named: "weather-cloudy")!
        }else if icon == "partly-cloudy-day"{
            return UIImage(named: "weather-partly-cloudy")!
        }else if icon == "partly-cloudy-night"{
            return UIImage(named: "weather-night-partly-cloudy")!
        }else{
            return UIImage(named: "weather-sunny")!
        }
        
    }
}
extension UIImage {
    func imageWithColor(color: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        color.setFill()
        
        let context = UIGraphicsGetCurrentContext()
        context?.translateBy(x: 0, y: self.size.height)
        context?.scaleBy(x: 1.0, y: -1.0)
        context?.setBlendMode(CGBlendMode.normal)
        
        let rect = CGRect(origin: .zero, size: CGSize(width: self.size.width, height: self.size.height))
        context?.clip(to: rect, mask: self.cgImage!)
        context?.fill(rect)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
}

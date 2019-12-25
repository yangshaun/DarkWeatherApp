//
//  ViewController.swift
//  App
//
//  Created by Shaun Yang on 11/14/19.
//  Copyright © 2019 Shaun Yang. All rights reserved.
//

import UIKit
import SwiftyJSON
import CoreLocation
import Alamofire
import SwiftSpinner
class ViewController: UIViewController,CLLocationManagerDelegate {
    


    @IBOutlet weak var FavButton: UIButton!
    
    @IBOutlet weak var FirstSubView: UIView!
    @IBOutlet weak var ThirdTable: UITableView!
    @IBOutlet weak var SecondPressureText: UILabel!
    @IBOutlet weak var SecondVisibilityText: UILabel!
    @IBOutlet weak var SecondWindText: UILabel!
    @IBOutlet weak var SecondHumidityText: UILabel!
    @IBOutlet weak var CurrentImg: UIImageView!
    @IBOutlet weak var CurrentWeatherView: UIView!
    @IBOutlet weak var CurrentTempText: UILabel!
    @IBOutlet weak var CurrentSummaryText: UILabel!
    @IBOutlet weak var CurrentLocationText: UILabel!
    
//    var HompageRoot:PageViewController!
    
    var myPageViewController:PageViewController!
    var searchResultVC:SearchResultViewController!
    var AllDataCells = JSON()

    let locationManager = CLLocationManager()
    var location : CLLocationManager!;
    var DetailTodayData = JSON()
    var weeklyData = JSON()
    var CityName :String! = ""
// =====================================
    
    var isSearchByText:Bool!
    var SearchText :String!=""
    
// =====================================
    var autocompleteTEXT:String!=""

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setViewComponent();
        
        self.ThirdTable.delegate = self
        self.ThirdTable.dataSource = self
        
        if isSearchByText == true{
            self.toggleBtn(self.SearchText)
            self.sendHttpRequestBytext(self.SearchText)
//            isSearchByText = false
        }else{
            self.FavButton.isHidden = true
              self.getLocation();
        }
        setTweeter()
        
    }
    
    var temperature:String!
    var Summary:String!
    @objc func sayHello(sender: UIBarButtonItem) {
        
        let twitter_text = "https://twitter.com/intent/tweet?text=The Current Weather at " + self.CityName! + " is " + self.temperature +  "°F. The weather condition are " + self.Summary + ". #CSCI571WeatherSearch";
        
        let url = URL(string: twitter_text.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
        print (twitter_text)
    }
    
    
    
    func setTweeter(){
        
        let navLabel = UILabel()
        let navTitle = NSMutableAttributedString(string: self.CityName!, attributes:[
            NSAttributedString.Key.foregroundColor: UIColor.black,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17.0, weight: UIFont.Weight.semibold)])
        navLabel.attributedText = navTitle
        
        let myImage = UIImage(named: "twitter")?.imageWithColor(color: UIColor(red:0.11, green:0.63, blue:0.95, alpha:1.0))
        myImage!.withRenderingMode(.alwaysTemplate)
        
        let btn = UIButton(type: .custom)
        btn.setImage(myImage, for: .normal)
        btn.addTarget(self, action: #selector(sayHello), for: .touchUpInside)
        
        let buttonItem = UIBarButtonItem(customView: btn)
        
        if (searchResultVC != nil) {
            searchResultVC.navigationItem.titleView = navLabel
            searchResultVC.navigationItem.rightBarButtonItem = buttonItem
        }else if (myPageViewController != nil){
            myPageViewController.navigationItem.titleView = navLabel
            myPageViewController.navigationItem.rightBarButtonItem = buttonItem
        }
        
    }
    
    
    
    
    func setViewComponent(){
        CurrentWeatherView.layer.cornerRadius = 7;
        ThirdTable.layer.cornerRadius = 10;
        CurrentWeatherView.layer.borderColor = UIColor.white.cgColor
        CurrentWeatherView.layer.borderWidth = 1
        ThirdTable.layer.borderWidth = 1
        ThirdTable.layer.borderColor = UIColor.white.cgColor
        
        //================================================================
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(clickView(_:)))
        self.CurrentWeatherView.addGestureRecognizer(tapGesture)
        
    }
    func setCurrentImg(_ icon:String){
        print(icon)
        if icon == "clear-day"{
            CurrentImg.image = UIImage(named: "weather-sunny")
        }
        else if icon == "clear-night"{
            CurrentImg.image = UIImage(named: "weather-night")
        }else if icon == "rain"{
            CurrentImg.image = UIImage(named: "weather-rainy")
        }else if icon == "snow"{
            CurrentImg.image = UIImage(named: "weather-snowy")
        }else if icon == "sleet"{
            CurrentImg.image = UIImage(named: "weather-partly-snowy-rainy")
        }else if icon == "wind"{
            CurrentImg.image = UIImage(named: "weather-windy")
        }else if icon == "fog"{
            CurrentImg.image = UIImage(named: "weather-fog")
        }else if icon == "cloudy"{
            CurrentImg.image = UIImage(named: "weather-cloudy")
        }else if icon == "partly-cloudy-day"{
            CurrentImg.image = UIImage(named: "weather-partly-cloudy")
        }else if icon == "partly-cloudy-night"{
            CurrentImg.image = UIImage(named: "weather-night-partly-cloudy")
        }else{
            
        }
        
    }
    func setFirstSubView(_ current:JSON){
        
        let TempInt :String = String(Int(round(Double(current["temperature"].rawString()!)!)))
        self.temperature = TempInt
        CurrentTempText.text = TempInt + "°F"
        CurrentTempText.sizeToFit();
        self.Summary = current["summary"].stringValue
        CurrentSummaryText.text = current["summary"].rawString()!
        CurrentSummaryText.sizeToFit();
        setCurrentImg(current["icon"].rawString()!)
        //================================================
        
        
        let resultHumidity : String = String(Double(round(Double(current["humidity"].rawString()!)! * 100)/100.0))
        let resultWind : String = String(Double(round(Double(current["windSpeed"].rawString()!)! * 100)/100.0))
        let resultVisibility : String = String(Double(round(Double(current["visibility"].rawString()!)! * 100)/100.0))
        let resultPressure : String = String(Double(round(Double(current["pressure"].rawString()!)! * 100)/100.0))
        
        self.SecondHumidityText.text = resultHumidity + " %"
        self.SecondHumidityText.sizeToFit();
        self.SecondHumidityText.textAlignment = .center
        
        self.SecondWindText.text = resultWind + " mph"
        self.SecondWindText.sizeToFit();
        self.SecondWindText.textAlignment = .center
        
        self.SecondVisibilityText.text = resultVisibility + " km"
        self.SecondVisibilityText.textAlignment = .center
        self.SecondVisibilityText.sizeToFit();
        
        self.SecondPressureText.text = resultPressure + " mb"
        self.SecondPressureText.sizeToFit();
        self.SecondPressureText.textAlignment = .center
        
        
    }
    func sendHttpRequestBytext(_ textData:String){
        let cityraw =  textData
        let cityText :String! = cityraw.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
//        ==================
        self.CityName = String(cityraw.split(separator: ",")[0])
        self.CurrentLocationText.text = String(cityraw.split(separator: ",")[0])
        self.CurrentSummaryText.sizeToFit();
//        ===============
        AF.request("https://hw7-nodejs.appspot.com/googlegeoALL?text=" + String(cityText)).responseJSON { (responseData) -> Void in
            if((responseData.data) != nil) {
                let swiftyJsonVar = JSON(responseData.data!)
                var lat:String?
                var lng:String?
                lat = swiftyJsonVar["results"][0]["geometry"]["location"]["lat"].stringValue
                lng = swiftyJsonVar["results"][0]["geometry"]["location"]["lng"].stringValue
                if (lat ?? "").isEmpty{
                    return
                }
                if (lng ?? "").isEmpty {
                    return
                }
                self.sendHttpRequest(Double(String(lat!)) as! Double, Double(String(lng!))as! Double)
    
               
            }
            
            
        }
        
        
        
    }
    func getCityName(){
        
        AF.request("https://ipapi.co/json").responseJSON { (responseData) -> Void in
            if((responseData.data) != nil) {
                let swiftyJsonVar = JSON(responseData.data!)
                let city = swiftyJsonVar["city"].rawString()!
                print (city)
                self.CityName = city
                self.CurrentLocationText.text = self.CityName
                self.CurrentSummaryText.sizeToFit();
            }
            
            
        }
        
        
        
    }
    func sendHttpRequest(_ lat:Double,_ lon:Double){
            print(lat,lon)
        AF.request("https://hw7-nodejs.appspot.com/dark?lat="+String(lat)+"&lon="+String(lon)).responseJSON { (responseData) -> Void in
            if((responseData.data) != nil) {
                let swiftyJsonVar = JSON(responseData.data!)
                
                let currently = swiftyJsonVar["currently"]
                self.DetailTodayData = swiftyJsonVar["currently"]
                self.AllDataCells = swiftyJsonVar["daily"]["data"];
                self.weeklyData = swiftyJsonVar["daily"]
                print(swiftyJsonVar["timezone"].rawString()!)
                
                
                self.setFirstSubView(currently)
                
                DispatchQueue.main.async {
                    self.ThirdTable.reloadData()
                }
                
                
            }
            
            
        }
        
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            print (location.coordinate.latitude,location.coordinate.longitude,"!!!!")
            sendHttpRequest(location.coordinate.latitude,location.coordinate.longitude)
            self.getCityName()
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to find user's location: \(error.localizedDescription)")
    }
    func getLocation(){
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            location = CLLocationManager();
            location.delegate = self
            location.desiredAccuracy = kCLLocationAccuracyBest
            location.requestLocation()
            
        }else{
            print("not working")
            
        }
        
    }
    @objc func clickView(_ sender: UIView) {
        print("You clicked on view")
        
//        self.navigationItem.title = "penis"
        self.performSegue(withIdentifier: "newShowDetail", sender: self)
//        self.isFromMaster = false
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let barVC = segue.destination as? UITabBarController {
            barVC.viewControllers?.forEach {
                if let vc = $0 as? DetailToday {
                    vc.today =  JSON(self.DetailTodayData)
                    vc.cityname = self.CityName
                    vc.Summary = self.DetailTodayData["summary"].rawString()!
                    vc.temperature = self.DetailTodayData["temperature"].rawString()!
                    vc.CopyVC = self
                    
                }                
                if let vc2 = $0 as? WeeklyChart {
                    vc2.weekly = self.AllDataCells
                    vc2.weeklyJson = self.weeklyData
                }
                if let vc3 = $0 as? GooglePhoto{
                    vc3.CityName = self.CityName
                }
                
                
            }
        }
//        if let barVC2 = segue.destination as? SearchResultViewController {
//            barVC2.cityname = self.selectedData
//        }
        
        
    }
    
    //==================================================
    //==================================================
    //==================================================
    //==================================================
    //==================================================
    
    func addRemoveBtn(){
        self.FavButton.isHidden = false
        FavButton.layer.cornerRadius = 0.5 * FavButton.bounds.size.width
        FavButton.clipsToBounds = true
        FavButton.setImage(UIImage(named:"trash-can"), for: .normal)
        FavButton.addTarget(self, action: #selector(RemovebuttonAction), for: .touchUpInside)
        
    }
    func addFavBtn(){
        self.FavButton.isHidden = false
        FavButton.layer.cornerRadius = 0.5 * FavButton.bounds.size.width
        FavButton.clipsToBounds = true
        FavButton.setImage(UIImage(named:"plus-circle"), for: .normal)
        FavButton.addTarget(self, action: #selector(AddedbuttonAction), for: .touchUpInside)
        
    }
    
    func toggleBtn(_ text:String){
        if !isKeyPresentInUserDefaults(key: "HomeDict"){
            addFavBtn()
        }else{
            let decoded  = UserDefaults.standard.object(forKey:"HomeDict") as! Data
            var decoded_Dict = NSKeyedUnarchiver.unarchiveObject(with: decoded) as! Dictionary<String,UIViewController>
            
            if decoded_Dict.keys.contains(self.SearchText!) {
                addRemoveBtn()
            } else {
                addFavBtn()
            }
            
        }
    }
    @objc func RemovebuttonAction(sender: UIButton!) {
        
        
        let decoded  = UserDefaults.standard.object(forKey:"HomeDict") as! Data
        
        var decoded_Dict = NSKeyedUnarchiver.unarchiveObject(with: decoded) as! Dictionary<String,UIViewController>
        
        
        decoded_Dict.removeValue(forKey:self.SearchText!)
        
        let encodedData = NSKeyedArchiver.archivedData(withRootObject: decoded_Dict)
        
        UserDefaults.standard.set(encodedData, forKey:"HomeDict")
        
        //  =====================================================
        self.toggleBtn(self.SearchText!)
        
        
//        myPageViewController?.isRenew = true
        if (myPageViewController != nil){
            myPageViewController?.renewPage()
            myPageViewController.showMSG(self.SearchText! + " was removed from the Favorite List")
        }
        print("23456789okjhbgfrtyhbvftyuhbvfgty7ujhgvft67uhgft67uhgfrt67ygfrt67uh")
        self.view.makeToast(self.SearchText! + " was removed from the Favorite List")
        
        
    }
    @objc func AddedbuttonAction(sender: UIButton!) {
        
        let decoded  = UserDefaults.standard.object(forKey:"HomeDict") as! Data
        
        var decoded_Dict = NSKeyedUnarchiver.unarchiveObject(with: decoded) as! Dictionary<String,UIViewController>
        
        
        decoded_Dict[self.SearchText!] = self
        
        let encodedData = NSKeyedArchiver.archivedData(withRootObject: decoded_Dict)
        
        UserDefaults.standard.set(encodedData, forKey:"HomeDict")
        
        //  =====================================================
        self.toggleBtn(self.SearchText!)
        
        
        if (myPageViewController != nil){
            myPageViewController.showMSG(self.SearchText! + " was added from the Favorite List")
             myPageViewController?.renewPage()
        }
        print("23456789okjhbgfrtyhbvftyuhbvfgty7ujhgvft67uhgft67uhgfrt67ygfrt67uh")
        self.view.makeToast(self.SearchText! + " was added from the Favorite List")
    }
    
    func isKeyPresentInUserDefaults(key: String) -> Bool {
        return UserDefaults.standard.object(forKey: key) != nil
    }
    
    
    
    
    
    
}
extension ViewController:UITableViewDataSource,UITableViewDelegate{
    
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if (tableView == ThirdTable){
//
//        }
////        else{
////            let celldata = self.Predictions[indexPath.row]
////            self.selectedData = celldata
////            self.performSegue(withIdentifier: "SearchResultPage", sender: self)
//////            print (celldata)
//////            let cellView = tableView.dequeueReusableCell(withIdentifier: "TopSearchCellView") as! TopSearchCellView
//////            cellView.setTopcell(JSON(celldata))
////
////        }
//        return
//    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if (tableView == ThirdTable){
            return self.AllDataCells.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if (tableView == ThirdTable){
            let celldata = self.AllDataCells[indexPath.row]
            let cellView = tableView.dequeueReusableCell(withIdentifier: "ThirdCell") as! ThirdTableCellTableViewCell
            cellView.setCell(JSON(celldata))
            return cellView
            
        }
  
        return UITableViewCell()
        
    }
    
    
}


//
//  ThirdTableCellTableViewCell.swift
//  App
//
//  Created by Shaun Yang on 11/15/19.
//  Copyright © 2019 Shaun Yang. All rights reserved.
//

import UIKit
import SwiftyJSON
class ThirdTableCellTableViewCell: UITableViewCell {
    
    @IBOutlet weak var ThirdCellSunsetImg: UIImageView!
    @IBOutlet weak var ThirdCellSunsetTime: UILabel!
    @IBOutlet weak var ThirdCellSunriseImg: UIImageView!
    @IBOutlet weak var ThirdCellSunriseTime: UILabel!
    @IBOutlet weak var ThirdCellDate: UILabel!
    @IBOutlet weak var ThirdCellWeatherIcon: UIImageView!
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
    func get_dateString(_ timestamp:Double)->String{
        
        let date = Date(timeIntervalSince1970:timestamp)
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "PST") //Set timezone that you want
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = "MM/dd/yyyy" //Specify your format that you want
        return dateFormatter.string(from: date)
    }
    func get_timeString(_ timestamp:Double)->String{
        
        let date = Date(timeIntervalSince1970:timestamp)
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "PST") //Set timezone that you want
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = "HH:mm" //Specify your format that you want
        return dateFormatter.string(from: date)
    }
    func setCell(_ day:JSON){
        
        let strDate = get_dateString( day["time"].double!)
        ThirdCellDate.text = strDate
        ThirdCellWeatherIcon.image = setCurrentImg(day["icon"].string!)
        ThirdCellSunriseTime.text = get_timeString(day["sunriseTime"].double!)
        ThirdCellSunriseImg.image = UIImage(named:"weather-sunset-up")
        ThirdCellSunsetTime.text = get_timeString(day["sunsetTime"].double!)
        ThirdCellSunsetImg.image = UIImage(named:"weather-sunset-down")
        
        
    }
    
}

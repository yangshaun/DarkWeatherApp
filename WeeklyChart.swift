//
//  WeeklyChart.swift
//  App
//
//  Created by Shaun Yang on 11/18/19.
//  Copyright © 2019 Shaun Yang. All rights reserved.
//

import UIKit
import Charts
import SwiftyJSON
class WeeklyChart: UIViewController {

    @IBOutlet weak var WeeklySummaryText: UILabel!
    @IBOutlet weak var WeeklyImageView: UIImageView!
    
    @IBOutlet weak var WeeklyChartView: LineChartView!
    @IBOutlet weak var WeeklySummaryView: UIView!
    
    var weekly: JSON!
    var weeklyJson: JSON!
    var maxTemp: [ChartDataEntry]!=[]
    var minTemp: [ChartDataEntry]!=[]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()

        
    }
    
    func loadData(){
        WeeklySummaryView.layer.cornerRadius = 10;
        WeeklyChartView.backgroundColor = UIColor(red:0.95, green:1.00, blue:0.99, alpha:0.33)
        
        
        WeeklySummaryText.text = weeklyJson["summary"].rawString()!
        WeeklySummaryText.sizeToFit()
        WeeklySummaryText.lineBreakMode = NSLineBreakMode.byWordWrapping
        WeeklySummaryText.numberOfLines = 4
        WeeklyImageView.image = setCurrentImg(weeklyJson["icon"].rawString()!)
        
        
        
        
        let weeklyAry = weekly.arrayValue
        var circleColors: [NSUIColor] = []
        var minColors: [NSUIColor] = []
        
        for i in 0..<weeklyAry.count{
            let maxNum : Double = Double(round(Double(weeklyAry[i]["temperatureMax"].rawString()!)! * 100)/100.0)
            let minNum : Double = Double(round(Double(weeklyAry[i]["temperatureMin"].rawString()!)! * 100)/100.0)
            let index:Double = Double(i)
            self.maxTemp.append(ChartDataEntry(x:Double(index) , y: maxNum))
            self.minTemp.append(ChartDataEntry(x:Double(index) , y: minNum))
            
            circleColors.append(UIColor(red:0.93, green:0.53, blue:0.20, alpha:1.0))
            minColors.append(UIColor(red:1.00, green:1.00, blue:1.00, alpha:1.0))
        }
        
        let maxLine = LineChartDataSet(entries:maxTemp,label: "Maximum Temperature(°F)")
        let minLine = LineChartDataSet(entries:minTemp,label: "Minimum Temperature(°F)")
        
        maxLine.circleColors = circleColors
        maxLine.circleHoleColor = UIColor(red:0.93, green:0.53, blue:0.20, alpha:1.0)
        maxLine.setColor(UIColor(red:0.93, green:0.53, blue:0.20, alpha:1.0))
        maxLine.drawCircleHoleEnabled = false
        maxLine.circleRadius = 4
        
        minLine.circleColors = minColors
        minLine.circleHoleColor = UIColor(red:1.00, green:1.00, blue:1.00, alpha:1.0)
        minLine.setColor(UIColor(red:1.00, green:1.00, blue:1.00, alpha:1.0))
        minLine.drawCircleHoleEnabled = false
        minLine.circleRadius = 4
        
        
        
        
        let data = LineChartData()
        data.addDataSet(minLine)
        data.addDataSet(maxLine)
        self.WeeklyChartView.data = data
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

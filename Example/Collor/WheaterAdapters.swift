//
//  WheaterAdapters.swift
//  Collor
//
//  Created by Guihal Gwenn on 26/07/2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import Foundation
import Collor

struct WeatherHeaderAdapter: WeatherTitleAdapterProtocol {
    
    let title: NSAttributedString
    var lineColor: UIColor = .black
    var cellHeight: CGFloat = 50
    
    init(cityName:String) {
        self.title = NSAttributedString(string: cityName, attributes: [
            NSFontAttributeName: UIFont.boldSystemFont(ofSize: 14),
            NSForegroundColorAttributeName: UIColor.black
        ])
    }
}

struct WeatherTemperatureAdapter: WeatherLabelAdapterProtocol {
    
    var label:NSAttributedString
    var height: CGFloat?
    
    init(day:WeatherDay) {
        label = WeatherStyle.WeatherProperty.property(key: "Temperature: ", value: "\(day.temperature)")
    }
}

struct WeatherPressureAdapter: WeatherLabelAdapterProtocol {
    
    var label:NSAttributedString
    var height: CGFloat?
    
    init(day:WeatherDay) {
        label = WeatherStyle.WeatherProperty.property(key: "Pressure: ", value: "\(day.pressure)")
    }
}

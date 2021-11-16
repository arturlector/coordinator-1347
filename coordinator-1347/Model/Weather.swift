//
//  Weather.swift
//  swiftui-1347
//
//  Created by Artur Igberdin on 02.11.2021.
//

import Foundation
import SwiftyJSON
import RealmSwift

class Weather: Object, Identifiable {
    @objc dynamic var id: String = ""
    @objc dynamic var date: Date = Date.distantPast
    @objc dynamic var temperature: Double = 0
    @objc dynamic var pressure: Double = 0
    
    @objc dynamic var icon: String = ""
    
    var iconUrl: URL? {
        URL(string: "https://api.openweathermap.org/img/w/\(icon).png")
    }
    
    @objc dynamic var descr: String = ""
    
//    var cities = LinkingObjects(fromType: City.self, property: "weathers")
    
    convenience init(from json: JSON, city: String) {
        self.init()
        
        let dateDouble = json["dt"].doubleValue
        self.date = Date(timeIntervalSince1970: dateDouble)
        
        self.temperature = json["main"]["temp"].doubleValue
        self.pressure = json["main"]["pressure"].doubleValue
        
        self.icon = json["weather"][0]["icon"].stringValue
        self.descr = json["weather"][0]["description"].stringValue
        self.id = city + String(dateDouble)
    }
    
    convenience init(temperature: Double) {
        self.init()
        
        self.temperature = temperature
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
}

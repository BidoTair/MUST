//
//  WeatherInfo.swift
//  Pods
//
//  Created by Ulaş Sancak on 21/03/2017.
//
//

import ObjectMapper

public class WeatherInfo: Mappable {

    /**
     Weather condition id
     */
    public var id: Int?
    /**
     Group of weather parameters (Rain, Snow, Extreme etc.)
     */
    public var main: String?
    /**
     Weather condition within the group
     */
    public var description: String?
    /**
     Weather icon id
     */
    public var icon: String?
    
    public var iconURL: String {
        get {
            return "http://openweathermap.org/img/w/" + icon! + ".png"
        }
    }
    
    required public init?(map: Map) {
        
    }
    
    // Mappable
    public func mapping(map: Map) {
        id              <- map["id"]
        main            <- map["main"]
        description     <- map["description"]
        icon            <- map["icon"]
    }
}

//
//  Main.swift
//  Pods
//
//  Created by Ulaş Sancak on 21/03/2017.
//
//

import ObjectMapper

/**
 Main weather parameters
 */
public class Main: Mappable {
    /**
     Temperature. Unit Default: Kelvin, Metric: Celsius, Imperial: Fahrenheit
     */
    public var temp: Double?
    /**
     Atmospheric pressure (on the sea level, if there is no sea_level or grnd_level data), hPa
     */
    public var pressure: Double?
    /**
     Atmospheric pressure on the sea level, hPa
     */
    public var seaLevelPressure: Double?
    /**
     Atmospheric pressure on the ground level, hPa
     */
    public var groundLevelPressure: Double?
    /**
     Humidity, %
     */
    public var humidity: Int?
    /**
     Minimum temperature at the moment. This is deviation from current temp that is possible for large cities and megalopolises geographically expanded (use these parameter optionally). Unit Default: Kelvin, Metric: Celsius, Imperial: Fahrenheit.
     */
    public var tempMin: Double?
    /**
     Maximum temperature at the moment. This is deviation from current temp that is possible for large cities and megalopolises geographically expanded (use these parameter optionally). Unit Default: Kelvin, Metric: Celsius, Imperial: Fahrenheit.
     */
    public var tempMax: Double?
    
    required public init?(map: Map) {
        
    }
 
    // Mappable
    public func mapping(map: Map) {
        temp                    <- map["temp"]
        pressure                <- map["pressure"]
        seaLevelPressure        <- map["sea_level"]
        groundLevelPressure     <- map["grnd_level"]
        humidity                <- map["humidity"]
        tempMin                 <- map["temp_min"]
        tempMax                 <- map["temp_max"]
    }
}

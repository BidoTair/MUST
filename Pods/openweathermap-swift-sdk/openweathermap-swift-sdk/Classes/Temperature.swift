//
//  Temperature.swift
//  Pods
//
//  Created by Ulaş Sancak on 21/03/2017.
//
//

import ObjectMapper

public class Temperature: Mappable {

    /**
     Day temperature. Unit Default: Kelvin, Metric: Celsius, Imperial: Fahrenheit.
     */
    public var day: Double?
    /**
     Min daily temperature. Unit Default: Kelvin, Metric: Celsius, Imperial: Fahrenheit.
     */
    public var min: Double?
    /**
     Max daily temperature. Unit Default: Kelvin, Metric: Celsius, Imperial: Fahrenheit.
     */
    public var max: Double?
    /**
     Night temperature. Unit Default: Kelvin, Metric: Celsius, Imperial: Fahrenheit.
     */
    public var night: Double?
    /**
     Evening temperature. Unit Default: Kelvin, Metric: Celsius, Imperial: Fahrenheit.
     */
    public var evening: Double?
    /**
     Morning temperature. Unit Default: Kelvin, Metric: Celsius, Imperial: Fahrenheit.
     */
    public var morning: Double?
    
    required public init?(map: Map) {
        
    }

    // Mappable
    public func mapping(map: Map) {
        day         <- map["day"]
        min         <- map["min"]
        max         <- map["max"]
        night       <- map["night"]
        evening     <- map["eve"]
        morning     <- map["morn"]
    }
}

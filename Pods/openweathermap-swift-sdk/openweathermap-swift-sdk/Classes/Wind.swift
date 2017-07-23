//
//  Wind.swift
//  Pods
//
//  Created by Ulaş Sancak on 21/03/2017.
//
//

import ObjectMapper

public class Wind: Mappable {

    /**
     Wind speed. Unit Default: meter/sec, Metric: meter/sec, Imperial: miles/hour.
     */
    public var speed: Double?
    /**
     Wind direction, degrees (meteorological)
     */
    public var direction: Int?
    
    required public init?(map: Map) {
        
    }
    
    // Mappable
    public func mapping(map: Map) {
        speed       <- map["speed"]
        direction   <- map["deg"]
    }
}

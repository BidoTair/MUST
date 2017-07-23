//
//  Sys.swift
//  Pods
//
//  Created by Ulaş Sancak on 21/03/2017.
//
//

import ObjectMapper

public class Sys: Mappable {

    public var type: Int?
    public var id: Int?
    /**
     Country code (GB, JP etc.)
     */
    public var countryCode: String?
    public var pod: String?
    /**
     Sunrise time, unix, UTC
     */
    public var sunriseTime = TimeInterval()
    /**
     Sunset time, unix, UTC
     */
    public var sunsetTime = TimeInterval()
    
    required public init?(map: Map) {
        
    }
    
    // Mappable
    public func mapping(map: Map) {
        type            <- map["type"]
        id           <- map["id"]
        countryCode     <- map["country"]
        pod             <- map["pod"]
        sunriseTime     <- map["sunrise"]
        sunsetTime      <- map["sunset"]
    }
}

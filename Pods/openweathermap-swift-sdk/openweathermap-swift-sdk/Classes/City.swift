//
//  City.swift
//  Pods
//
//  Created by Ulaş Sancak on 21/03/2017.
//
//

import ObjectMapper

/**
 City model
 */
public class City: Mappable {
    /**
     City ID
     */
    public var id: Int?
    /**
     City name
     */
    public var name: String?
    /**
     City coordinates
     */
    public var coordinates: Coordinates?
    /**
     The country of the city
     */
    public var country: String?
    /**
     The population of the city
     */
    public var population: Int?
    
    required public init?(map: Map) {
        
    }
    
    // Mappable
    public func mapping(map: Map) {
        id              <- map["id"]
        name            <- map["name"]
        coordinates     <- map["coord"]
        country         <- map["country"]
        population      <- map["population"]
    }
}

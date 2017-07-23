//
//  Clouds.swift
//  Pods
//
//  Created by Ulaş Sancak on 21/03/2017.
//
//

import ObjectMapper

public class Clouds: Mappable {
    
    /**
     Cloudiness by percentage
     */
    public var all: Int?

    required public init?(map: Map) {
        
    }
    
    // Mappable
    public func mapping(map: Map) {
        all     <- map["all"]
    }
    
}

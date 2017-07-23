//
//  PrecipitationType.swift
//  Pods
//
//  Created by Ulaş Sancak on 21/03/2017.
//
//

import ObjectMapper

public class Precipitation: Mappable {

    public var volumeForLast3Hours: Int?
    
    required public init?(map: Map) {
        
    }
    
    // Mappable
    public func mapping(map: Map) {
        volumeForLast3Hours     <- map["3h"]
    }
    
}

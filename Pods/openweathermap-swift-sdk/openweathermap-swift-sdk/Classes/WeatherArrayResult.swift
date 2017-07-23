//
//  WeatherArrayResult.swift
//  Pods
//
//  Created by Ulaş Sancak on 21/03/2017.
//
//

import ObjectMapper

public class WeatherArrayResult: BaseResult {
    
    private var alternativeCnt: Int?
    private var privateCnt: Int?

    /**
     The returned number of lines API
     */
    public var cnt: Int? {
        get {
            if privateCnt == nil {
                return alternativeCnt
            }
            return privateCnt
        }
        set {
            privateCnt = newValue
        }
    }
    /**
     The array of Weather data
     */
    public var weatherDatas: [Weather]?
    
    /**
     Related city information model
     */
    public var city: City?
    
    // Mappable
    override public func mapping(map: Map) {
        super.mapping(map: map)
        cnt             <- map["cnt"]
        alternativeCnt  <- map["count"]
        weatherDatas    <- map["list"]
        city            <- map["city"]
    }
}

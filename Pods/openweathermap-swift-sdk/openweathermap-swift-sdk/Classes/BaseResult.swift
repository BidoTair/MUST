//
//  BaseModel.swift
//  Pods
//
//  Created by Ulaş Sancak on 21/03/2017.
//
//

import ObjectMapper

/**
 Base API Client request result model.
 */
public class BaseResult: Mappable {

    private var privateCode: String?    
    
    /**
     Status code of the response
     */
    public var code: String {
        get {
            if privateCode == nil {
                return "200"
            }
            return privateCode!
        }
        set {
            privateCode = newValue;
        }
    }
    /**
     Status message of the response
     */
    public var message: String?
    /**
     Speed of the data calculation
     */
    public var calcTime: Double = 0.0
    
    required public init?(map: Map) {
        
    }
    
    // Mappable
    public func mapping(map: Map) {
        code        <- map["cod"]
        message     <- map["message"]
        calcTime    <- map["calctime"]
    }
}

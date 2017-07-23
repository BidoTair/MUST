//
//  ForecastWeather.swift
//  Pods
//
//  Created by Ulaş Sancak on 21/03/2017.
//
//

import ObjectMapper

public class DailyForecastWeather: Mappable {
    
    /**
     Weather condition codes and infos
     */
    public var weatherInfos: [WeatherInfo]?
    /**
     Wind speed. Unit Default: meter/sec, Metric: meter/sec, Imperial: miles/hour.
     */
    public var windSpeed: Double?
    /**
     Cloudiness by percentage
     */
    public var clouds: Int?
    /**
     Rain volume
     */
    public var rain: Int?
    /**
     Snow volume
     */
    public var snow: Int?
    /**
     Time of data calculation, unix, UTC
     */
    public var dataTime: Double?
    /**
     String time of data forecasted
     */
    public var dataTimeText: String?
    /**
     Temperature model. (Min, max etc.)
     */
    public var temperature: Temperature?
    /**
     Atmospheric pressure on the sea level, hPa
     */
    public var pressure: Double?
    /**
     Humidity by percentage
     */
    public var humidity: Int?
    /**
     Wind direction, degrees (meteorological)
     */
    public var windDirection: Int?
    
    required public init?(map: Map) {
        
    }
    
    // Mappable
    public func mapping(map: Map) {
        weatherInfos        <- map["weather"]
        windSpeed           <- map["speed"]
        clouds              <- map["clouds"]
        rain                <- map["rain"]
        snow                <- map["snow"]
        dataTime            <- map["dt"]
        dataTimeText        <- map["dt_text"]
        temperature         <- map["temp"]
        pressure            <- map["pressure"]
        humidity            <- map["humidity"]
        windDirection       <- map["deg"]
    }
}

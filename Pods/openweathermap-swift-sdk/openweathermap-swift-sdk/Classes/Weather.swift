//
//  Weather.swift
//  Pods
//
//  Created by Ulaş Sancak on 21/03/2017.
//
//

import ObjectMapper

/**
 Weather data model for the current weather API
 */
public class Weather: BaseResult {
    /**
     Coordinates of the related ciyu
     */
    public var coordinates: Coordinates?
    /**
     Weather condition codes and infos
     */
    public var weatherInfos: [WeatherInfo]?
    public var base: String?
    /**
     Main weather parameters
     */
    public var main: Main?
    /**
     Visibility, meter
     */
    public var visibility: Int?
    /**
     Wind model. More info: Wind
     */
    public var wind: Wind?
    /**
     Clouds model. Cloudiness, %. More info: Clouds
     */
    public var clouds: Clouds?
    /**
     Rain model. Rain volume for the last 3 hours. More info: Rain.
     */
    public var rain: Precipitation?
    /**
     Snow model. Snow volume for the last 3 hours. More info: Snow.
     */
    public var snow: Precipitation?
    /**
     Time of data calculation, unix, UTC
     */
    public var dataTime: Double?
    public var sys: Sys?
    /**
     City ID
     */
    public var cityID: Int?
    /**
     City Name
     */
    public var cityName: String?

    // Mappable
    public override func mapping(map: Map) {
        super.mapping(map: map)
        coordinates         <- map["coord"]
        weatherInfos        <- map["weather"]
        base                <- map["base"]
        main                <- map["main"]
        visibility          <- map["visibility"]
        wind                <- map["wind"]
        clouds              <- map["clouds"]
        rain                <- map["rain"]
        snow                <- map["snow"]
        dataTime            <- map["dt"]
        sys                 <- map["sys"]
        cityID              <- map["id"]
        cityName            <- map["name"]
    }
}

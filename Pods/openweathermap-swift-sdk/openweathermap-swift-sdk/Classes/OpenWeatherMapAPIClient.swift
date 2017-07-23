//
//  APIClient.swift
//  Pods
//
//  Created by Ulaş Sancak on 21/03/2017.
//
//

import Foundation
import ObjectMapper
import Alamofire

private let BaseURL: String = "http://api.openweathermap.org"
private let DataURI: String = "data"
private let Version: String = "2.5"
private let APITypeWeather: String = "weather"
private let APITypeBoxCity: String = "box/city"
private let APITypeFind: String = "find"
private let APITypeGroup: String = "group"
private let APITypeForecast: String = "forecast"
private let APITypeDailyForecast: String = "forecast/daily"

/**
 API client model fot HTTP requests
 */
public class OpenWeatherMapAPIClient: NSObject {
    //Response blocks
    public typealias WeatherBlock = (_ weatherData: Weather?, _ error: Error?) -> Void
    public typealias WeatherArrayResultBlock = (_ result: WeatherArrayResult?, _ error: Error?) -> Void
    public typealias WeatherDailyForecastResultBlock = (_ result: DailyForecastResult?, _ error: Error?) -> Void
    //Response block of HTTP requests
    private typealias ClientResponseBlock = (_ response: String?, _ error: Error?) -> Void
    /**
     Shared client instance method
     
     @return APIClient instance
     */
    
    public static let client = OpenWeatherMapAPIClient()
    //Call current weather data for one location
    /**
     Get weather data by cityname. API responds with a list of results that match a searching word.
     
     @param cityName City name
     @param block Response block
     */
    
    public func getWeather(cityName: String, block: @escaping WeatherBlock) {
        if cityName.characters.count == 0 {
            do {
                try createError(description: "cityName cannot be empty")
            } catch let error as OpenWeatherMapAPIError {
                block(nil, error)
            } catch let error {
                block(nil, error)
            }
            return
        }
        get(URL: "\(BaseURL)/\(DataURI)/\(Version)/\(APITypeWeather)", parameters: ["q": cityName], block: {(_ response: String?, _ error: Error?) -> Void in
            var weatherData: Weather? = nil
            if error == nil {
                weatherData = Mapper<Weather>().map(JSONString: response!)
            }
            block(weatherData, error)
        })
    }
    /**
     Get weather data by cityname and country code. API responds with a list of results that match a searching word.
     
     @param cityName City name
     @param countryCode Country code of the city. use ISO 3166 country codes
     @param block Response block
     */
    
    public func getWeather(cityName: String, countryCode: String, block: @escaping WeatherBlock) {
        if cityName.characters.count == 0 {
            do {
                try createError(description: "cityName cannot be empty")
            } catch let error as OpenWeatherMapAPIError {
                block(nil, error)
            } catch let error {
                block(nil, error)
            }
            return
        }
        if countryCode.characters.count == 0 {
            do {
                try createError(description: "countryCode cannot be empty")
            } catch let error as OpenWeatherMapAPIError {
                block(nil, error)
            } catch let error {
                block(nil, error)
            }
            return
        }
        get(URL: "\(BaseURL)/\(DataURI)/\(Version)/\(APITypeWeather)", parameters: ["q": "\(cityName),\(countryCode)"], block: {(_ response: String?, _ error: Error?) -> Void in
            var weatherData: Weather? = nil
            if error == nil {
                weatherData = Mapper<Weather>().map(JSONString: response!)
            }
            block(weatherData, error)
        })
    }
    /**
     Get weather data by city ID. API responds with exact result
     
     @param cityID City ID
     @param block Response block
     */
    
    public func getWeather(cityID: Int, block: @escaping WeatherBlock) {
        if cityID == 0 {
            do {
                try createError(description: "cityID cannot be 0.")
            } catch let error as OpenWeatherMapAPIError {
                block(nil, error)
            } catch let error {
                block(nil, error)
            }
            return
        }
        get(URL: "\(BaseURL)/\(DataURI)/\(Version)/\(APITypeWeather)", parameters: ["id": (cityID)], block: {(_ response: String?, _ error: Error?) -> Void in
            var weatherData: Weather? = nil
            if error == nil {
                weatherData = Mapper<Weather>().map(JSONString: response!)
            }
            block(weatherData, error)
        })
    }
    /**
     Get weather data by coordinates. API responds with exact result
     
     @param coordinates Coordinate model of the location of your interest
     @param block Response block
     */
    
    public func getWeather(coordinates: Coordinates?, block: @escaping WeatherBlock) {
        if coordinates == nil {
            do {
                try createError(description: "coordinates cannot be nil.")
            } catch let error as OpenWeatherMapAPIError {
                block(nil, error)
            } catch let error {
                block(nil, error)
            }
            return
        }
        get(URL: "\(BaseURL)/\(DataURI)/\(Version)/\(APITypeWeather)", parameters: ["lat": (coordinates!.latitude), "lon": (coordinates!.longitude)], block: {(_ response: String?, _ error: Error?) -> Void in
            var weatherData: Weather? = nil
            if error == nil {
                weatherData = Mapper<Weather>().map(JSONString: response!)
            }
            block(weatherData, error)
        })
    }
    /**
     Get weather data by city ZIP code. API responds with exact result
     
     @param ZIPCode ZIP code
     @param block Response block
     */
    public func getWeather(ZIPCode: String, countryCode: String, block: @escaping WeatherBlock) {
        if ZIPCode.characters.count == 0 {
            do {
                try createError(description: "ZIPCode cannot be empty.")
            } catch let error as OpenWeatherMapAPIError {
                block(nil, error)
            } catch let error {
                block(nil, error)
            }
            return
        }
        if countryCode.characters.count == 0 {
            do {
                try createError(description: "countryCode cannot be empty.")
            } catch let error as OpenWeatherMapAPIError {
                block(nil, error)
            } catch let error {
                block(nil, error)
            }
            return
        }
        get(URL: "\(BaseURL)/\(DataURI)/\(Version)/\(APITypeWeather)", parameters: ["zip": "\(ZIPCode),\(countryCode)"], block: {(_ response: String?, _ error: Error?) -> Void in
            var weatherData: Weather? = nil
            if error == nil {
                weatherData = Mapper<Weather>().map(JSONString: response!)
            }
            block(weatherData, error)
        })
    }
    //Call current weather data for several cities
    /**
     Get weather data by several city IDs.
     @param cityIDs City IDs
     @param limit Number of cities around the point that should be returned. 0 for no limit.
     @param block Response block
     */
    
    public func getWeather(cityIDs: [Int], limit: Int, block: @escaping WeatherArrayResultBlock) {
        if cityIDs.count == 0 {
            do {
                try createError(description: "cityIDs cannot be empty.")
            } catch let error as OpenWeatherMapAPIError {
                block(nil, error)
            } catch let error {
                block(nil, error)
            }
            return
        }
        let cityIDsString: String = (cityIDs as NSArray).componentsJoined(by: ",")
        var params: [String: Any] = [
            "id" : cityIDsString
        ]
        if limit > 0 {
            params["cnt"] = (limit)
        }
        get(URL: "\(BaseURL)/\(DataURI)/\(Version)/\(APITypeGroup)", parameters: params, block: {(_ response: String?, _ error: Error?) -> Void in
            var result: WeatherArrayResult? = nil
            if error == nil {
                result = Mapper<WeatherArrayResult>().map(JSONString: response!)
            }
            block(result, error)
        })
    }
    /**
     Get weather data by a rectangle zone. JSON returns the data from cities within the defined rectangle specified by the geographic coordinates.
     @param zone [lon-left,lat-bottom,lon-right,lat-top,zoom]
     @param limit Number of cities around the point that should be returned. 0 for no limit.
     @param block Response block
     */
    
    public func getWeather(zone: String, limit: Int, block: @escaping WeatherArrayResultBlock) {
        let elements = zone.components(separatedBy: ",")
        if elements.count != 5 {
            do {
                try createError(description: "zone format is incorrect. It must be like \"lon-left,lat-bottom,lon-right,lat-top,zoom\".")
            } catch let error as OpenWeatherMapAPIError {
                block(nil, error)
            } catch let error {
                block(nil, error)
            }
            return
        }
        var params: [String: Any] = [
            "bbox" : zone
        ]
        
        if limit > 0 {
            params["cnt"] = (limit)
        }
        get(URL: "\(BaseURL)/\(DataURI)/\(Version)/\(APITypeBoxCity)", parameters: params, block: {(_ response: String?, _ error: Error?) -> Void in
            var result: WeatherArrayResult? = nil
            if error == nil {
                result = Mapper<WeatherArrayResult>().map(JSONString: response!)
            }
            block(result, error)
        })
    }
    /**
     Get weather data by cities in a cycle. JSON returns data from cities laid within definite circle that is specified by center point ('lat', 'lon') and expected number of cities ('cnt') around this point. The default number of cities is 10, the maximum is 50.
     @param coordinates Center coordinates of the cycle
     @param countOfCity Number of cities around the point that should be returned. 0 for no limit.
     @param block Response block
     */
    public func getWeather(coordinates: Coordinates?, countOfCity: Int, block: @escaping WeatherArrayResultBlock) {
        if coordinates == nil {
            do {
                try createError(description: "coordinates cannot be nil.")
            } catch let error as OpenWeatherMapAPIError {
                block(nil, error)
            } catch let error {
                block(nil, error)
            }
            return
        }
        get(URL: "\(BaseURL)/\(DataURI)/\(Version)/\(APITypeFind)", parameters: ["lat": (coordinates!.latitude), "lon": (coordinates!.longitude), "cnt": (countOfCity)], block: {(_ response: String?, _ error: Error?) -> Void in
            var result: WeatherArrayResult? = nil
            if error == nil {
                result = Mapper<WeatherArrayResult>().map(JSONString: response!)
            }
            block(result, error)
        })
    }
    //Call 5 day / 3 hour forecast data. You can search weather forecast for 5 days with data every 3 hours.
    /**
     Get forecast data by cityname and country code. API responds with a list of results that match a searching word.
     
     @param cityName City name
     @param countryCode Country code of the city
     @param limit Number of cities that should be returned. 0 for no limit.
     @param block Response block
     */
    
    public func getForecast(cityName: String, countryCode: String, limit: Int, block: @escaping WeatherArrayResultBlock) {
        if cityName.characters.count == 0 {
            do {
                try createError(description: "cityName cannot be empty")
            } catch let error as OpenWeatherMapAPIError {
                block(nil, error)
            } catch let error {
                block(nil, error)
            }
            return
        }
        if countryCode.characters.count == 0 {
            do {
                try createError(description: "countryCode cannot be empty")
            } catch let error as OpenWeatherMapAPIError {
                block(nil, error)
            } catch let error {
                block(nil, error)
            }
            return
        }
        var params: [String: Any] = [
            "q" : cityName
        ]
        
        if limit > 0 {
            params["cnt"] = (limit)
        }
        get(URL: "\(BaseURL)/\(DataURI)/\(Version)/\(APITypeForecast)", parameters: params, block: {(_ response: String?, _ error: Error?) -> Void in
            var result: WeatherArrayResult? = nil
            if error == nil {
                result = Mapper<WeatherArrayResult>().map(JSONString: response!)
            }
            block(result, error)
        })
    }
    /**
     Get forecast data by city ID. API responds with exact result
     
     @param cityID City ID
     @param limit Number of cities that should be returned. 0 for no limit.
     @param block Response block
     */
    
    public func getForecast(cityID: Int, limit: Int, block: @escaping WeatherArrayResultBlock) {
        if cityID == 0 {
            do {
                try createError(description: "cityID cannot be 0.")
            } catch let error as OpenWeatherMapAPIError {
                block(nil, error)
            } catch let error {
                block(nil, error)
            }
            return
        }
        var params: [String: Any] = [
            "id" : (cityID)
        ]
        
        if limit > 0 {
            params["cnt"] = (limit)
        }
        get(URL: "\(BaseURL)/\(DataURI)/\(Version)/\(APITypeForecast)", parameters: params, block: {(_ response: String?, _ error: Error?) -> Void in
            var result: WeatherArrayResult? = nil
            if error == nil {
                result = Mapper<WeatherArrayResult>().map(JSONString: response!)
            }
            block(result, error)
        })
    }
    /**
     Get forecast data by coordinates. API responds with exact result
     
     @param coordinates Coordinate model of the location of your interest
     @param limit Number of cities that should be returned. 0 for no limit.
     @param block Response block
     */
    public func getForecast(coordinates: Coordinates?, limit: Int, block: @escaping WeatherArrayResultBlock) {
        if coordinates == nil {
            do {
                try createError(description: "coordinates cannot be nil.")
            } catch let error as OpenWeatherMapAPIError {
                block(nil, error)
            } catch let error {
                block(nil, error)
            }
            return
        }
        var params: [String: Any] = [
            "lat" : (coordinates!.latitude),
            "lon" : (coordinates!.longitude)
        ]
        
        if limit > 0 {
            params["cnt"] = (limit)
        }
        get(URL: "\(BaseURL)/\(DataURI)/\(Version)/\(APITypeForecast)", parameters: params, block: {(_ response: String?, _ error: Error?) -> Void in
            var result: WeatherArrayResult? = nil
            if error == nil {
                result = Mapper<WeatherArrayResult>().map(JSONString: response!)
            }
            block(result, error)
        })
    }
    /**
     Get forecast data by city ZIP code. API responds with exact result
     
     @param ZIPCode ZIP code
     @param limit Number of cities that should be returned. 0 for no limit.
     @param block Response block
     */
    
    public func getForecast(ZIPCode: String, countryCode: String, limit: Int, block: @escaping WeatherArrayResultBlock) {
        if ZIPCode.characters.count == 0 {
            do {
                try createError(description: "ZIPCode cannot be empty.")
            } catch let error as OpenWeatherMapAPIError {
                block(nil, error)
            } catch let error {
                block(nil, error)
            }
            return
        }
        if countryCode.characters.count == 0 {
            do {
                try createError(description: "countryCode cannot be empty.")
            } catch let error as OpenWeatherMapAPIError {
                block(nil, error)
            } catch let error {
                block(nil, error)
            }
            return
        }
        var params: [String: Any] = [
            "zip" : "\(ZIPCode),\(countryCode)"
        ]
        
        if limit > 0 {
            params["cnt"] = (limit)
        }
        get(URL: "\(BaseURL)/\(DataURI)/\(Version)/\(APITypeForecast)", parameters: params, block: {(_ response: String?, _ error: Error?) -> Void in
            var result: WeatherArrayResult? = nil
            if error == nil {
                result = Mapper<WeatherArrayResult>().map(JSONString: response!)
            }
            block(result, error)
        })
    }
    //Call 16 day / daily forecast data. You can search 16 day weather forecast with daily average parameters
    /**
     Get forecast data by cityname and country code. API responds with a list of results that match a searching word.
     
     @param cityName City name
     @param countryCode Country code of the city
     @param limit Number of cities that should be returned. 0 for no limit.
     @param block Response block
     */
    
    public func getDailyForecast(cityName: String, countryCode: String, limit: Int, block: @escaping WeatherDailyForecastResultBlock) {
        if cityName.characters.count == 0 {
            do {
                try createError(description: "cityName cannot be empty")
            } catch let error as OpenWeatherMapAPIError {
                block(nil, error)
            } catch let error {
                block(nil, error)
            }
            return
        }
        if countryCode.characters.count == 0 {
            do {
                try createError(description: "countryCode cannot be empty")
            } catch let error as OpenWeatherMapAPIError {
                block(nil, error)
            } catch let error {
                block(nil, error)
            }
            return
        }
        var params: [String: Any] = [
            "q" : cityName
        ]
        
        if limit > 0 {
            params["cnt"] = (limit)
        }
        get(URL: "\(BaseURL)/\(DataURI)/\(Version)/\(APITypeDailyForecast)", parameters: params, block: {(_ response: String?, _ error: Error?) -> Void in
            var result: DailyForecastResult? = nil
            if error == nil {
                result = Mapper<DailyForecastResult>().map(JSONString: response!)
            }
            block(result, error)
        })
    }
    /**
     Get forecast data by city ID. API responds with exact result
     
     @param cityID City ID
     @param limit Number of cities that should be returned. 0 for no limit.
     @param block Response block
     */
    
    public func getDailyForecast(cityID: Int, limit: Int, block: @escaping WeatherDailyForecastResultBlock) {
        if cityID == 0 {
            do {
                try createError(description: "cityID cannot be 0.")
            } catch let error as OpenWeatherMapAPIError {
                block(nil, error)
            } catch let error {
                block(nil, error)
            }
            return
        }
        var params: [String: Any] = [
            "id" : (cityID)
        ]
        
        if limit > 0 {
            params["cnt"] = (limit)
        }
        get(URL: "\(BaseURL)/\(DataURI)/\(Version)/\(APITypeDailyForecast)", parameters: params, block: {(_ response: String?, _ error: Error?) -> Void in
            var result: DailyForecastResult? = nil
            if error == nil {
                result = Mapper<DailyForecastResult>().map(JSONString: response!)
            }
            block(result, error)
        })
    }
    /**
     Get forecast data by coordinates. API responds with exact result
     
     @param coordinates Coordinate model of the location of your interest
     @param limit Number of cities that should be returned. 0 for no limit.
     @param block Response block
     */
    public func getDailyForecast(coordinates: Coordinates?, limit: Int, block: @escaping WeatherDailyForecastResultBlock) {
        if coordinates == nil {
            do {
                try createError(description: "coordinates cannot be nil.")
            } catch let error as OpenWeatherMapAPIError {
                block(nil, error)
            } catch let error {
                block(nil, error)
            }
            return
        }
        var params: [String: Any] = [
            "lat" : (coordinates!.latitude),
            "lon" : (coordinates!.longitude)
        ]
        
        if limit > 0 {
            params["cnt"] = (limit)
        }
        get(URL: "\(BaseURL)/\(DataURI)/\(Version)/\(APITypeDailyForecast)", parameters: params, block: {(_ response: String?, _ error: Error?) -> Void in
            var result: DailyForecastResult? = nil
            if error == nil {
                result = Mapper<DailyForecastResult>().map(JSONString: response!)
            }
            block(result, error)
        })
    }
    /**
     Get forecast data by city ZIP code. API responds with exact result
     
     @param ZIPCode ZIP code
     @param limit Number of cities that should be returned. 0 for no limit.
     @param block Response block
     */
    
    public func getDailyForecast(ZIPCode: String, countryCode: String, limit: Int, block: @escaping WeatherDailyForecastResultBlock) {
        if ZIPCode.characters.count == 0 {
            do {
                try createError(description: "ZIPCode cannot be empty.")
            } catch let error as OpenWeatherMapAPIError {
                block(nil, error)
            } catch let error {
                block(nil, error)
            }
            return
        }
        if countryCode.characters.count == 0 {
            do {
                try createError(description: "countryCode cannot be empty.")
            } catch let error as OpenWeatherMapAPIError {
                block(nil, error)
            } catch let error {
                block(nil, error)
            }
            return
        }
        var params: [String: Any] = [
            "zip" : "\(ZIPCode),\(countryCode)"
        ]
        
        if limit > 0 {
            params["cnt"] = (limit)
        }
        get(URL: "\(BaseURL)/\(DataURI)/\(Version)/\(APITypeDailyForecast)", parameters: params, block: {(_ response: String?, _ error: Error?) -> Void in
            var result: DailyForecastResult? = nil
            if error == nil {
                result = Mapper<DailyForecastResult>().map(JSONString: response!)
            }
            block(result, error)
        })
    }
    
    private func get(URL: String, parameters: [String: Any]!, block: @escaping ClientResponseBlock) {
        var parameters: [String: Any] = parameters
        parameters["appid"] = OpenWeatherMapClient.client.appID
        let params = Params.defaultParams.toJSON()
        if params.count > 0 {
            for (k, v) in params {
                parameters.updateValue(v, forKey: k)
            }
        }
        Alamofire.request(URL, parameters: parameters).responseString { response in
            block(response.result.value, response.result.error)
        }
    }
    
    private func createError(description: String) throws {
        throw OpenWeatherMapAPIError.emptyParameter(description: description)
    }
}

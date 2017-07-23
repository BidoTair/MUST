# openweathermap-swift-sdk

[![CI Status](http://img.shields.io/travis/rocxteady/openweathermap-swift-sdk.svg?style=flat)](https://travis-ci.org/rocxteady/openweathermap-swift-sdk)
[![Version](https://img.shields.io/cocoapods/v/openweathermap-swift-sdk.svg?style=flat)](http://cocoapods.org/pods/openweathermap-swift-sdk)
[![License](https://img.shields.io/cocoapods/l/openweathermap-swift-sdk.svg?style=flat)](http://cocoapods.org/pods/openweathermap-swift-sdk)
[![Platform](https://img.shields.io/cocoapods/p/openweathermap-swift-sdk.svg?style=flat)](http://cocoapods.org/pods/openweathermap-swift-sdk)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

openweathermap-swift-sdk is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "openweathermap-swift-sdk"
```
## Usage
###### API Key
```
import openweathermap_swift_sdk

OpenWeatherMapClient.client(appID: "app_id")
```

###### Getting Current Conditions
```
import openweathermap_swift_sdk

OpenWeatherMapAPIClient.client.getWeather(cityName: "istanbul") { (weatherData, error) in
    if error == nil && weatherData!.code == "200" {
		//Data received
    }
}
```
###### Getting Current Conditions for Several Cities
```
import openweathermap_swift_sdk

OpenWeatherMapAPIClient.client.getWeather(cityIDs: [524901, 703448, 2643743], limit: 0) { (result, error) in
    if error == nil && result!.code == "200" {
		//Data received
    }
}
```
###### Getting Hourly Forecast
```
import openweathermap_swift_sdk

OpenWeatherMapAPIClient.client.getForecast(cityName: "istanbul", countryCode: "tr", limit: 0) { (result, error) in
    if error == nil && result!.code == "200" {
		//Data received
    }
}
```
###### Getting Daily Forecast
```
import openweathermap_swift_sdk

OpenWeatherMapAPIClient.client.getDailyForecast(cityName: "istanbul", countryCode: "tr", limit: 0) { (result, error) in
    if error == nil && result!.code == "200" {
		//Data received
    }
}
```

## Author

Ulaş Sancak, ulas.sancak@hotmail.com.tr

## License

openweathermap-swift-sdk is available under the MIT license. See the LICENSE file for more info.

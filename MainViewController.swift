//
//  MainViewController.swift
//  Arapp
//
//  Created by Abdulghafar Al Tair on 4/19/17.
//  Copyright © 2017 Abdulghafar Al Tair. All rights reserved.
//

import UIKit
import AVFoundation
import openweathermap_swift_sdk
import Alamofire
import CoreLocation
import CoreMotion
import FirebaseDatabase


class MainViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate, CLLocationManagerDelegate {

   
    @IBOutlet weak var mapButton: UIButton!
    @IBOutlet weak var cameraview: UIView!
    @IBOutlet weak var camButton: UIButton!
    @IBOutlet weak var airButton: UIButton!
    @IBOutlet weak var humButton: UIButton!
    @IBOutlet weak var tempButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var aqiLabel: UILabel!
    
    @IBOutlet weak var street1: UILabel! // street label in small left
    @IBOutlet weak var hum1: UILabel! // hum label in small left
    @IBOutlet weak var temp1: UILabel!
    @IBOutlet weak var street2: UILabel!
    @IBOutlet weak var hum2: UILabel!
    @IBOutlet weak var temp2: UILabel!
    @IBOutlet weak var street3: UILabel!
    @IBOutlet weak var hum3: UILabel!
    @IBOutlet weak var temp3: UILabel!
    @IBOutlet weak var buttonInBigView: UIButton!
    @IBOutlet weak var buttonInSmallView: UIButton!
    @IBOutlet weak var buttonInMediumView: UIButton!
    @IBOutlet weak var centerView: UIView!
    @IBOutlet weak var centerStreet: UILabel!
    @IBOutlet weak var centerHum: UILabel!
    @IBOutlet weak var centerTemp: UILabel!
    @IBOutlet weak var buttonInCenterView: UIButton!
    @IBOutlet weak var bigRight: UIView!
    @IBOutlet weak var smallLeft: UIView!
    @IBOutlet weak var bigLeft: UIView!
    @IBOutlet weak var smallRight: UIView!
    @IBOutlet weak var street4: UILabel!
    @IBOutlet weak var hum4: UILabel!
    @IBOutlet weak var temp4: UILabel!
    @IBOutlet weak var filterView: UIView!
    
    var currentTemp = 0.0
    var currentAQI = 0.0
    var currentHum = 0
    var tempSmallLeft = 0.0
    var tempBigLeft = 0.0
    var tempSmallRight = 0.0
    var tempBigRight = 0.0
    var humSmallLeft = 0
    var humBigLeft = 0
    var humSmallRight = 0
    var humBigRight = 0
    
    var firebaseTemps: [Double] = [Double]()
    var firebaseHums: [Int] = [Int]()
    var firebaseAqis: [Double] = [Double]()
    
    var aqiSmallLeft = 0.0
    var aqiBigLeft = 0.0
    var aqiSmallRight = 0.0
    var aqiBigRight = 0.0

    
    var captureSession = AVCaptureSession()
    var sessionOutput = AVCaptureStillImageOutput()
    var previewLayer = AVCaptureVideoPreviewLayer()
    
    var FirebaseFailed: Bool = true
    
    var ref: DatabaseReference!
    var databaseHandle: DatabaseHandle?
    
    typealias JSONStandard = Dictionary<String, AnyObject>
    typealias mytuple = (lat: String, long: String)
    
    let urlString = "https://api.waqi.info/feed/geo:"
    let token = "/?token=7dc7a1ceb5b6b67d3f125128d6fda6e584badff8"
    let interString = "http://api.geonames.org/findNearestIntersectionOSMJSON?lat=";
    
    let pinch = UIPinchGestureRecognizer()
    
    var userCo: Coordinates? = nil
    
    var tempToggle: Bool = true
    var humToggle: Bool = true
    var aqiToggle: Bool = true
    var showViews: Bool = true
    var filterToggle:Bool = true
    
    
    let locationManager = CLLocationManager()
    
    var LatLong: [mytuple] = [mytuple]() // array of lat and longitude
    var firebaseLatLong: [mytuple] = [mytuple]() // array of lat and long from firebase
    var street: [String] = []  // array of street intersections

    var lastLocation: CLLocation = CLLocation()
    var lastHeading: Double = Double()
    
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        OpenWeatherMapClient.client(appID: "8f11d4ba908c93486338df1487f0f14d")
        
        AppUtility.lockOrientation(.landscapeRight, andRotateTo: .landscapeRight) // rotates orientation and locks it
        tempButton.imageView?.contentMode = .scaleAspectFit
        humButton.imageView?.contentMode = .scaleAspectFit
        airButton.imageView?.contentMode = .scaleAspectFit
        mapButton.imageView?.contentMode = .scaleAspectFit
        camButton.imageView?.contentMode = .scaleAspectFit
        
        setupViews()
        


        
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
            locationManager.startUpdatingHeading()
            locationManager.headingOrientation = .landscapeLeft
            locationManager.headingFilter = CLLocationDegrees(10)
        }
        
      //  setupButtons() // calls method to make buttons circular
        setupPinch()
        
        
        
        let devices = AVCaptureDevice.devices(withMediaType: AVMediaTypeVideo)
        
        for device in devices! {
            if ((device as AnyObject).position == AVCaptureDevicePosition.back){
                do {
                    let input = try AVCaptureDeviceInput(device: device as! AVCaptureDevice)
                    
                    if captureSession.canAddInput(input) {
                        captureSession.addInput(input)
                        sessionOutput.outputSettings = [AVVideoCodecKey : AVVideoCodecJPEG]
                    
                        
                        if captureSession.canAddOutput(sessionOutput) {
                            captureSession.addOutput(sessionOutput)
                    
                            
                            captureSession.startRunning()
                            
                            
                            previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
                            previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
                            previewLayer.connection.videoOrientation = AVCaptureVideoOrientation.landscapeRight
                            cameraview.layer.addSublayer(previewLayer)
                            
                            previewLayer.position = CGPoint(x: self.cameraview.frame.width/2, y: self.cameraview.frame.height/2)
                            previewLayer.bounds = cameraview.frame
                            
                            
                        }
                        
                    }
                }
                
                catch {
                    
                }
            }
        }

        // Do any additional setup after loading the view.
    }
    

    
    
    func setupViews() {
        smallLeft.layer.cornerRadius = 25
        smallRight.layer.cornerRadius = 25
        bigLeft.layer.cornerRadius = 25
        bigRight.layer.cornerRadius = 25
        self.centerView.layer.cornerRadius = 25
        buttonInCenterView.layer.cornerRadius = 0.5*buttonInCenterView.bounds.size.width
        buttonInCenterView.clipsToBounds = true
    }
    
    func setupPinch() {
        self.view.addGestureRecognizer(pinch)
        pinch.addTarget(self, action: #selector(pinched))
    }
    
    // hiding views when pinched
    func pinched() {
        if pinch.scale < 1.0 {
            
            UIView.animate(withDuration: 0.5, delay: 0, options: [], animations: {
                self.smallLeft.alpha = 0 // Here you will get the animation you want
                self.bigLeft.alpha = 0
                self.bigRight.alpha = 0
                self.smallRight.alpha = 0
            }, completion: { _ in
                self.smallLeft.isHidden = true // Here you hide it when animation done
                self.bigLeft.isHidden = true
                self.smallRight.isHidden = true
                self.bigRight.isHidden = true
                self.showViews = false
            })
            
        }
        
        else if pinch.scale > 1.0 {
            UIView.animate(withDuration: 0.3, delay: 0, options: [], animations: {
                self.smallLeft.alpha = 0.7 // Here you will get the animation you want
                self.bigLeft.alpha = 0.7
                self.bigRight.alpha = 0.7
                self.smallRight.alpha = 0.7
            }, completion: { _ in
                self.smallLeft.isHidden = false // Here you hide it when animation done
                self.bigLeft.isHidden = false
                self.bigRight.isHidden = false
                self.smallRight.isHidden = false
                self.showViews = true
            })
        }
    }
    
    
    // makes buttons circular
    func setupButtons() {
          mapButton.imageView?.center
//        mapButton.layer.cornerRadius = 0.5 * mapButton.bounds.size.width
//        mapButton.clipsToBounds = true
//        
//        camButton.layer.cornerRadius = 0.5 * mapButton.bounds.size.width
//        camButton.clipsToBounds = true
//        
//        airButton.layer.cornerRadius = 0.5 * mapButton.bounds.size.width
//        airButton.clipsToBounds = true
//        
//        humButton.layer.cornerRadius = 0.5 * mapButton.bounds.size.width
//        humButton.clipsToBounds = true
//        
//        tempButton.layer.cornerRadius = 0.5 * mapButton.bounds.size.width
//        tempButton.clipsToBounds = true
    }
    
    // gets current humidity and temp
    func setupWeather() {
        
        OpenWeatherMapAPIClient.client.getWeather(coordinates: userCo) { (weatherData, error) in
            if error == nil && weatherData!.code == "200" {
                //Data received
               
                self.currentTemp = (weatherData?.main?.temp)!
                self.currentHum = (weatherData?.main?.humidity)!
                self.tempLabel.text = "Temp: " + String(format: "%.0f °C", self.currentTemp)
                self.humidityLabel.text = "Hum: " + String("\(self.currentHum) %")
            }
        }
    }
    
    // gets humidity and temp when firebase does not have data
    func getWeatherData(index: Int, number: Int) {
        
        let lat = self.LatLong[index].lat
        let long = self.LatLong[index].long
        
        let co = Coordinates(latitude: Double(lat)!, longitude: Double(long)!)
        
        OpenWeatherMapAPIClient.client.getWeather(coordinates: co) { (weatherData, error) in
            if error == nil && weatherData!.code == "200" {
                
                let temp = (weatherData?.main?.temp)!
                let humidity = (weatherData?.main?.humidity)!
                
                if (number == 1) {
                    self.tempSmallLeft = temp
                    self.humSmallLeft = humidity
                    self.hum1.text = "Hum: " + String("\(humidity) %")
                    self.temp1.text =  "Temp: " + String(format: "%.0f °C", temp)
                }
                
                else if (number == 2) {
                    self.tempBigLeft = temp
                    self.humBigLeft = humidity
                    self.hum2.text = "Hum: " + String("\(humidity) %")
                    self.temp2.text = "Temp: " + String(format: "%.0f °C", temp)
                    
                }
                
                else if (number == 3) {
                    self.tempBigRight = temp
                    self.humBigRight = humidity
                    self.hum3.text = "Hum: " + String("\(humidity) %")
                    self.temp3.text = "Temp: " + String(format: "%.0f °C", temp)
                }
                else if (number == 4) {
                    self.tempSmallRight = temp
                    self.humSmallRight = humidity
                    self.hum4.text = "Hum: " + String("\(humidity) %")
                    self.temp4.text = "Temp: " + String(format: "%.0f °C", temp)
                }
            }
        }
        
    }
    
    // gets aqi when firebase data not available
    func getAqiData(index: Int, number: Int) {
        let urlComp = urlString + self.LatLong[index].lat + ";" +  self.LatLong[index].long + token
        
        
        
        
        Alamofire.request(urlComp).responseJSON(completionHandler: {
            response in
            var result = response.result
            
            if let dict = result.value as? JSONStandard, let data = dict["data"] as? JSONStandard, let aqi = data["aqi"] as? Double {

    
                if (number == 1) {
                    self.aqiSmallLeft = aqi
                }
                    
                else if (number == 2) {
                    self.aqiBigLeft = aqi
                    
                }
                    
                else if (number == 3) {
                    self.aqiBigRight = aqi
                    
                }
                else if (number == 4) {
                   self.aqiSmallRight = aqi
              }
          }
       })
    }
    
    // set up current aqi
    func setupAqi(latitude: String, longitude: String) {
        
        
        let urlComp = urlString + latitude + ";" + longitude + token
        let url = URL(string: urlComp)
    
        
        
        
        Alamofire.request(urlComp).responseJSON(completionHandler: {
            response in
            var result = response.result
            
            if let dict = result.value as? JSONStandard, let data = dict["data"] as? JSONStandard, let aqi = data["aqi"] as? Double {
                self.currentAQI = aqi
                
                self.aqiLabel.textAlignment = .center
                if aqi < 51.0 {
                    self.aqiLabel.textColor = UIColor.green
                    self.aqiLabel.text = "Good"
                }
                else if aqi < 101.0 {
                    self.aqiLabel.textColor = UIColor.yellow
                    self.aqiLabel.text = "Moderate"
                }
                else if aqi < 151.0 {
                    self.aqiLabel.textColor = UIColor.orange
                    self.aqiLabel.text = "Mod. Unhealthy"
                    
                }
                else if aqi < 201.0 {
                    self.aqiLabel.textColor = UIColor.red
                    self.aqiLabel.text = "Unhealthy"
                    
                }
                else if aqi < 301.0 {
                    self.aqiLabel.textColor = UIColor.purple
                    self.aqiLabel.text = "Very Unhealthy"
                }
                else if aqi < 500.0 {
                    self.aqiLabel.textColor = UIColor.brown
                    self.aqiLabel.text = "Hazardous"
                    
                }
            }
        })
          }
    
    
    // get nearest 10 intersections to me
    func setupIntersections(latitude: String, longitude: String) {
        
        let urlComplete = interString + latitude + "&lng=" + longitude + "&maxRows=10" + "&username=me"
        let url = URL(string: urlComplete)
        
       Alamofire.request(urlComplete).responseJSON(completionHandler: {
            response in
            let result = response.result
            
            if let dict = result.value as? [String:Any], let intersections = dict["intersection"] as? [[String:Any]] {
                
                for object in intersections {
                    let lat = object["lat"] as? String
                    let long = object["lng"] as? String
                    let street1 = object["street1"] as? String
                    let street2 = object["street2"] as? String
                    
                    let street1Arr = street1?.components(separatedBy: " Street")
                    let street2Arr = street2?.components(separatedBy: " Street")
                    
                   
                    
                    
                   
                    self.LatLong.append((lat!, long!))
                    self.street.append((street1Arr?[0])! + " and " + (street2Arr?[0])!)
                }
            }
        })
    }
    
    // draws views
    func onDraw() {
        var locations: [CLLocation] = [CLLocation]()
        
        
        if (self.firebaseLatLong.count > 3) {
            self.FirebaseFailed = false
        }
        else{
            self.FirebaseFailed = true
        }

        
        
        if (FirebaseFailed) {
        
       let n = self.LatLong.count
        
        
        if (n > 10) {
        for i in (n-10)..<n {
            let latitude = CLLocationDegrees(self.LatLong[i].lat)
            let long = CLLocationDegrees(self.LatLong[i].long)
            let location = CLLocation(latitude: latitude!, longitude: long!)
            locations.append(location)
         }
        
        var distances: [Double] = [Double]()
        var maxDistance = Double.infinity
        var secondDistance = Double.infinity
        var thirdDistance = Double.infinity
        var fourthDistance = Double.infinity
        var index1 = -1
        var index2 = -1
        var index3 = -1
        var index4 = -1
        
        

        
        for i in (n-10)..<n {
            
            let latitude = Double(self.LatLong[i].lat)
            let long = Double(self.LatLong[i].long)
            let distance = calculateDistace(lat: latitude!, long: long!)
            
            
            var bearing: Double = getBearingBetweenTwoPoints1(point1: lastLocation, point2: locations[i - (n - 10)])
            
            if (abs(bearing) > 110) {
                continue
            }
            
          
            if (bearing < 0) {
            
            if distance <= maxDistance {
                maxDistance = distance
                index2 = i            }
            
            else if distance < secondDistance {
                secondDistance = distance
                index1 = i
            }
                
            }
                
            if (bearing > 0) {
            
            if distance <= thirdDistance {
                thirdDistance = distance
                index3 = i
            }
            
            else if distance < fourthDistance {
                fourthDistance = distance
                index4 = i
            }
                
            }
        }
        
        if(filterToggle) {
        
       
        if (index2 > -1) {
            self.bigLeft.alpha = 0.7
            self.bigLeft.isHidden = false
            street2.text = self.street[index2]
            getWeatherData(index: index2, number: 2)
            getAqiData(index: index2, number: 2)
        }
        else {
            self.bigLeft.alpha = 0
            self.bigLeft.isHidden = true
        }
        
        
        if (index1 > -1) {
            self.smallLeft.alpha = 0.7
            self.smallLeft.isHidden = false
            street1.text = self.street[index1]
            getWeatherData(index: index1, number: 1)
            getAqiData(index: index1, number: 1)
        }
        else {
            self.smallLeft.alpha = 0
            self.smallLeft.isHidden = true
            
        }
        
        
        if (index3 > -1) {
            self.bigRight.alpha = 0.7
            self.bigRight.isHidden = false
            street3.text = self.street[index3]
            getWeatherData(index: index3, number: 3)
            getAqiData(index: index3, number: 3)
        }
        else {
            self.bigRight.alpha = 0
            self.bigRight.isHidden = true
        }
        
        if (index4 > -1) {
            self.smallRight.alpha = 0.7
            self.smallRight.isHidden = false
            street4.text = self.street[index4]
            getWeatherData(index: index4, number: 4)
            getAqiData(index: index4, number: 4)
        }
        else {
            self.smallRight.alpha = 0
            self.smallRight.isHidden = true
        }
       }
     }
        }
        
        else {
            for object in self.firebaseLatLong {
                let latitude = CLLocationDegrees(object.lat)
                let long = CLLocationDegrees(object.long)
                let location = CLLocation(latitude: latitude!, longitude: long!)
                locations.append(location)
            }
            
            var distances: [Double] = [Double]()
            var maxDistance = Double.infinity
            var secondDistance = Double.infinity
            var thirdDistance = Double.infinity
            var fourthDistance = Double.infinity
            var index1 = -1
            var index2 = -1
            var index3 = -1
            var index4 = -1
            
            
            
            
            for (index, object) in self.firebaseLatLong.enumerated() {
                
                let latitude = Double(object.lat)
                let long = Double(object.long)
                let distance = calculateDistace(lat: latitude!, long: long!)
                
                
                var bearing: Double = getBearingBetweenTwoPoints1(point1: lastLocation, point2: locations[index])
                
                // fix rhis
                
//                if (abs(bearing) > 110) {
//                    continue
//                }
                
                
                if (bearing < 0) {
                    
                    if distance <= maxDistance {
                        maxDistance = distance
                        index2 = index
                    }
                        
                    else if distance <= secondDistance {
                        secondDistance = distance
                        index1 = index
                    }
                    
                }
                
                if (bearing > 0) {
                    
                    if distance <= thirdDistance {
                        thirdDistance = distance
                        index3 = index
                    }
                        
                    else if distance <= fourthDistance {
                        fourthDistance = distance
                        index4 = index
                    }
                    
                }
            }
            
            if(filterToggle) {
                
                
                if (index2 > -1) {
                    self.bigLeft.alpha = 0.7
                    self.bigLeft.isHidden = false
                    self.tempBigLeft =  self.firebaseTemps[index2]
                    self.humBigLeft = self.firebaseHums[index2]
                    self.aqiBigLeft = self.firebaseAqis[index2]

                    getSteetIntersection(latitude: self.firebaseLatLong[index2].lat, longitude: self.firebaseLatLong[index2].long, number: 2)
                    temp2.text = "Temp:" + String(format: "%.0f °C",  tempBigLeft)
                    hum2.text = "Hum: " + String("\(humBigLeft) %")
                }
                else {
                    self.bigLeft.alpha = 0
                    self.bigLeft.isHidden = true
                }
                if (index1 > -1) {
                    self.smallLeft.alpha = 0.7
                    self.smallLeft.isHidden = false
                    self.tempSmallLeft =  self.firebaseTemps[index1]
                    self.humSmallLeft = self.firebaseHums[index1]
                    self.aqiSmallLeft = self.firebaseAqis[index1]
                    getSteetIntersection(latitude: self.firebaseLatLong[index1].lat, longitude: self.firebaseLatLong[index1].long, number: 1)
                    temp1.text = "Temp:" + String(format: "%.0f °C",  tempSmallLeft)
                    hum1.text = "Hum: " + String("\(humSmallLeft) %")
                }
                else {
                    self.smallLeft.alpha = 0
                    self.smallLeft.isHidden = true
                }
                if (index3 > -1) {
                    self.bigRight.alpha = 0.7
                    self.bigRight.isHidden = false
                    self.tempBigRight =  self.firebaseTemps[index3]
                    self.humBigRight = self.firebaseHums[index3]
                    self.aqiBigRight = self.firebaseAqis[index3]
                    getSteetIntersection(latitude: self.firebaseLatLong[index3].lat, longitude: self.firebaseLatLong[index3].long, number: 3)
                    temp3.text = "Temp:" + String(format: "%.0f °C",  tempBigRight)
                    hum3.text = "Hum: " + String("\(humBigRight) %")
                }
                else {
                    self.bigRight.alpha = 0
                    self.bigRight.isHidden = true
                }
                
                if (index4 > -1) {
                    self.smallRight.alpha = 0.7
                    self.smallRight.isHidden = false
                    self.tempSmallRight =  self.firebaseTemps[index4]
                    self.humSmallRight = self.firebaseHums[index4]
                    self.aqiSmallRight = self.firebaseAqis[index4]
                   getSteetIntersection(latitude: self.firebaseLatLong[index4].lat, longitude: self.firebaseLatLong[index4].long, number: 4)
                    temp4.text = "Temp:" + String(format: "%.0f °C", tempSmallRight)
                    hum4.text = "Hum: " + String("\(humSmallRight) %")
                }
                else {
                    self.smallRight.alpha = 0
                    self.smallRight.isHidden = true
                }
            }
            

            
        }
        
        
    }
    
    func getSteetIntersection(latitude: String, longitude: String, number: Int) {
        let url = interString + latitude + "&lng=" + longitude + "&username=me"
        
        
        Alamofire.request(url).responseJSON(completionHandler: {
            response in
            let result = response.result
            
            if let dict = result.value as? [String:Any], let intersections = dict["intersection"] as? [String:Any] {
                let street11 = intersections["street1"] as? String
                let street22 = intersections["street2"] as? String
                
                let street1Arr = street11?.components(separatedBy: " Street")
                let street2Arr = street22?.components(separatedBy: " Street")
                
                let street = (street1Arr?[0])! + " and " + (street2Arr?[0])!
                
                print(street)
                
                if (number == 1) {
                  self.street1.text = street
                }
                
                else if (number == 2) {
                    self.street2.text = street
                }
                else if (number == 3) {
                    self.street3.text = street
                }
                else if (number == 4) {
                    self.street4.text = street
                }
                
            }
        })
        
        
    }
    
    func calculateDistace(lat: Double, long: Double) -> Double {
        let lastLocatioLat = Double(lastLocation.coordinate.latitude)
        let lastLocationLong = Double(lastLocation.coordinate.longitude)
        
        let distance = pow((lastLocatioLat - lat), 2.0) + pow((lastLocationLong - long), 2.0)
        return distance.squareRoot()
    }
    
    
    
    func degreesToRadians(degrees: Double) -> Double { return degrees * .pi / 180.0 }
    func radiansToDegrees(radians: Double) -> Double { return radians * 180.0 / .pi }
    
    func getBearingBetweenTwoPoints1(point1 : CLLocation, point2 : CLLocation) -> Double {
        
        let lat1 = degreesToRadians(degrees: point1.coordinate.latitude)
        let lon1 = degreesToRadians(degrees: point1.coordinate.longitude)
        
        let lat2 = degreesToRadians(degrees: point2.coordinate.latitude)
        let lon2 = degreesToRadians(degrees: point2.coordinate.longitude)
        
        let dLon = lon2 - lon1
        
        let y = sin(dLon) * cos(lat2)
        let x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dLon)
        let radiansBearing = atan2(y, x)
        
        
        return (radiansToDegrees(radians: radiansBearing) - lastHeading)
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        
        lastLocation = manager.location!
        let temp = manager.location?.coordinate
        self.locationManager.stopUpdatingLocation()
        let latitude: String =  String(format: "%.4f", (temp?.latitude)!)
        let longitude: String = String(format: "%.4f", (temp?.longitude)!)
        
        
        userCo = Coordinates(latitude: Double(latitude)!, longitude: Double(longitude)!)
        
        
       

        setupWeather()
        setupAqi(latitude: latitude, longitude: longitude)
        setupIntersections(latitude: latitude, longitude: longitude)
        
        
        ref = Database.database().reference()
        
        // fix query
        databaseHandle = ref.child("SeoulTest01").child("data").queryLimited(toFirst: 50).observe(.childAdded, with:{ (snapshot) in
            // code to execute when child is added
            let postDict = snapshot.value as! [String : AnyObject]
            let lat = postDict["gpsdatalat"] as! String
            let long = postDict["gpsdatalng"] as! String
            let latShortened = String(format: "%.2f", Double(lat)!)
            let longShortened = String(format: "%.2f", Double(long)!)
            
            let mylatShorteneed = String(format: "%.2f", (temp?.latitude)!)
           // let mylongShortened = String(format: "%.2f", (temp?.longitude)!)
            let mylongShortened = "-74.65" // fix this

            
            var moveOn: Bool = false
            
            if(mylatShorteneed == latShortened && mylongShortened == longShortened) {
            let tuple = mytuple(lat, long)
                
            if (self.firebaseLatLong.count == 0) {
                self.firebaseLatLong.append(tuple)
                let hum = postDict["Hum"] as! String
                let temp = postDict["Temp"] as! String
                let aqi =  postDict["AQI"] as! String
                self.firebaseHums.append(Int(Double(hum)!))
                self.firebaseTemps.append(Double(temp)!)
                self.firebaseAqis.append((Double(aqi))!)
            }
            else {
            
               for object in self.firebaseLatLong {
                    let objectLat = String(format: "%.3f", Double(object.lat)!)
                    let objectLong = String(format: "%.3f", Double(object.long)!)
                
                    print(objectLat)
                
                
                    let tupLat = String(format: "%.3f", Double(lat)!)
                    let tupLong = String(format: "%.3f", Double(long)!)
                
                    print(tupLat)
                
                    if (objectLat == tupLat && objectLong == tupLong) {
                    moveOn = true
                    continue
                  }
                }
              
            if (moveOn) {
                
            }
            else {
               
              self.firebaseLatLong.append(tuple)
              let hum = postDict["Hum"] as! String
              let temp = postDict["Temp"] as! String
              let aqi =  postDict["AQI"] as! String
              self.firebaseAqis.append((Double(aqi))!)
              self.firebaseHums.append(Int(Double(hum)!))
               self.firebaseTemps.append(Double(temp)!)
              }
                
            }
          }
        })
        
        self.onDraw()
        
        
        self.street = []
        self.LatLong = [mytuple]()
        self.firebaseLatLong = [mytuple]()
        self.firebaseTemps = [Double]()
        self.firebaseHums = [Int]()

      
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        
    
        let heading = Double(newHeading.magneticHeading)
        
        if (heading > 180) {
            lastHeading = heading - 360
        }
        
        else {
            lastHeading = heading
        }
        
        self.onDraw()
    }
    
   
    
    func updateLocation() {
        if (showViews) {
        FirebaseFailed = true
        locationManager.startUpdatingLocation()
        locationManager.startUpdatingHeading()
        }
    }
    
 // -------------------------------------------------------------------------------------------------------------------------

    override func viewWillAppear(_ animated: Bool) {
       self.navigationController?.navigationBar.isHidden = true
       AppUtility.lockOrientation(.landscapeRight, andRotateTo: .landscapeRight)
        
        var locationTimer = Timer.scheduledTimer(timeInterval: 180.0, target: self, selector: Selector("updateLocation"), userInfo: nil, repeats: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Don't forget to reset when view is being removed
        AppUtility.lockOrientation(.all)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // -------------------------------------------------------------------------------------------------------------------------
    
    
    @IBAction func mapButtonPressed(_ sender: Any) {
        let webViewController = WebViewController(nibName: "WebViewController", bundle: nil)
        self.navigationController?.pushViewController(webViewController, animated: true)
    }
    
    @IBAction func camButtonPressed(_ sender: Any) {
        var image = UIImage()
        // set image
        if let videoConnection = sessionOutput.connection(withMediaType: AVMediaTypeVideo) {
            sessionOutput.captureStillImageAsynchronously(from: videoConnection, completionHandler: {
                buffer, error in
                
                let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(buffer)
                var data = CGDataProvider.init(data: imageData as! CFData)
                let cgimageRef = CGImage.init(jpegDataProviderSource: data!, decode: nil, shouldInterpolate: true, intent: .defaultIntent)
                image = UIImage.init(cgImage: cgimageRef!, scale: 1.0, orientation: .up)
                self.imageView.image = image
                
                let layer = UIApplication.shared.keyWindow!.layer
                let scale = UIScreen.main.scale
                UIGraphicsBeginImageContextWithOptions(layer.frame.size, false, 0.0)
                
                layer.render(in: UIGraphicsGetCurrentContext()!)
                let screenshot = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
                        
                UIImageWriteToSavedPhotosAlbum(screenshot!, nil, nil, nil)
                
                
                self.imageView.image = nil
            })
        }
        
        
        
    }
    
    
    @IBAction func airButtonPressed(_ sender: Any) {
        if (aqiToggle) {
            // do stuff here
            aqiToggle = !aqiToggle
            let image = UIImage(named: "aqi shaded")
            airButton.setImage(image, for: .normal)
            self.filterView.alpha = 0.5
            self.filterView.backgroundColor = UIColor(red: 67/255, green: 67/255, blue: 67/255, alpha: 0.5)
            filterToggle = false
            
            
            if (currentAQI == aqiSmallLeft) {
                self.smallLeft.alpha = 0.0
            }
                
            else  {
                
                let difference = (aqiSmallLeft - currentAQI)*20
                
                let greenNum = (155 - difference)
                self.smallLeft.backgroundColor = UIColor(white: CGFloat(greenNum/255), alpha: 0.7)
            }
            //
            
            
            if (currentAQI == aqiBigLeft) {
                self.bigLeft.alpha = 0.0
            }
                
            else  {
                
                let difference = (aqiBigLeft - currentAQI)*20
                
                let greenNum = (155 - difference)
                
                
                self.bigLeft.backgroundColor = UIColor(white: CGFloat(greenNum/255), alpha: 0.7)
            }
            
            if (currentAQI == aqiSmallRight) {
                self.smallRight.alpha = 0.0
            }
                
            else  {
                
                let difference = (aqiSmallRight - currentAQI)*20
                
                let greenNum = (155 - difference)
                
                self.smallRight.backgroundColor = UIColor(white: CGFloat(greenNum/255), alpha: 0.7)
            }
            
            if (currentAQI == aqiBigRight) {
                self.bigRight.alpha = 0.0
            }
                
            else  {
                
                let difference = (aqiBigRight - currentAQI)*20
                
                let greenNum = (155 - difference)
                
                self.bigRight.backgroundColor = UIColor(white: CGFloat(greenNum/255), alpha: 0.7)
                
            }
            
            

        }
        else {
            // go back
            filterToggle = true
            self.filterView.alpha = 0
            hideLabels(toggle: false)
            aqiToggle = !aqiToggle
            let image = UIImage(named: "aqi")
            airButton.setImage(image, for: .normal)
        }
    
    }
    
    @IBAction func humButtonPressed(_ sender: Any) {
        if (humToggle) {
            // do stuff here
            humToggle = !humToggle
            let image = UIImage(named: "hum shaded")
            humButton.setImage(image, for: .normal)
            self.filterView.alpha = 0.5
            self.filterView.backgroundColor = UIColor(red: 0/255, green: 155/255, blue: 255/255, alpha: 0.5)
            filterToggle = false
            // dealWithView(value: tempSmallLeft, num: 1, state: 1)
            
            if (currentHum == humSmallLeft) {
                self.smallLeft.alpha = 0.0
            }
                
            else  {
                
                let difference = (humSmallLeft - currentHum)*20
                
                let greenNum = (155 - difference)
                self.smallLeft.backgroundColor = UIColor(red: 0/255, green: CGFloat(greenNum/255), blue: 255/255, alpha: 0.7)
            }
                //
            
            
            if (currentHum == humBigLeft) {
                self.bigLeft.alpha = 0.0
            }
                
            else  {
                
                let difference = (humBigLeft - currentHum)*20
                
                let greenNum = (155 - difference)
                
                self.bigLeft.backgroundColor = UIColor(red: 0/255, green: CGFloat(greenNum/255), blue: 255/255, alpha: 0.7)
            }
            
            if (currentHum == humSmallRight) {
                self.smallRight.alpha = 0.0
            }
                
            else  {
                
                let difference = (humSmallRight - currentHum)*20
                
                let greenNum = (155 - difference)
                
                self.smallRight.backgroundColor = UIColor(red: 0/255, green: CGFloat(greenNum/255), blue: 255/255, alpha: 0.7)
            }
            
            if (currentHum == humBigRight) {
                self.bigRight.alpha = 0.0
            }
            
            else  {
                
                let difference = (humBigRight - currentHum)*20
                
                let greenNum = (155 - difference)
                
                self.bigRight.backgroundColor = UIColor(red: 0/255, green: CGFloat(greenNum/255), blue: 255/255, alpha: 0.7)
            }

            
        }
        else {
            // go back
            filterToggle = true
            self.filterView.alpha = 0
            hideLabels(toggle: false)
            humToggle = !humToggle
            let image = UIImage(named: "hum")
            humButton.setImage(image, for: .normal)
        }
        
    }
    
    func hideLabels(toggle: Bool) {
        
        if (!toggle) {
            self.smallLeft.alpha = 0.7
            self.bigLeft.alpha = 0.7
            self.smallRight.alpha = 0.7
            self.bigRight.alpha = 0.7
            self.smallLeft.backgroundColor = UIColor.lightGray
            self.bigLeft.backgroundColor = UIColor.lightGray
            self.smallRight.backgroundColor = UIColor.lightGray
            self.bigRight.backgroundColor = UIColor.lightGray
        }
    }
    
    
    
    @IBAction func tempButtonPressed(_ sender: Any) {
        
        if (tempToggle) {
            // do stuff here
            tempToggle = !tempToggle
            let im = UIImage(named: "temp shaded")
            tempButton.setImage(im, for: .normal)
            self.filterView.alpha = 0.5
            self.filterView.backgroundColor = UIColor(red: 255/255, green: 105/255, blue: 0/255, alpha: 0.5)
            filterToggle = false
            
           // dealWithView(value: tempSmallLeft, num: 1, state: 1)
//            
            if (currentTemp == tempSmallLeft) {
                self.smallLeft.alpha = 0.0
            }
            
            else {
                let difference = (tempSmallLeft - currentTemp)*20
                
                let greenNum = (105 - difference)
                
                self.smallLeft.backgroundColor = UIColor(red: 255/255, green: CGFloat(greenNum/255), blue: 0/255, alpha: 0.7)
                
            }
            
            if (currentTemp == tempBigLeft) {
                self.bigLeft.alpha = 0
            }
            
            else {
                let difference = (tempBigLeft - currentTemp)*20
                
                let greenNum = (105 - difference)
                
                self.bigLeft.backgroundColor = UIColor(red: 255/255, green: CGFloat(greenNum/255), blue: 0/255, alpha: 0.7)
                
            }
            
            if (currentTemp == tempBigRight) {
                self.bigRight.alpha = 0
            }
                
            else {
                let difference = (tempBigRight - currentTemp)*20
                
                let greenNum = (105 - difference)
                
                self.bigRight.backgroundColor = UIColor(red: 255/255, green: CGFloat(greenNum/255), blue: 0/255, alpha: 0.7)
                
            }
            
            if (currentTemp == tempSmallRight) {
                self.smallRight.alpha = 0
            }
            else {
                let difference = (tempSmallRight - currentTemp)*20
                
                let greenNum = (105 - difference)
                
                self.smallRight .backgroundColor = UIColor(red: 255/255, green: CGFloat(greenNum/255), blue: 0/255, alpha: 0.7)
                
            }
            
           
        }
        else {
            // go back
            filterToggle = true
            self.filterView.alpha = 0
            hideLabels(toggle: false)
            self.imageView.image = nil
            tempToggle = !tempToggle
             let image = UIImage(named: "temp")
            tempButton.setImage(image, for: .normal)
        }
        
        
    }
    
    @IBAction func buttonInBigViewPressed(_ sender: Any) {
        
        
        
        UIView.animate(withDuration: 0.5, delay: 0, options: [], animations: {
            self.smallLeft.alpha = 0 // Here you will get the animation you want
            self.bigLeft.alpha = 0
            self.bigRight.alpha = 0
            self.smallRight.alpha = 0
            self.centerView.alpha = 1
        }, completion: { _ in
            self.filterToggle = false
            self.smallLeft.isHidden = true // Here you hide it when animation done
            self.bigLeft.isHidden = true
            self.bigRight.isHidden = true
            self.smallRight.isHidden = true
            self.centerView.isHidden = false
            self.centerStreet.text = self.street2.text!
            self.centerHum.text = self.hum2.text!
            self.centerTemp.text = self.temp2.text!
            })
      
    }
    
    @IBAction func buttonInMediumViewPressed(_ sender: Any) {
        
        
        UIView.animate(withDuration: 0.5, delay: 0, options: [], animations: {
            self.smallLeft.alpha = 0 // Here you will get the animation you want
            self.bigLeft.alpha = 0
            self.bigRight.alpha = 0
            self.smallRight.alpha = 0
            self.centerView.alpha = 1
        }, completion: { _ in
            self.filterToggle = false
            self.smallLeft.isHidden = true // Here you hide it when animation done
            self.bigLeft.isHidden = true
            self.bigRight.isHidden = true
            self.smallRight.isHidden = true
            self.centerView.isHidden = false
            self.centerStreet.text = self.street3.text!
            self.centerHum.text = self.hum3.text!
            self.centerTemp.text = self.temp3.text!
            
        })
        
    }
   
    @IBAction func buttonInSmallViewPressed(_ sender: Any) {
        
        
        
        UIView.animate(withDuration: 0.5, delay: 0, options: [], animations: {
            self.smallLeft.alpha = 0 // Here you will get the animation you want
            self.bigLeft.alpha = 0
            self.bigRight.alpha = 0
            self.smallRight.alpha = 0
            self.centerView.alpha = 1
        }, completion: { _ in
            self.filterToggle = false
            self.smallLeft.isHidden = true // Here you hide it when animation done
            self.bigLeft.isHidden = true
            self.bigRight.isHidden = true
            self.smallRight.isHidden = true
            self.centerView.isHidden = false
            self.centerStreet.text = self.street1.text!
            self.centerHum.text = self.hum1.text!
            self.centerTemp.text = self.temp1.text!
        })
    }
    
    @IBAction func buttonInCenterViewPressed(_ sender: Any) {
        UIView.animate(withDuration: 0.5, delay: 0, options: [], animations: {
            self.smallLeft.alpha = 0.7 // Here you will get the animation you want
            self.bigLeft.alpha = 0.7
            self.bigRight.alpha = 0.7
            self.smallRight.alpha = 0.7
            self.centerView.alpha = 0
        }, completion: { _ in
            self.filterToggle = true
            self.smallLeft.isHidden = false // Here you hide it when animation done
            self.bigLeft.isHidden = false
            self.bigRight.isHidden = false
            self.smallRight.isHidden = false
            self.centerView.isHidden = true
        })

    }
    
    @IBAction func buttoninsmallRightpressed(_ sender: Any) {
        UIView.animate(withDuration: 0.5, delay: 0, options: [], animations: {
            self.smallLeft.alpha = 0 // Here you will get the animation you want
            self.bigLeft.alpha = 0
            self.bigRight.alpha = 0
            self.smallRight.alpha = 0
            self.centerView.alpha = 1
        }, completion: { _ in
            self.filterToggle = false
            self.smallLeft.isHidden = true // Here you hide it when animation done
            self.bigLeft.isHidden = true
            self.bigRight.isHidden = true
            self.smallRight.isHidden = true
            self.centerView.isHidden = false
            self.centerStreet.text = self.street4.text!
            self.centerHum.text = self.hum4.text!
            self.centerTemp.text = self.temp4.text!
            
        })
        
        
    }
    
    
    
    
    
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

//
//  MapViewController.swift
//  Arapp
//
//  Created by Abdulghafar Al Tair on 4/28/17.
//  Copyright © 2017 Abdulghafar Al Tair. All rights reserved.
//

import UIKit
import MapKit
class MapViewController: UIViewController, MKMapViewDelegate {
    @IBOutlet weak var mapView: MKMapView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = false
        self.setupMapView()
        mapView.delegate = self

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
        self.setupMapView()
        mapView.delegate = self
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupMapView() {
        mapView.showsUserLocation = true
        
        mapView.mapType = .standard
        mapView.userTrackingMode = .follow

    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

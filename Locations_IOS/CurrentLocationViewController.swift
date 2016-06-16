//
//  FirstViewController.swift
//  Locations_IOS
//
//  Created by cham-s on 16/06/16.
//  Copyright © 2016 StellarTech Media. All rights reserved.
//

import UIKit
import CoreLocation

class CurrentLocationViewController: UIViewController, CLLocationManagerDelegate {
    
    // MARK: - Outlets
    
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var longitudeLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var tabButton: UIButton!
    @IBOutlet weak var getButton: UIButton!
    
    // MARK: - Instances Variables
    
    let locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: -  CLLocationDelegate
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Fail with error: \(error)")
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let newLocation = locations.last!
        print("Last location: \(newLocation)")
    }
    
    // MARK: -  Actions
    @IBAction func getLocation() {
        let authStatus = CLLocationManager.authorizationStatus()
        
        if case .NotDetermined = authStatus {
            locationManager.requestWhenInUseAuthorization()
            return
        }
        switch authStatus {
        case .Denied, .Restricted:
            showLocationServicesDeniedAlert()
        default:
            print("othercase")
        }
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.startUpdatingLocation()
    }
    
    // MARK: - Custom Methods
    
    func showLocationServicesDeniedAlert() {
        let alert = UIAlertController(title: "Location Services Disabled", message: "Please enable location for this app in Settings",preferredStyle: .Alert)
        
        let okAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        
        alert.addAction(okAction)
        
        presentViewController(alert, animated: true, completion: nil)
    }


}


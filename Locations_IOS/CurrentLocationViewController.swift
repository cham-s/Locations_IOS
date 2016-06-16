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
    var location: CLLocation?
    var updatingLocation = false
    var laslocationError: NSError?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        updateLabels()
        configureGetButton()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: -  CLLocationDelegate
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Fail with error: \(error)")
        
        if error.code == CLError.LocationUnknown.rawValue {
            return
        }
        
        laslocationError = error
        
        stopLocationManager()
        updateLabels()
        configureGetButton()
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let newLocation = locations.last!
        print("Last location: \(newLocation)")
        
        if newLocation.timestamp.timeIntervalSinceNow < -5 {
            return
        }
        
        if newLocation.horizontalAccuracy < 0 {
            return
        }
        
        if location == nil || location!.horizontalAccuracy > newLocation.horizontalAccuracy{
            laslocationError = nil
            location = newLocation
            updateLabels()
        }
        
        if newLocation.horizontalAccuracy <= locationManager.desiredAccuracy {
            print("done!")
            stopLocationManager()
            configureGetButton()
        }
    }
    
    // MARK: -  Actions
    @IBAction func getLocation() {
        if updatingLocation {
            stopLocationManager()
            
        } else {
            location = nil
            laslocationError = nil
            startLocationManager()‘
        }
    }
    
    // MARK: - Custom Methods
    
    func showLocationServicesDeniedAlert() {
        let alert = UIAlertController(title: "Location Services Disabled", message: "Please enable location for this app in Settings",preferredStyle: .Alert)
        
        let okAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        
        alert.addAction(okAction)
        
        presentViewController(alert, animated: true, completion: nil)
    }
    
    func updateLabels() {
        if let location = location {
            latitudeLabel.text = String(format: "%.8f", location.coordinate.latitude)
            longitudeLabel.text = String(format: "%.8f", location.coordinate.latitude)
            tabButton.hidden = false
            messageLabel.text = ""
        } else {
            latitudeLabel.text = ""
            longitudeLabel.text = ""
            addressLabel.text = ""
            tabButton.hidden = true
            
            let statusMessage: String
            if let error = laslocationError {
                if error.domain == kCLErrorDomain && error.code == CLError.Denied.rawValue {
                    statusMessage = "Location Services Disabled"
                } else {
                    statusMessage = "Eroor Getting Location"
                }
            } else if !CLLocationManager.locationServicesEnabled() {
                statusMessage = "Location Services Disabled"
            } else if updatingLocation {
                statusMessage = "Searching..."
            } else {
                statusMessage = "Tap 'Get My Location' to Start"
            }
            messageLabel.text = statusMessage
        }
    }
    
    func startLocationManager() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
            updatingLocation = true
        }
    }
    
    func stopLocationManager() {
        if updatingLocation {
            locationManager.stopUpdatingLocation()
            locationManager.delegate = nil
            updatingLocation = false
        }
    }
    
    func configureGetButton(){
        if updatingLocation {
            getButton.setTitle("Stop", forState: .Normal)
        } else {
            getButton.setTitle("Get My Location", forState: .Normal)
        }
    }
}


//
//  ViewController.swift
//  DemoCoreLocation-UIKit
//

import UIKit
import CoreLocation

class ViewController: UIViewController {
    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var longitudeLabel: UILabel!
    
    var count = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        LocationManager.shared().startUpdating { (location) in
            print("latitude: \(location.coordinate.latitude), longitude: \(location.coordinate.longitude)")
            self.latitudeLabel.text = "\(location.coordinate.latitude)"
            self.longitudeLabel.text = "\(location.coordinate.longitude)"
            
            // Gte Address Location
            LocationManager.shared().getAddress(location: location)

            if self.count < 10 {
                self.count += 1
            } else {
                LocationManager.shared().stopUpdating()
            }
        }
    }
    
    @IBAction func getCurrentLocationTapped(_ sender: Any) {
        print("Get Current Location")
        LocationManager.shared().getCurrentLocation { (location) in
            print("Location Current \(location)")
        }
    }
}


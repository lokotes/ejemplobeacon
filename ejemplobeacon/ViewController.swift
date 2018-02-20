//
//  ViewController.swift
//  ejemplobeacon
//
//  Created by MacAMP on 20/02/18.
//  Copyright © 2018 MacAMP. All rights reserved.
//

import UIKit
import CoreLocation
import UserNotifications

class ViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var lblLocacion: UILabel!
    var locationManager: CLLocationManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        locationManager = CLLocationManager()
        locationManager.delegate = self
        
        locationManager.requestAlwaysAuthorization()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways {
            if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
                if CLLocationManager.isRangingAvailable() {
                    startScanning()
                }
            }
        }
    }
    
    func startScanning() {
        
        let uuid = UUID(uuidString: "A596EBF0-163B-4F0C-B55F-B9DEDFB7CF78")!
        let beaconRegion = CLBeaconRegion(proximityUUID: uuid, major: 1000, minor: 1007, identifier: "amp")
        //let beaconRegion = CLBeaconRegion(proximityUUID: uuid, major: 1000, identifier: "")
        locationManager.startMonitoring(for: beaconRegion)
        locationManager.startRangingBeacons(in: beaconRegion)
        //locationManager.allowsBackgroundLocationUpdates = true
    }
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        //print(beacons.count)
        //print(beacons[0].)
        
        if beacons.count > 0 {
            updateDistance(beacons[0])
        }
    }
    
    func updateDistance(_ beacon: CLBeacon) {
        UIView.animate(withDuration: 1) {
            switch beacon.proximity {
            case .unknown:
                self.view.backgroundColor = UIColor.gray
                self.lblLocacion.text = " (approx. \(beacon.accuracy)m)"
                print("desconocido")
            case .far:
                self.view.backgroundColor = UIColor.blue
                self.lblLocacion.text = " (approx. \(beacon.accuracy)m)"
                print("lejos")
            case .near:
                self.view.backgroundColor = UIColor.orange
                self.lblLocacion.text = " (approx. \(beacon.accuracy)m)"
                print("cerca")
            case .immediate:
                self.view.backgroundColor = UIColor.red
                self.lblLocacion.text = " (approx. \(beacon.accuracy)m)"
                print("junto")
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didDetermineState state: CLRegionState, for region: CLRegion) {
        
        // Check if the user's INSIDE the region, not outside...
        
        guard state == CLRegionState.inside else { print("Not inside."); return }
        print("hola")
        // Alright, we're in range. Time to get the user to open the app and make their entrance.
        
        let content = UNMutableNotificationContent()
        content.title = "Beacon found!"
        content.body = "You're inside the region of a beacon you wanted to monitor!"
        content.sound = UNNotificationSound.default()
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: "1389402323904", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { (err:Error?) in
            
            
        }
        
    }
    
    
    
    
    
}


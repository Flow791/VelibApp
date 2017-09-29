//
//  ViewController.swift
//  BeApp_Velib
//
//  Created by Florian Baudin on 28/09/2017.
//  Copyright © 2017 Florian Baudin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let stationManager:StationManager = StationManager()
    var stations:[Station] = [Station]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        stationManager.loadStation(completion: receiveStations)
        
        
        
    }

    private func receiveStations(_ stations: [Station]) {
        self.stations = stations
        
        for value in stations {
            print(value.name!)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


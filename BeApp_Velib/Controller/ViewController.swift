//
//  ViewController.swift
//  BeApp_Velib
//
//  Created by Florian Baudin on 28/09/2017.
//  Copyright © 2017 Florian Baudin. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource {

    private let stationManager:StationManager = StationManager()
    var stations:[Station] = [Station]()
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        stationManager.loadStation(completion: receiveStations)
        
        tableView.dataSource = self
    }

    private func receiveStations(_ stations: [Station]) {
        self.stations = stations
        
        tableView.reloadData()
        
        for value in stations {
            print(value.name!)
        }
    }
    
    // MARK: TableView
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "stationCell")!
        
        cell.textLabel?.text = stations[indexPath.row].name!
        
        return cell
    }

}


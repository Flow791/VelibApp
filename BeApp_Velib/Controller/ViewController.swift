//
//  ViewController.swift
//  BeApp_Velib
//
//  Created by Florian Baudin on 28/09/2017.
//  Copyright © 2017 Florian Baudin. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UISearchResultsUpdating {

    private let stationManager:StationManager = StationManager()
    var stations:[Station] = [Station]()
    var filteredStations:[Station] = [Station]()
    let searchController = UISearchController(searchResultsController: nil)
    
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        stationManager.loadStation(completion: receiveStations)
        
        tableView.dataSource = self
        
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        searchView.addSubview(searchController.searchBar)
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
        if isFiltering() {
            return filteredStations.count
        }
        return stations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "stationCell")!
        
        if isFiltering() {
            cell.textLabel!.text = filteredStations[indexPath.row].name!
        } else {
            cell.textLabel!.text = stations[indexPath.row].name!
        }
        
        return cell
    }

    //MARK : Search Bar
    
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!.lowercased())
    }
    
    func searchBarIsEmpty() -> Bool {
        // Returns true if the text is empty or nil
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        filteredStations = stations.filter({( station : Station) -> Bool in
            return station.name!.lowercased().contains(searchText.lowercased())
        })
        
        tableView.reloadData()
    }
    
    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
    
}


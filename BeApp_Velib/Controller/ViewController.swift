//
//  ViewController.swift
//  BeApp_Velib
//
//  Created by Florian Baudin on 28/09/2017.
//  Copyright © 2017 Florian Baudin. All rights reserved.
//

import UIKit
import Toaster
import Refresher

class ViewController: UIViewController, UITableViewDataSource, UISearchResultsUpdating {

    private let stationManager:StationManager = StationManager()
    var stations:[Station] = [Station]()
    var filteredStations:[Station] = [Station]()
    let searchController = UISearchController(searchResultsController: nil)
    var openedStations:[Station] = [Station]()
    var closedStations:[Station] = [Station]()    
    
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func changedSegmentedChoice(_ sender: Any) {
        
        if isFiltering(){

            sortStations(stations: filteredStations)
            tableView.reloadData()
        }else {

            sortStations(stations: stations)
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        stationManager.loadStation(completion: receiveStations)
        
        tableView.dataSource = self
        tableView.rowHeight = 80
        
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        searchView.addSubview(searchController.searchBar)
        
        refresh()
    }

    private func receiveStations(_ stations: [Station], error:Error?) {
        self.stations = stations
        
        guard error == nil else {
            return Toast(text: "Aucune Connexion...", delay: Delay.short, duration: Delay.long).show()
        }
        
        sortStations(stations: stations)
        
        tableView.reloadData()
        self.tableView.stopPullToRefresh()
    }
    
    // MARK: TableView
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if isFiltering() {
            switch segmentedControl.selectedSegmentIndex {
            case 0:
                return filteredStations.count
            case 1:
                return openedStations.count
            case 2:
                return closedStations.count
            default :
                return 0
            }
            
        } else {
            switch segmentedControl.selectedSegmentIndex {
            case 0:
                return stations.count
            case 1:
                return openedStations.count
            case 2:
                return closedStations.count
            default:
                return 0
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "stationCell") as! StationTableViewCell
        
        if isFiltering() {
            switch segmentedControl.selectedSegmentIndex {
            case 0:
                cell.nameLabelCell.text = filteredStations[indexPath.row].name!
                cell.statusLabelCell.text = filteredStations[indexPath.row].status!
                cell.bikeLabelCell.text = "Vélos : \(filteredStations[indexPath.row].bikeStands)"
                cell.availableLabelCell.text = "Disponible : \(filteredStations[indexPath.row].availableBike)"
            case 1:
                cell.nameLabelCell.text = openedStations[indexPath.row].name!
                cell.statusLabelCell.text = openedStations[indexPath.row].status!
                cell.bikeLabelCell.text = "Vélos : \(openedStations[indexPath.row].bikeStands)"
                cell.availableLabelCell.text = "Disponible : \(openedStations[indexPath.row].availableBike)"
            case 2:
                cell.nameLabelCell.text = closedStations[indexPath.row].name!
                cell.statusLabelCell.text = closedStations[indexPath.row].status!
                cell.bikeLabelCell.text = "Vélos : \(closedStations[indexPath.row].bikeStands)"
                cell.availableLabelCell.text = "Disponible : \(closedStations[indexPath.row].availableBike)"
            default :
                cell.textLabel!.text = "Error"
            }
        } else {
            switch segmentedControl.selectedSegmentIndex {
            case 0:
                cell.nameLabelCell.text = stations[indexPath.row].name!
                cell.statusLabelCell.text = stations[indexPath.row].status!
                cell.bikeLabelCell.text = "Vélos : \(stations[indexPath.row].bikeStands)"
                cell.availableLabelCell.text = "Disponible : \(stations[indexPath.row].availableBike)"
            case 1:
                cell.nameLabelCell.text = openedStations[indexPath.row].name!
                cell.statusLabelCell.text = openedStations[indexPath.row].status!
                cell.bikeLabelCell.text = "Vélos : \(openedStations[indexPath.row].bikeStands)"
                cell.availableLabelCell.text = "Disponible : \(openedStations[indexPath.row].availableBike)"
            case 2:
                cell.nameLabelCell.text = closedStations[indexPath.row].name!
                cell.statusLabelCell.text = closedStations[indexPath.row].status!
                cell.bikeLabelCell.text = "Vélos : \(closedStations[indexPath.row].bikeStands)"
                cell.availableLabelCell.text = "Disponible : \(closedStations[indexPath.row].availableBike)"
            default :
                cell.textLabel!.text = "Error"
            }
        }
        
        return cell
    }

    //MARK : Search Bar
    
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!.lowercased())
        sortStations(stations: filteredStations)
        tableView.reloadData()
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
    
    //MARK : SegmentedControl
    
    func sortStations(stations: [Station]) {
        
        openedStations = []
        closedStations = []
        
        for station in stations {
            if station.status == "OPEN"{
                openedStations.append(station)
            }else {
                closedStations.append(station)
            }
        }
    }
    
    //MARK: Refreshing
    
    private func refresh() {
        tableView.addPullToRefreshWithAction {
            DispatchQueue.global().async {
                self.stationManager.loadStation(completion: self.receiveStations)
            }
        }
    }
}


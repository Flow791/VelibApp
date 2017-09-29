//
//  StationManager.swift
//  BeApp_Velib
//
//  Created by Florian Baudin on 28/09/2017.
//  Copyright © 2017 Florian Baudin. All rights reserved.
//

import UIKit
import Foundation
import CoreData

class StationManager  {
    
    private let url = URL(string: "https://api.jcdecaux.com/vls/v1/stations?contract=Paris&apiKey=99b373f97dca487124258364f9f9d54546f1a65f")!
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func loadStation(completion: @escaping (_ data:[Station])->()) {
        
        let stations:[Station] = [Station]()
        let task = URLSession.shared.dataTask(with: self.url) { (data, response, error) in
            
            guard error == nil else {
                completion([Station]())
                return
            }

            DispatchQueue.main.async {
                self.deleteAllStations()
                completion(self.parse(data: data))
            }
        }
        task.resume()
        
        completion(stations)
    }
    
    private func parse(data: Data?) -> [Station] {
        guard let data = data,
            let serializedJson = try? JSONSerialization.jsonObject(with: data, options: []),
            let result = serializedJson as? [[String: Any]] else {
                return [Station]()
        }
        
        return getStationsListFrom(parsedData : result)
    }
    
    private func getStationsListFrom(parsedData : [[String:Any]]) -> [Station] {
        
        var stationsList = [Station]()
        
        for data in parsedData {
            stationsList.append(getStationFrom(parsedData: data))
        }
        
        return stationsList
    }
    
    private func getStationFrom(parsedData: [String: Any]) -> Station {
        if let name = parsedData["name"] as? String,
            let status = parsedData["status"] as? String,
            let bikeStands = parsedData["bike_stands"] as? Int16,
            let availableBike = parsedData["available_bikes"] as? Int16{
            
            let station = createStation(name: name, status: status, bikeStands: bikeStands, availableBike: availableBike)

            return station
        }
        return Station()
    }
    
    private func saveStation(station:Station) {
        
        do {
            try self.context.save()
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
    
    private func createStation(name:String, status:String, bikeStands:Int16, availableBike:Int16) -> Station {
        
        let station = Station(context:context)
        
        station.name = name
        station.status = status
        station.bikeStands = bikeStands
        station.availableBike = availableBike
        
        saveStation(station: station)
        
        return station
    }
    
    private func getStationsSaved() -> [Station] {
        
        var stations:[Station] = []
        do {
            stations = try self.context.fetch(Station.fetchRequest())
        } catch {
            print("Fetching Failed")
        }
        return stations
    }
    
    private func deleteAllStations() {
        
        let stationsList = getStationsSaved()
        for station in stationsList {
            context.delete(station)
        }
        
        do {
            try context.save()
        }catch {
            print("Error")
        }
    }
    
}

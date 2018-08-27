//
//  CityTemperatureDataSource.swift
//  CollectionViewGraphing
//
//  Created by Brian Miller on 8/18/18.
//  Copyright © 2018 Brian Miller. All rights reserved.
//

import Foundation

class CityTemperatureDataSource {
    private lazy var baseData: [City] = {
        if let path = Bundle.main.path(forResource: "data", ofType: "json") {
            do {
                let urlPath = URL(fileURLWithPath: path)
                let jsonData = try Data(contentsOf: urlPath, options: .mappedIfSafe)
                let cities = try JSONDecoder().decode(CitiesResult.self, from: jsonData)
                return cities.cities
            } catch {
                debugPrint("Error - \(error.localizedDescription)")
            }
        }
        
        return []
    }()
    
    private(set) var city: City?
    private(set) var year: String?
    private(set) var temps: [Temperature] = []
    
    private(set) var sections: [String] = ["JAN", "FEB", "MAR", "APR",
                                      "MAY", "JUN", "JUL", "AUG",
                                      "SEP", "OCT", "NOV", "DEC"]
    private var selectedCity: String = "Dallas"
    private var selectedYear: Int = 2017
    
    func configure(with city: String, year: Int) {
        selectedCity = city
        selectedYear = year
        
        updateData()
    }
    
    var hasNextCity: Bool {
        guard let currentCity = city,
            let index = baseData.index(of: currentCity) else {
                return false
        }
        
        let nextCityIndex = index + 1
        return nextCityIndex < baseData.count
    }
    
    var hasPreviousCity: Bool {
        guard let currentCity = city,
            let index = baseData.index(of: currentCity) else {
                return false
        }
        
        let previousCityIndex = index - 1
        return previousCityIndex >= 0
    }
    
    func nextCity() -> Bool {
        guard let currentCity = city,
            let index = baseData.index(of: currentCity) else {
                return false
        }
        
        let nextCityIndex = index + 1
        if nextCityIndex < baseData.count {
            let nextCity = baseData[nextCityIndex]
            selectedCity = nextCity.name
            
            updateData()
            return true
        }
        
        return false
    }
    
    func previousCity() -> Bool {
        guard let currentCity = city,
            let index = baseData.index(of: currentCity) else {
                return false
        }
        
        let previousCityIndex = index - 1
        if previousCityIndex >= 0 {
            let previousCity = baseData[previousCityIndex]
            selectedCity = previousCity.name
            
            updateData()
            return true
        }
        
        return false
    }
    
    var hasNextYear: Bool {
        guard let currentCity = city else { return false }
        let years = currentCity.orderedYears()
        guard let index = years.index(of: selectedYear) else { return false }
        
        let nextYearIndex = index + 1
        return nextYearIndex < years.count
    }
    
    var hasPreviousYear: Bool {
        guard let currentCity = city else { return false }
        let years = currentCity.orderedYears()
        guard let index = years.index(of: selectedYear) else { return false }
        
        let previousYearIndex = index - 1
        return previousYearIndex >= 0
    }
    
    func nextYear() -> Bool {
        guard let currentCity = city else { return false }
        let years = currentCity.orderedYears()
        guard let index = years.index(of: selectedYear) else { return false }
        
        let nextYearIndex = index + 1
        if nextYearIndex < years.count {
            selectedYear = years[nextYearIndex]
            updateData()
            
            return true
        }
        
        return false
    }
    
    func previousYear() -> Bool {
        guard let currentCity = city else { return false }
        let years = currentCity.orderedYears()
        guard let index = years.index(of: selectedYear) else { return false }
        
        let previousYearIndex = index - 1
        if previousYearIndex >= 0 {
            selectedYear = years[previousYearIndex]
            updateData()
            
            return true
        }
        
        return false
    }
    
    private func updateData() {
        city = baseData.first(where: { $0.name == selectedCity })
        year = "\(selectedYear)"
        var temperatures: [Temperature] = []
        city?.temps(for: selectedYear).forEach({ temperatures.append(contentsOf: $0.temperatures())})
        temps = temperatures
    }
    
    public func temp(at indexPath: IndexPath) -> Temperature? {
        guard indexPath.item < temps.count else { return nil }
        
        return temps[indexPath.item]
    }
}

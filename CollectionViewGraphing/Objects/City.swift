//
//  State.swift
//  CollectionViewGraphing
//
//  Created by Brian Miller on 7/8/18.
//  Copyright © 2018 Brian Miller. All rights reserved.
//

import Foundation

struct City: Codable, Equatable, Hashable {
    let name: String
    let state: String
    let stateCode: String
    let temps: [MonthlyTemp]
    
    func temps(for year: Int) -> [MonthlyTemp] {
        return temps.filter({ $0.year == year })
    }
    
    enum CodingKeys: String, CodingKey {
        case name
        case state
        case stateCode
        case temps = "monthlyTemps"
    }
    
    func orderedYears() -> [Int] {
        let years = temps.compactMap({ $0.year })
        return Set(years).sorted(by: { $0 < $1 })
    }
}

//
//  MonthlyTemp.swift
//  CollectionViewGraphing
//
//  Created by Brian Miller on 7/8/18.
//  Copyright © 2018 Brian Miller. All rights reserved.
//

import UIKit

struct MonthlyTemp: Codable, Equatable, Hashable {
    let high: CGFloat
    let highDay: Int
    let low: CGFloat
    let lowDay: Int
    let month: Int
    let year: Int
    
    func temperatures() -> [Temperature] {
        return [Temperature(temp: high, day: highDay, month: month, year: year, isHigh: true),
                Temperature(temp: low, day: lowDay, month: month, year: year, isHigh: false)]
    }
}

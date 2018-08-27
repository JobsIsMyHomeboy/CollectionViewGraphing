//
//  CGPoint+Hashing.swift
//  CollectionViewGraphing
//
//  Created by Brian Miller on 7/7/18.
//  Copyright © 2018 Brian Miller. All rights reserved.
//

import UIKit

extension CGPoint: Hashable {
    public var hashValue: Int {
        return Int(x).hashValue ^ Int(y).hashValue
    }
}

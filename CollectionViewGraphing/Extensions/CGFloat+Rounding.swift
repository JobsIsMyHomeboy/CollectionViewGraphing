//
//  CGFloat+Rounding.swift
//  CollectionViewGraphing
//
//  Created by Brian Miller on 7/7/18.
//  Copyright © 2018 Brian Miller. All rights reserved.
//

import UIKit

extension CGFloat {
    func roundToHalf() -> CGFloat {
        let sign = self < 0 ? -1 : 1
        return CGFloat(floorf(Float(abs(self)) * Float(2.0)) / 2.0 * Float(sign))
    }
}

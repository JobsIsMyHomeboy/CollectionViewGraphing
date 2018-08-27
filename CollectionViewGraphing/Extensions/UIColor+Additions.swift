//
//  UIColor+Additions.swift
//  CollectionViewGraphing
//
//  Created by Brian Miller on 7/8/18.
//  Copyright © 2018 Brian Miller. All rights reserved.
//

import UIKit

extension UIColor {
    func blended(withFraction fraction: CGFloat, of color: UIColor) -> UIColor {
        var r1: CGFloat = 1.0, g1: CGFloat = 1.0, b1: CGFloat = 1.0, a1: CGFloat = 1.0
        var r2: CGFloat = 1.0, g2: CGFloat = 1.0, b2: CGFloat = 1.0, a2: CGFloat = 1.0
        
        self.getRed(&r1, green: &g1, blue: &b1, alpha: &a1)
        color.getRed(&r2, green: &g2, blue: &b2, alpha: &a2)
        
        return UIColor(red: r1 * (1 - fraction) + r2 * fraction,
                       green: g1 * (1 - fraction) + g2 * fraction,
                       blue: b1 * (1 - fraction) + b2 * fraction,
                       alpha: a1 * (1 - fraction) + a2 * fraction);
    }
    
    var inverted: UIColor {
        var red: CGFloat = 0.0
        var green: CGFloat = 0.0
        var blue: CGFloat = 0.0
        var alpha: CGFloat = 0.0
        
        getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        return UIColor(red: (1 - red), green: (1 - green), blue: (1 - blue), alpha: alpha)
    }
    
    class var midnightBlue: UIColor {
        return UIColor(red: 1.0/255.0, green: 25.0/255.0, blue: 147.0/255.0, alpha: 1)
    }
}

//
//  GraphCollectionViewLayoutAttributes.swift
//  CollectionViewGraphing
//
//  Created by Brian Miller on 8/18/18.
//  Copyright © 2018 Brian Miller. All rights reserved.
//

import UIKit

class GraphCollectionViewLayoutAttributes: UICollectionViewLayoutAttributes {
    var graphType: GraphLayoutType = .circle
    
    override func copy(with zone: NSZone? = nil) -> Any {
        let copy = super.copy(with: zone) as! GraphCollectionViewLayoutAttributes
        copy.graphType = self.graphType
        
        return copy
    }
    
    override func isEqual(_ object: Any?) -> Bool {
        if let rhs = object as? GraphCollectionViewLayoutAttributes {
            if rhs.graphType != graphType {
                return false
            }
            
            return super.isEqual(object)
        } else {
            return false
        }
    }
}

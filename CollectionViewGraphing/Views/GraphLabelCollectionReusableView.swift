//
//  GraphLabelCollectionReusableView.swift
//  CollectionViewGraphing
//
//  Created by Brian Miller on 7/8/18.
//  Copyright © 2018 Brian Miller. All rights reserved.
//

import UIKit

class GraphLabelCollectionReusableView: UICollectionReusableView {
    static let nibName = String(describing: GraphLabelCollectionReusableView.self)
    static let reuseIdentifier = String(describing: GraphLabelCollectionReusableView.self)
    
    @IBOutlet var textLabel: UILabel!
    
    public func configureWithText(_ text: String) {
        textLabel.text = text
    }
}

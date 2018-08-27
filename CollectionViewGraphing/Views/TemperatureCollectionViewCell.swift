//
//  TemperatureCollectionViewCell.swift
//  CollectionViewGraphing
//
//  Created by Brian Miller on 7/8/18.
//  Copyright © 2018 Brian Miller. All rights reserved.
//

import UIKit

class TemperatureCollectionViewCell: UICollectionViewCell {
    static let nibName = String(describing: TemperatureCollectionViewCell.self)
    static let reuseIdentifier = String(describing: TemperatureCollectionViewCell.self)
    
    @IBOutlet var tempLabel: UILabel!
    @IBOutlet var tempBackground: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = .clear
        tempBackground.layer.cornerRadius = 25
        tempBackground.layer.borderWidth = 2
    }
    
    public func configure(with temperature: Temperature) {
        tempLabel.text = "\(temperature.temp)°"
        tempBackground.backgroundColor = temperature.isHigh ? UIColor.red.withAlphaComponent(0.7) : UIColor.blue.withAlphaComponent(0.5)
        tempBackground.layer.borderColor = temperature.isHigh ? UIColor.red.cgColor : UIColor.blue.cgColor
    }
}

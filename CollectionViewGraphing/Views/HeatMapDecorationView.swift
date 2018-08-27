//
//  HeatMapDecorationView.swift
//  CollectionViewGraphing
//
//  Created by Brian Miller on 7/8/18.
//  Copyright © 2018 Brian Miller. All rights reserved.
//

import UIKit

class HeatMapDecorationView: UICollectionReusableView {
    let firstRingColor = UIColor(red: 0.25, green: 0.25, blue: 1, alpha: 1)
    let secondRingColor = UIColor(red: 0.25, green: 1, blue: 1, alpha: 1)
    let thirdRingColor = UIColor(red: 0.25, green: 1, blue: 0.25, alpha: 1)
    let fourthRingColor = UIColor(red: 1, green: 1, blue: 0.25, alpha: 1)
    let fifthRingColor = UIColor(red: 1, green: 0.25, blue: 0.25, alpha: 1)
    
    var graphType: GraphLayoutType = .circle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        backgroundColor = .clear
    }
    
    var gradient: CGGradient? {
        return CGGradient(colorsSpace: nil,
                          colors: [firstRingColor.cgColor,
                                   firstRingColor.blended(withFraction: 0.5, of: secondRingColor).cgColor,
                                   secondRingColor.cgColor,
                                   secondRingColor.blended(withFraction: 0.5, of: thirdRingColor).cgColor,
                                   thirdRingColor.cgColor,
                                   thirdRingColor.blended(withFraction: 0.5, of: fourthRingColor).cgColor,
                                   fourthRingColor.cgColor,
                                   fourthRingColor.blended(withFraction: 0.5, of: fifthRingColor).cgColor,
                                   fifthRingColor.cgColor] as CFArray,
                          locations: [0, 1.0/8.0, 1.0/4.0, 3.0/8.0, 1.0/2.0,
                                      5.0/8.0, 3.0/4.0, 7.0/8.0, 1] as [CGFloat])
    }
    
    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }
      
        guard let gradient = gradient else {
            context.restoreGState()
            return
        }
        
        switch graphType {
        case .circle:
            //// Oval Drawing
            let ovalRect = rect
            let ovalPath = UIBezierPath(ovalIn: ovalRect)
            context.saveGState()
            ovalPath.addClip()
            let center = CGPoint(x: rect.midX, y: rect.midY)
            let maxRadius = rect.maxY / 2.0
            context.drawRadialGradient(gradient,
                                       startCenter: center,
                                       startRadius: maxRadius * 0.1,
                                       endCenter: center,
                                       endRadius: maxRadius,
                                       options: [.drawsBeforeStartLocation, .drawsAfterEndLocation])
        case .line:
            //// Rect Drawing
            let rectPath = UIBezierPath(rect: rect)
            context.saveGState()
            rectPath.addClip()
            context.drawLinearGradient(gradient, start: CGPoint(x: 0, y: rect.maxY), end: CGPoint(x: 0, y: rect.minY), options: [])
        }
        
        context.restoreGState()
    }
    
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        
        guard let layoutAttributes = layoutAttributes as? GraphCollectionViewLayoutAttributes else { return }
        graphType = layoutAttributes.graphType
        setNeedsDisplay()
    }
    
    override func willTransition(from oldLayout: UICollectionViewLayout, to newLayout: UICollectionViewLayout) {
        UIView.animate(withDuration: 0.33, delay: 0, options: [.beginFromCurrentState, .curveEaseOut], animations: { [weak self] in
            self?.alpha = 0
        }, completion: nil)
    }
    
    override func didTransition(from oldLayout: UICollectionViewLayout, to newLayout: UICollectionViewLayout) {
        UIView.animate(withDuration: 0.33, delay: 0, options: [.beginFromCurrentState, .curveEaseIn], animations: { [weak self] in
            self?.alpha = 1
        }, completion: nil)
    }
}

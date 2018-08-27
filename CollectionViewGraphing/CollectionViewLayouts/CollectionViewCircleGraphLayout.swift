//
//  CollectionViewCircleGraphLayout.swift
//  CollectionViewGraphing
//
//  Created by Brian Miller on 8/18/18.
//  Copyright © 2018 Brian Miller. All rights reserved.
//

import UIKit

class CollectionViewCircleGraphLayout: CollectionViewGraphLayout {
    override func prepare() {
        super.prepare()
        
        if shouldFanClusters {
            fixOverlaps()
        }
    }
    
    override func prepareItemLayoutAttributes(_ collectionView: UICollectionView) -> [UICollectionViewLayoutAttributes] {
        var layoutAttributes = super.prepareItemLayoutAttributes(collectionView)
        guard let delegate = delegate as? CollectionViewDelegateCircleGraphLayout else {
            return layoutAttributes
        }
        
        let decorationViewRadius = delegate.collectionView(collectionView, layout: self, sizeForDecorationViewAt: IndexPath(item: 0, section: 0)).width / 2
        
        for sectionIndex in 0..<collectionView.numberOfSections {
            for itemIndex in 0..<collectionView.numberOfItems(inSection: sectionIndex) {
                let indexPath = IndexPath(item: itemIndex, section: sectionIndex)
                let radius = delegate.collectionView(collectionView, layout: self, radiusPercentageForItemAtIndexPath: indexPath) * decorationViewRadius
                let angle = delegate.collectionView(collectionView, layout: self, angleForItemAt: indexPath)
                
                let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                attributes.center = calculateCenter(for: radius, at: angle)
                attributes.size = delegate.collectionView(collectionView, layout: self, sizeForItemAt: indexPath)
                
                layoutAttributes.append(attributes)
            }
        }
        
        return layoutAttributes
    }
    
    override func prepareSupplementaryLayoutAttributes(_ collectionView: UICollectionView) -> [UICollectionViewLayoutAttributes] {
        var layoutAttributes = super.prepareSupplementaryLayoutAttributes(collectionView)
        guard let delegate = delegate as? CollectionViewDelegateCircleGraphLayout else {
            return layoutAttributes
        }
        
        let decorationViewRadius = delegate.collectionView(collectionView, layout: self, sizeForDecorationViewAt: IndexPath(item: 0, section: 0)).width / 2
        
        for labelIndex in 0..<delegate.numberOfLabels(in: collectionView) {
            let indexPath = IndexPath(item: labelIndex, section: 0)
            let radius = delegate.collectionView(collectionView, layout: self, radiusPercentageForLabelAt: indexPath) * decorationViewRadius
            let angle = delegate.collectionView(collectionView, layout: self, angleForLabelAt: indexPath)
            
            let attributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: CollectionViewGraphLayout.labelKind, with: indexPath)
            attributes.center = calculateCenter(for: radius, at: angle)
            attributes.size = delegate.collectionView(collectionView, layout: self, sizeForLabelAt: indexPath)
            
            layoutAttributes.append(attributes)
        }
        
        return layoutAttributes
    }
    
    override func prepareDecorationLayoutAttributes() -> [UICollectionViewLayoutAttributes] {
        guard let collectionView = collectionView,
            let delegate = delegate as? CollectionViewDelegateCircleGraphLayout else { return [] }
        
        let indexPath = IndexPath(item: 0, section: 0)
        
        let attributes = GraphCollectionViewLayoutAttributes(forDecorationViewOfKind: CollectionViewGraphLayout.graphKind, with: indexPath)
        attributes.center = collectionViewCenter
        attributes.size = delegate.collectionView(collectionView, layout: self, sizeForDecorationViewAt: indexPath)
        attributes.zIndex = -1
        attributes.graphType = .circle
        
        return [attributes]
    }
    
    // MARK: Center
    fileprivate func calculateCenter(for radius: CGFloat, at angle: Measurement<UnitAngle>) -> CGPoint {
        return CGPoint(x: collectionViewCenter.x + (radius * CGFloat(cos(angle.converted(to: UnitAngle.radians).value))).roundToHalf(),
                       y: collectionViewCenter.y + (radius * CGFloat(sin(angle.converted(to: UnitAngle.radians).value))).roundToHalf())
    }
    
    // MARK: Fanning
    var shouldFanClusters: Bool {
        guard let collectionView = collectionView,
            let delegate = delegate as? CollectionViewDelegateCircleGraphLayout else { return false }
        return delegate.collectionViewShouldFanClusters(collectionView, layout: self)
    }
}

// MARK: - Overlap Handling
extension CollectionViewCircleGraphLayout {
    struct OverlapGroupHelper {
        let collectionView: UICollectionView
        let groupAngle: Measurement<UnitAngle>
        let groupRadius: CGFloat
        let angleOffset: CGFloat
        let shouldAdjustZIndex: Bool
        
        fileprivate var collectionViewCenter: CGPoint {
            return CGPoint(x: collectionView.bounds.width / 2, y: collectionView.bounds.height / 2)
        }
        
        func calculateCenter(angle: CGFloat) -> CGPoint {
            let measurement = Measurement(value: Double(angle), unit: UnitAngle.degrees)
            return CGPoint(x: collectionViewCenter.x + (groupRadius * CGFloat(cos(measurement.converted(to: UnitAngle.radians).value))).roundToHalf(),
                           y: collectionViewCenter.y + (groupRadius * CGFloat(sin(measurement.converted(to: UnitAngle.radians).value))).roundToHalf())
        }
        
        func startingAngle(groupCount: Int) -> CGFloat {
            return CGFloat(groupAngle.value) - ((angleOffset * CGFloat(groupCount - 1)) / 2.0)
        }
    }
    
    private func fixOverlaps() {
        let overlapDictionary = Dictionary(grouping: itemLayoutAttributes, by: { $0.center }).filter({ $0.value.count > 1})
        
        overlapDictionary.forEach({ fixOverlapGroup($0.value) })
    }
    
    private func fixOverlapGroup(_ overlapGroup: [UICollectionViewLayoutAttributes]) {
        guard let collectionView = collectionView, overlapGroup.count > 0,
            let overlapGroupHelper = generateOverlapGroupHelper(for: overlapGroup, collectionView: collectionView) else { return }
        
        var angle = overlapGroupHelper.startingAngle(groupCount: overlapGroup.count)
        var zIndex = 0
        var iterator = 0
        
        overlapGroup.forEach { (attributes) in
            attributes.center = overlapGroupHelper.calculateCenter(angle: angle)
            attributes.zIndex = zIndex
            angle += overlapGroupHelper.angleOffset
            
            if overlapGroupHelper.shouldAdjustZIndex {
                iterator += 1
                //   -            -
                //  - -     or   - -
                // -   -        -
                zIndex = iterator <= overlapGroup.count / 2 ? zIndex + 1 : zIndex - 1
            }
        }
    }
    
    private func generateOverlapGroupHelper(for overlapGroup: [UICollectionViewLayoutAttributes], collectionView: UICollectionView) -> OverlapGroupHelper? {
        guard let delegate = delegate as? CollectionViewDelegateCircleGraphLayout else {
            return nil
        }
        
        let groupAngle = delegate.collectionView(collectionView, layout: self, angleForItemAt: overlapGroup[0].indexPath)
        let radiusPercentage = delegate.collectionView(collectionView, layout: self, radiusPercentageForItemAtIndexPath: overlapGroup[0].indexPath)
        let graphSize = delegate.collectionView(collectionView, layout: self, sizeForDecorationViewAt: IndexPath(item: 0, section: 0))
        let groupRadius = radiusPercentage * graphSize.width
        let itemSize = delegate.collectionView(collectionView, layout: self, sizeForItemAt: overlapGroup[0].indexPath)
        
        let lengthOfArc = 2 * CGFloat.pi * groupRadius
        let requestedDistance = itemSize.width * CGFloat(overlapGroup.count)
        let availableDistance = lengthOfArc / 8
        
        let distance = CGFloat.minimum(requestedDistance, availableDistance)
        let degreeMultiplier = lengthOfArc / 360
        let angleOffset = (distance / degreeMultiplier) / CGFloat(overlapGroup.count)
        let shouldAdjustZIndex = delegate.collectionViewShouldAdjustZIndexForFannedClusters(collectionView, layout: self)
        
        return OverlapGroupHelper(collectionView: collectionView, groupAngle: groupAngle, groupRadius: groupRadius, angleOffset: angleOffset, shouldAdjustZIndex: shouldAdjustZIndex)
    }
}

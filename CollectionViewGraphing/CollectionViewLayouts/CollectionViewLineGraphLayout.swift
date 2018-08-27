//
//  CollectionViewLineGraphLayout.swift
//  CollectionViewGraphing
//
//  Created by Brian Miller on 8/18/18.
//  Copyright © 2018 Brian Miller. All rights reserved.
//

import UIKit

class CollectionViewLineGraphLayout: CollectionViewGraphLayout {
    override func prepareItemLayoutAttributes(_ collectionView: UICollectionView) -> [UICollectionViewLayoutAttributes] {
        var layoutAttributes = super.prepareItemLayoutAttributes(collectionView)
        guard let delegate = delegate as? CollectionViewDelegateLineGraphLayout else {
            return layoutAttributes
        }
        
        let decorationViewSize = delegate.collectionView(collectionView, layout: self, sizeForDecorationViewAt: IndexPath(item: 0, section: 0))
        let decorationViewRect = rectForDevorationView(with: decorationViewSize)
        let numberOfDivisions: CGFloat = CGFloat(delegate.numberOfLabels(in: collectionView)) - 1
        let spacing = numberOfDivisions > 0 ? decorationViewSize.width / numberOfDivisions : 0
        
        for sectionIndex in 0..<collectionView.numberOfSections {
            for itemIndex in 0..<collectionView.numberOfItems(inSection: sectionIndex) {
                let indexPath = IndexPath(item: itemIndex, section: sectionIndex)
                let percentageValue = delegate.collectionView(collectionView, layout: self, percentageValueForItemAtIndexPath: indexPath)
                let spacingIndex = delegate.collectionView(collectionView, layout: self, spacingIndexForItemAt: indexPath)
                let center = CGPoint(x: decorationViewRect.origin.x + (spacing * CGFloat(spacingIndex)),
                                     y: decorationViewRect.maxY - (decorationViewSize.height * percentageValue))
                
                let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                attributes.center = center
                attributes.size = delegate.collectionView(collectionView, layout: self, sizeForItemAt: indexPath)
                
                layoutAttributes.append(attributes)
            }
        }
        
        return layoutAttributes
    }
    
    override func prepareSupplementaryLayoutAttributes(_ collectionView: UICollectionView) -> [UICollectionViewLayoutAttributes] {
        var layoutAttributes = super.prepareSupplementaryLayoutAttributes(collectionView)
        guard let delegate = delegate as? CollectionViewDelegateLineGraphLayout else {
            return layoutAttributes
        }
        
        let decorationViewSize = delegate.collectionView(collectionView, layout: self, sizeForDecorationViewAt: IndexPath(item: 0, section: 0))
        let decorationViewRect = rectForDevorationView(with: decorationViewSize)
        let numberOfDivisions = CGFloat(delegate.numberOfLabels(in: collectionView)) - 1
        let spacing = numberOfDivisions > 0 ? decorationViewSize.width / numberOfDivisions : 0
        let verticalSpacing: CGFloat = 8
        
        for labelIndex in 0..<delegate.numberOfLabels(in: collectionView) {
            let indexPath = IndexPath(item: labelIndex, section: 0)
            let size = delegate.collectionView(collectionView, layout: self, sizeForLabelAt: indexPath)
            let center = CGPoint(x: decorationViewRect.minX + (spacing * CGFloat(indexPath.item)),
                                 y: decorationViewRect.maxY + (size.height / 2) + verticalSpacing)
            
            let attributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: CollectionViewGraphLayout.labelKind, with: indexPath)
            attributes.center = center
            attributes.size = size
            
            layoutAttributes.append(attributes)
        }
        
        return layoutAttributes
    }
    
    override func prepareDecorationLayoutAttributes() -> [UICollectionViewLayoutAttributes] {
        guard let collectionView = collectionView,
            let delegate = delegate as? CollectionViewDelegateLineGraphLayout else { return [] }
        
        let indexPath = IndexPath(item: 0, section: 0)
        let attributes = GraphCollectionViewLayoutAttributes(forDecorationViewOfKind: CollectionViewGraphLayout.graphKind, with: indexPath)
        
        attributes.center = collectionViewCenter
        attributes.size = delegate.collectionView(collectionView, layout: self, sizeForDecorationViewAt: indexPath)
        attributes.zIndex = -1
        attributes.graphType = .line
        
        return [attributes]
    }
}

extension CollectionViewLineGraphLayout {
    fileprivate func rectForDevorationView(with decorationViewSize: CGSize) -> CGRect {
        let graphCenter = collectionViewCenter
        return CGRect(x: graphCenter.x - (decorationViewSize.width / 2), y: graphCenter.y - (decorationViewSize.height / 2), width: decorationViewSize.width, height: decorationViewSize.height)
    }
}

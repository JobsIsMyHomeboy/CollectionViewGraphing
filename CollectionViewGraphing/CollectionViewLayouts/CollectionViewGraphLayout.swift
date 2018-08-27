//
//  CollectionViewGraphLayout.swift
//  CollectionViewGraphing
//
//  Created by Brian Miller on 8/18/18.
//  Copyright © 2018 Brian Miller. All rights reserved.
//

import UIKit

class CollectionViewGraphLayout: UICollectionViewLayout {
    static let graphKind = "DecorationGraphKind"
    static let labelKind = "LabelGraphKind"
    
    var itemLayoutAttributes: [UICollectionViewLayoutAttributes] = []
    var oldItemLayoutAttributes: [UICollectionViewLayoutAttributes] = []
    
    var decorationLayoutAttributes: [UICollectionViewLayoutAttributes] = []
    var oldDecorationLayoutAttributes: [UICollectionViewLayoutAttributes] = []
    
    var supplementaryLayoutAttributes: [UICollectionViewLayoutAttributes] = []
    var oldSupplementaryLayoutAttributes: [UICollectionViewLayoutAttributes] = []
    
    weak var delegate: CollectionViewDelegateGraphLayout?
    private weak var otherLayout: CollectionViewGraphLayout?
    
    var collectionViewCenter: CGPoint {
        guard let collectionView = collectionView else { return .zero }
        return CGPoint(x: collectionView.bounds.midX, y: collectionView.bounds.midY)
    }
    
    override open class var layoutAttributesClass: AnyClass {
        return GraphCollectionViewLayoutAttributes.self
    }
    
    override open var collectionViewContentSize: CGSize {
        return collectionView?.frame.size ?? CGSize(width: 0, height: 0)
    }
    
    override open func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    override open func prepare() {
        super.prepare()
        
        cacheAndClearAttributes()
        
        guard let collectionView = collectionView else { return }
        
        itemLayoutAttributes = prepareItemLayoutAttributes(collectionView)
        supplementaryLayoutAttributes = prepareSupplementaryLayoutAttributes(collectionView)
        decorationLayoutAttributes = prepareDecorationLayoutAttributes()
    }
    
    // MARK: All Layout Attributes
    override open func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let itemLayoutAttributesInRect = itemLayoutAttributes.filter({ (attributes) in attributes.frame.intersects(rect) })
        let decorationLayoutAttributesInRect = decorationLayoutAttributes.filter({ (attributes) in attributes.frame.intersects(rect) })
        let supplementaryLayoutAttributesInRect = supplementaryLayoutAttributes.filter({ (attributes) in attributes.frame.intersects(rect) })
        
        return itemLayoutAttributesInRect + decorationLayoutAttributesInRect + supplementaryLayoutAttributesInRect
    }
    
    // MARK: Preparation Helpers
    func prepareItemLayoutAttributes(_ collectionView: UICollectionView) -> [UICollectionViewLayoutAttributes] {
        return []
    }
    
    func prepareSupplementaryLayoutAttributes(_ collectionView: UICollectionView) -> [UICollectionViewLayoutAttributes] {
        return []
    }
    
    func prepareDecorationLayoutAttributes() -> [UICollectionViewLayoutAttributes] {
        return []
    }
}

// MARK: - Transition Handling
extension CollectionViewGraphLayout {
    override open func prepareForTransition(from oldLayout: UICollectionViewLayout) {
        if let layout = oldLayout as? CollectionViewGraphLayout {
            otherLayout = layout
        }
        
        super.prepareForTransition(from: oldLayout)
    }
    
    override open func finalizeLayoutTransition() {
        otherLayout = nil
        
        super.finalizeLayoutTransition()
    }
}

// MARK: - Item Layout
extension CollectionViewGraphLayout {
    override open func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return itemLayoutAttributes.filter({ $0.indexPath == indexPath }).first
    }
    
    override open func initialLayoutAttributesForAppearingItem(at itemIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard let collectionView = collectionView,
            let delegate = delegate else { return nil }
        
        // Transitioning
        if let layout = otherLayout {
            if let oldAttributes = layout.oldItemLayoutAttributes.filter({ $0.indexPath == itemIndexPath }).first {
                oldAttributes.alpha = 0
                return oldAttributes
            }
        }
        
        // If Item already exists return current attributes
        if let oldAttributes = oldItemLayoutAttributes.filter({ $0.indexPath == itemIndexPath }).first {
            oldAttributes.alpha = 0
            return oldAttributes
        }
        
        // Return attributes placed at center of graph
        let attributes = UICollectionViewLayoutAttributes(forCellWith: itemIndexPath)
        attributes.center = collectionViewCenter
        attributes.size = delegate.collectionView(collectionView, layout: self, sizeForItemAt: itemIndexPath)
        
        return attributes
    }
    
    override open func finalLayoutAttributesForDisappearingItem(at itemIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard let collectionView = collectionView,
            let delegate = delegate else { return nil }
        
        // If New Item already exists return new attributes
        if let newAttributes = itemLayoutAttributes.filter({ $0.indexPath == itemIndexPath }).first {
            newAttributes.alpha = 0
            return newAttributes
        }
        
        // Return attributes placed at center of graph
        let attributes = UICollectionViewLayoutAttributes(forCellWith: itemIndexPath)
        attributes.center = collectionViewCenter
        attributes.size = delegate.collectionView(collectionView, layout: self, sizeForItemAt: itemIndexPath)
        
        return attributes
    }
}

// MARK: - Supplementary View Layout
extension CollectionViewGraphLayout {
    override open func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        if elementKind == CollectionViewGraphLayout.labelKind {
            return supplementaryLayoutAttributes.filter({ $0.indexPath == indexPath }).first
        }
        
        return nil
    }
    
    override open func initialLayoutAttributesForAppearingSupplementaryElement(ofKind elementKind: String, at elementIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        // Transitioning
        if let layout = otherLayout {
            if let oldAttributes = layout.oldSupplementaryLayoutAttributes.filter({ $0.indexPath == elementIndexPath }).first {
                oldAttributes.alpha = 0
                return oldAttributes
            }
        }
        
        if let oldAttributes = oldSupplementaryLayoutAttributes.filter({ $0.indexPath == elementIndexPath }).first {
            oldAttributes.alpha = 0
            return oldAttributes
        }
        
        return nil
    }
    
    open override func finalLayoutAttributesForDisappearingSupplementaryElement(ofKind elementKind: String, at elementIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        if let layout = otherLayout {
            if let oldAttributes = layout.supplementaryLayoutAttributes.filter({ $0.indexPath == elementIndexPath }).first {
                oldAttributes.alpha = 0
                return oldAttributes
            }
        }
        
        if let oldAttributes = supplementaryLayoutAttributes.filter({ $0.indexPath == elementIndexPath }).first {
            return oldAttributes
        }
        
        return nil
    }
}

// MARK: - Decoration View Layout
extension CollectionViewGraphLayout {
    override open func layoutAttributesForDecorationView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        if elementKind == CollectionViewGraphLayout.graphKind {
            return decorationLayoutAttributes.filter({ $0.indexPath == indexPath }).first
        }
        
        return nil
    }
    
    override open func initialLayoutAttributesForAppearingDecorationElement(ofKind elementKind: String, at decorationIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        if let oldAttributes = oldDecorationLayoutAttributes.filter({ $0.indexPath == decorationIndexPath }).first {
            return oldAttributes
        }
        
        return nil
    }
}

// MARK: - Helpers
extension CollectionViewGraphLayout {
    private func cacheAndClearAttributes() {
        oldItemLayoutAttributes = itemLayoutAttributes
        itemLayoutAttributes.removeAll()
        
        oldDecorationLayoutAttributes = decorationLayoutAttributes
        decorationLayoutAttributes.removeAll()
        
        oldSupplementaryLayoutAttributes = supplementaryLayoutAttributes
        supplementaryLayoutAttributes.removeAll()
    }
}

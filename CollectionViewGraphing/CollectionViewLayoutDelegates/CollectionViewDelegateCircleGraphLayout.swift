//
//  CollectionViewDelegateCircleGraphLayout.swift
//  CollectionViewGraphing
//
//  Created by Brian Miller on 7/7/18.
//  Copyright © 2018 Brian Miller. All rights reserved.
//

import UIKit

protocol CollectionViewDelegateCircleGraphLayout: CollectionViewDelegateGraphLayout {
    // Item
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, angleForItemAt indexPath: IndexPath) -> Measurement<UnitAngle>
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, radiusPercentageForItemAtIndexPath indexPath: IndexPath) -> CGFloat
    func collectionViewShouldFanClusters(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout) -> Bool
    func collectionViewShouldAdjustZIndexForFannedClusters(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout) -> Bool
    
    // Labels (Supplementary Views)
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, angleForLabelAt indexPath: IndexPath) -> Measurement<UnitAngle>
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, radiusPercentageForLabelAt indexPath: IndexPath) -> CGFloat
}

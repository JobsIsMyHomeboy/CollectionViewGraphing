//
//  CollectionViewDelegateLineGraphLayout.swift
//  CollectionViewGraphing
//
//  Created by Brian Miller on 8/1/18.
//  Copyright © 2018 Brian Miller. All rights reserved.
//

import UIKit

protocol CollectionViewDelegateLineGraphLayout: CollectionViewDelegateGraphLayout {
    // Item
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, spacingIndexForItemAt indexPath: IndexPath) -> Int
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, percentageValueForItemAtIndexPath indexPath: IndexPath) -> CGFloat
}

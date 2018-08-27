//
//  CollectionViewDelegateGraphLayout.swift
//  CollectionViewGraphing
//
//  Created by Brian Miller on 8/18/18.
//  Copyright © 2018 Brian Miller. All rights reserved.
//

import UIKit

protocol CollectionViewDelegateGraphLayout: UICollectionViewDelegate {
    // Item
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    
    // Labels (Supplementary Views)
    func numberOfLabels(in collectionView: UICollectionView) -> Int
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForLabelAt indexPath: IndexPath) -> CGSize
    
    // Graph (Decoration View)
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForDecorationViewAt indexPath: IndexPath) -> CGSize
}

//
//  StickyExpandableFlowLayout.swift
//  Roomguru
//
//  Created by Patryk Kaczmarek on 16/04/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import UIKit

class StickyExpandableFlowLayout: UICollectionViewFlowLayout {
    
    override init() {
        super.init()
        sectionInset = UIEdgeInsetsZero
        minimumLineSpacing = 0
        minimumInteritemSpacing = 0
        headerReferenceSize = CGSizeMake(0, 160.0)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
        return true
    }
    
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [AnyObject]? {
        
        let superAttributes = super.layoutAttributesForElementsInRect(rect) as! [UICollectionViewLayoutAttributes]
        
        if let collectionView = self.collectionView {
            
            let offsetY = Float(collectionView.contentOffset.y)
            let minY = Float(-collectionView.contentInset.top)
            
            if offsetY >= minY {
                return superAttributes
            }
            
            let deltaY = fabsf(offsetY - minY)
            
            let headerElements = superAttributes.filter {
                if let elemedKind = $0.representedElementKind {
                    return elemedKind == UICollectionElementKindSectionHeader
                }
                return false
            }
            
            for (_, element) in enumerate(headerElements) {
                
                var headerRect = element.frame
                headerRect.size.height = CGFloat(max(minY, Float(self.headerReferenceSize.height) + deltaY))
                headerRect.origin.y = CGFloat(Float(headerRect.origin.y) - deltaY);
                element.frame = headerRect
                break
            }
        }
        return superAttributes
    }
}

//
//  OCTBaseCollectionViewLayout.swift
//  OCTCustomCollectionViewLayout
//
//  Created by dmitry.brovkin on 4/3/17.
//  Copyright © 2017 dmitry.brovkin. All rights reserved.
//

import UIKit

class OCTBaseCollectionViewLayout: UICollectionViewLayout {
    private var layoutMap = [IndexPath : UICollectionViewLayoutAttributes]()
    private var contentSize: CGSize!
    
    private(set) var totalItemsInSection = 0
    
    //MARK: getters
    var sectionInsets: UIEdgeInsets {
        return UIEdgeInsets.zero
    }
    
    override var collectionViewContentSize: CGSize {
        return self.contentSize
    }
    
    //MARK: Override methods
    override func prepare() {
        layoutMap.removeAll()
        self.totalItemsInSection = self.collectionView!.numberOfItems(inSection: 0)
        
        if self.totalItemsInSection > 0 {
            self.calculateItemsSize()
            
            var itemIndex = 0
            var contentSizeHeight: CGFloat = 0
            
            while itemIndex < self.totalItemsInSection {
                let targetIndexPath = IndexPath(item: itemIndex, section: 0)
                let attributeRect = self.calculateItemFrame(targetIndexPath)
                let targetLayoutAttributes = UICollectionViewLayoutAttributes.init(forCellWith: targetIndexPath)
                targetLayoutAttributes.frame = attributeRect
                
                if attributeRect.maxY > contentSizeHeight {
                    contentSizeHeight = attributeRect.maxY
                }
                
                layoutMap[targetIndexPath] = targetLayoutAttributes
                itemIndex += 1
            }
            
            
            self.contentSize = CGSize(width: self.collectionView!.bounds.width,
                                      height: contentSizeHeight + sectionInsets.bottom)
        }
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var layoutAttributesArray = [UICollectionViewLayoutAttributes]()
        
        for (_, layoutAttributes) in self.layoutMap {
            if rect.intersects(layoutAttributes.frame) {
                layoutAttributesArray.append(layoutAttributes)
            }
        }
        
        return layoutAttributesArray
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return self.layoutMap[indexPath]
    }
    
    //MARK: Methods that should be overridden by inheritor
    func calculateItemFrame(_ indexPath: IndexPath) -> CGRect {
        return CGRect.zero
    }
    
    func calculateItemsSize() {}
}

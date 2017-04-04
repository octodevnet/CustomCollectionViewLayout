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
    private var columnsOffsetY: [CGFloat]!
    private var contentSize: CGSize!
    
    private(set) var totalItemsInSection = 0
    
    var totalColumns = 0
    var interItemsSpacing: CGFloat = 5
    
    //MARK: getters
    var contentInsets: UIEdgeInsets {
        return collectionView!.contentInset
    }
    
    override var collectionViewContentSize: CGSize {
        return contentSize
    }
    
    //MARK: Override methods
    override func prepare() {
        layoutMap.removeAll()
        columnsOffsetY = Array(repeating: contentInsets.top, count: totalColumns)

        self.totalItemsInSection = collectionView!.numberOfItems(inSection: 0)
        
        if totalItemsInSection > 0 && totalColumns > 0 {
            self.calculateItemsSize()
            
            var itemIndex = 0
            var contentSizeHeight: CGFloat = 0
            
            while itemIndex < totalItemsInSection {
                let indexPath = IndexPath(item: itemIndex, section: 0)
                let columnIndex = self.columnIndexForItemAt(indexPath: indexPath)

                let attributeRect = calculateItemFrame(indexPath: indexPath, columnIndex: columnIndex, columnOffsetY: columnsOffsetY[columnIndex])
                let targetLayoutAttributes = UICollectionViewLayoutAttributes.init(forCellWith: indexPath)
                targetLayoutAttributes.frame = attributeRect
                
                contentSizeHeight = max(attributeRect.maxY, contentSizeHeight)
                columnsOffsetY[columnIndex] = attributeRect.maxY + interItemsSpacing
                layoutMap[indexPath] = targetLayoutAttributes
                
                itemIndex += 1
            }
            
            
            contentSize = CGSize(width: collectionView!.bounds.width,
                                 height: contentSizeHeight + contentInsets.bottom)
        }
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var layoutAttributesArray = [UICollectionViewLayoutAttributes]()
        
        for (_, layoutAttributes) in layoutMap {
            if rect.intersects(layoutAttributes.frame) {
                layoutAttributesArray.append(layoutAttributes)
            }
        }
        
        return layoutAttributesArray
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return layoutMap[indexPath]
    }
    
    //MARK: Abstract methods
    func columnIndexForItemAt(indexPath: IndexPath) -> Int {
        return indexPath.item % totalColumns
    }
    func calculateItemFrame(indexPath: IndexPath, columnIndex: Int, columnOffsetY: CGFloat) -> CGRect {
        return CGRect.zero
    }
    
    func calculateItemsSize() {}
}

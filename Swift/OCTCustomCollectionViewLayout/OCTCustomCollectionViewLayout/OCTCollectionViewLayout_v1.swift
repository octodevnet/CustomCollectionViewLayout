//
//  OCTCollectionViewLayout_v1.swift
//  OCTCustomCollectionViewLayout
//
//  Created by dmitry.brovkin on 3/31/17.
//  Copyright © 2017 dmitry.brovkin. All rights reserved.
//

import UIKit

private let kInterItemsSpacing: CGFloat = 5
private let kNumberOfColums = 3
private let kReducedHeightColunmIndex = 1
private let kItemHeightAspect: CGFloat  = 2
private let kSectionInsets = UIEdgeInsetsMake(10, 10, 10, 10)


class OCTCollectionViewLayout_v1: UICollectionViewLayout {
    private var layoutMap = [IndexPath : UICollectionViewLayoutAttributes]()
    private var itemSize: CGSize!
    private var contentSize: CGSize!
    
    private var totalItemsInSection = 0
    
    //MARK: getters
    override var collectionViewContentSize: CGSize {
        return self.contentSize
    }
    
    //MARK: Override methods
    override func prepare() {
        assert(kReducedHeightColunmIndex < kNumberOfColums, "kReducedHeightColunmIndex should be lower than kNumberOfColums value")
        
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
                                      height: contentSizeHeight + kSectionInsets.bottom)
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
    
    //MARK: Private methods
    private func calculateItemFrame(_ indexPath: IndexPath) -> CGRect {
        let columnIndex = indexPath.item % kNumberOfColums
        let rowIndex = indexPath.item / kNumberOfColums
        let isLastItemSingleInRow = indexPath.item == (self.totalItemsInSection - 1) && columnIndex == 0
        let halfItemHeight = (self.itemSize.height - kInterItemsSpacing) / 2
        let resolvedColumnIndex = isLastItemSingleInRow ? kReducedHeightColunmIndex : columnIndex
        
        //Calculating Point
        let offsetX = CGFloat(resolvedColumnIndex) * self.itemSize.width + CGFloat(resolvedColumnIndex) * kInterItemsSpacing
        let pointX = kSectionInsets.left + offsetX
        
        let offsetY = CGFloat(rowIndex) * self.itemSize.height + CGFloat(rowIndex) * kInterItemsSpacing
        var pointY = kSectionInsets.top + offsetY
        
        // By our logic, first and last items in reduced height column have height devided by 2.
        // So we need to adjust appropriately all further cell's pointY
        if rowIndex > 0 && resolvedColumnIndex == kReducedHeightColunmIndex {
            pointY -= halfItemHeight + kInterItemsSpacing
        }
        let point = CGPoint(x: pointX, y: pointY)
        
        //Calculating Size
        var itemHeigh = self.itemSize.height
        
        if (rowIndex == 0 && resolvedColumnIndex == kReducedHeightColunmIndex) || isLastItemSingleInRow {
            itemHeigh = halfItemHeight
        }
        let size = CGSize(width: self.itemSize.width, height: itemHeigh)
        
        return CGRect(origin: point, size: size)
    }
    
    private func calculateItemsSize() {
        let contentWidthWithoutIndents = self.collectionView!.bounds.width - kSectionInsets.left - kSectionInsets.right
        let floatNumberOfColums = CGFloat(kNumberOfColums)
        let itemWidth = (contentWidthWithoutIndents - (floatNumberOfColums - 1) * kInterItemsSpacing) / floatNumberOfColums
        let itemHeight = itemWidth * kItemHeightAspect
        
        self.itemSize = CGSize(width: itemWidth, height: itemHeight)
    }
}


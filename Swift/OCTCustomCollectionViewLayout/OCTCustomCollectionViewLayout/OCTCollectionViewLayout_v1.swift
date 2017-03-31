//
//  OCTCollectionViewLayout_v1.swift
//  OCTCustomCollectionViewLayout
//
//  Created by dmitry.brovkin on 3/31/17.
//  Copyright © 2017 dmitry.brovkin. All rights reserved.
//

import UIKit

private var kInterItemsSpacing: CGFloat = 5
private let kNumberOfColums = 3;
private let kReducedHeightColunmIndex = 1;
private let kItemHeightAspect: CGFloat  = 3;


class OCTCollectionViewLayout_v1: UICollectionViewLayout {
    private var layoutMap = [IndexPath : UICollectionViewLayoutAttributes]()
    private var itemSize = CGSize()
    private var contentSize = CGSize()
    private var sectionInsets = UIEdgeInsetsMake(0, 0, 0, 0)
    
    private var lastRowIndex = 0
    
    //MARK: getters
    override var collectionViewContentSize: CGSize {
        return self.contentSize
    }
    
    //MARK: Override methods
    override func prepare() {
        assert(kReducedHeightColunmIndex < kNumberOfColums, "kReducedHeightColunmIndex should be lower than kNumberOfColums value")
        
        layoutMap.removeAll()
        let itemsInSection = self.collectionView!.numberOfItems(inSection: 0)
        
        if itemsInSection > 0 {
            self.calculateItemsSize()

            self.lastRowIndex = (itemsInSection - 1) / kNumberOfColums
            var itemIndex = 0
            var contentSizeHeight: CGFloat = 0
            
            while itemIndex < itemsInSection {
                let targetIndexPath = IndexPath(item: itemIndex, section: 0)
                let targetLayoutAttributes = UICollectionViewLayoutAttributes.init(forCellWith: targetIndexPath)
                let attributeRect = self.calculateItemFrame(targetIndexPath)
                targetLayoutAttributes.frame = attributeRect
                
                if attributeRect.maxY > contentSizeHeight {
                    contentSizeHeight = attributeRect.maxY
                }
                
                itemIndex += 1
                
                layoutMap[targetIndexPath] = targetLayoutAttributes
            }
            
            
            self.contentSize = CGSize(width: self.itemSize.width,
                                      height: contentSizeHeight)
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
        let collumIndex = indexPath.item % kNumberOfColums
        let rowIndex = indexPath.item / kNumberOfColums
        
        //Calculating Point
        let offsetX = CGFloat(collumIndex) * self.itemSize.width + CGFloat(collumIndex) * kInterItemsSpacing
        let pointX = self.sectionInsets.left + offsetX
        
        let offsetY = CGFloat(rowIndex) * self.itemSize.height + CGFloat(rowIndex) * kInterItemsSpacing
        var pointY = self.sectionInsets.top + offsetY
        
        // By our logic, first item in reduced height column has height devided by 2.
        // So we need to adjust appropriately all further cell's pointY
        if rowIndex > 0 && collumIndex == kReducedHeightColunmIndex {
            pointY -= self.itemSize.height / 2
        }
        let point = CGPoint(x: pointX, y: pointY)
        
        //Calculating Size
        var itemHeigh = self.itemSize.height
        
        if rowIndex == 0 &&
            rowIndex == self.lastRowIndex &&
            collumIndex == kReducedHeightColunmIndex
        {
            itemHeigh = self.itemSize.height / 2
        }
        let size = CGSize(width: self.itemSize.width, height: itemHeigh)
        
        return CGRect(origin: point, size: size)
    }
    
    private func calculateItemsSize() {
        let contentWidthWithoutIndents = self.collectionView!.bounds.width - self.sectionInsets.left - self.sectionInsets.right
        let floatNumberOfColums = CGFloat(kNumberOfColums)
        let itemWidth = (contentWidthWithoutIndents - (floatNumberOfColums - 1) * floatNumberOfColums) / floatNumberOfColums
        let itemHeight = itemWidth * kItemHeightAspect
        
        self.itemSize = CGSize(width: itemWidth, height: itemHeight)
    }
}


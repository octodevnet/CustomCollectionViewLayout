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


class OCTCollectionViewLayout_v1: OCTBaseCollectionViewLayout {
    private var itemSize: CGSize!

    override var description: String {
        return "Layout v1"
    }
    
    override func calculateItemFrame(_ indexPath: IndexPath) -> CGRect {
        let columnIndex = indexPath.item % kNumberOfColums
        let rowIndex = indexPath.item / kNumberOfColums
        let isLastItemSingleInRow = indexPath.item == (self.totalItemsInSection - 1) && columnIndex == 0
        let halfItemHeight = (self.itemSize.height - kInterItemsSpacing) / 2
        let resolvedColumnIndex = isLastItemSingleInRow ? kReducedHeightColunmIndex : columnIndex
        
        //Calculating Point
        let offsetX = self.sectionInsets.left + CGFloat(resolvedColumnIndex) * self.itemSize.width + CGFloat(resolvedColumnIndex) * kInterItemsSpacing
        var offsetY = self.sectionInsets.top + CGFloat(rowIndex) * self.itemSize.height + CGFloat(rowIndex) * kInterItemsSpacing
        
        // By our logic, first and last items in reduced height column have height devided by 2.
        // So we need to adjust appropriately all further cell's pointY
        if rowIndex > 0 && resolvedColumnIndex == kReducedHeightColunmIndex {
            offsetY -= halfItemHeight + kInterItemsSpacing
        }
        let point = CGPoint(x: offsetX, y: offsetY)
        
        //Calculating Size
        var itemHeigh = self.itemSize.height
        
        if (rowIndex == 0 && resolvedColumnIndex == kReducedHeightColunmIndex) || isLastItemSingleInRow {
            itemHeigh = halfItemHeight
        }
        let size = CGSize(width: self.itemSize.width, height: itemHeigh)
        
        return CGRect(origin: point, size: size)
    }
    
    override func calculateItemsSize() {
        let contentWidthWithoutIndents = self.collectionView!.bounds.width - self.sectionInsets.left - self.sectionInsets.right
        let floatNumberOfColums = CGFloat(kNumberOfColums)
        let itemWidth = (contentWidthWithoutIndents - (floatNumberOfColums - 1) * kInterItemsSpacing) / floatNumberOfColums
        let itemHeight = itemWidth * kItemHeightAspect
        
        self.itemSize = CGSize(width: itemWidth, height: itemHeight)
    }
}


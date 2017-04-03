//
//  OCTCollectionViewLayout_v2.swift
//  OCTCustomCollectionViewLayout
//
//  Created by dmitry.brovkin on 4/3/17.
//  Copyright © 2017 dmitry.brovkin. All rights reserved.
//

import UIKit

private let kInterItemsSpacing: CGFloat = 5
private let kSideItemWidthCoef: CGFloat = 0.3
private let kSideItemHeightAspect: CGFloat = 1
private let kNumberOfSideItems = 3

private enum ColumnType: Int {
    case main = 0
    case side = 1
}

class OCTCollectionViewLayout_v2: OCTBaseCollectionViewLayout {
    private var mainItemSize: CGSize!
    private var sideItemSize: CGSize!
    
    override var description: String {
        return "Layout v2"
    }
    
    override func calculateItemFrame(_ indexPath: IndexPath) -> CGRect {
        let totalItemsInRow = kNumberOfSideItems + 1
        let columnTypeRawValue = indexPath.item % totalItemsInRow
        let columnType = ColumnType(rawValue: columnTypeRawValue > 1 ? 1 : columnTypeRawValue)
        let mainRowIndex = indexPath.item / totalItemsInRow
        let foatMainRowIndex = CGFloat(mainRowIndex)

        // By default, we assign params for main item
        var offsetX: CGFloat = self.sectionInsets.left
        var offsetY: CGFloat = self.sectionInsets.top + (self.mainItemSize.height + kInterItemsSpacing) * foatMainRowIndex
        var size: CGSize = self.mainItemSize
        
        // Here we recalculate offsets and size for side items
        if columnType == .side {
            let sideRowIndex = (indexPath.item % totalItemsInRow) - 1
            let foatSideRowIndex = CGFloat(sideRowIndex)

            offsetX += self.mainItemSize.width + kInterItemsSpacing
            offsetY += (self.sideItemSize.height + kInterItemsSpacing) * foatSideRowIndex

            size = self.sideItemSize
        }
        
        return CGRect(origin: CGPoint(x: offsetX, y: offsetY), size: size)
    }
    
    override func calculateItemsSize() {
        let floatNumberOfSideItems = CGFloat(kNumberOfSideItems)
        let contentWidthWithoutIndents = self.collectionView!.bounds.width - self.sectionInsets.left - self.sectionInsets.right
        let resolvedContentWidth = contentWidthWithoutIndents - kInterItemsSpacing
        
        // We need to calculate side item size first, in order to calculate main item height
        let sideItemWidth = resolvedContentWidth * kSideItemWidthCoef
        let sideItemHeight = sideItemWidth * kSideItemHeightAspect
        
        self.sideItemSize = CGSize(width: sideItemWidth, height: sideItemHeight)
        
        // Now we can calculate main item height
        let mainItemWidth = resolvedContentWidth - sideItemWidth
        let mainItemHeight = sideItemHeight * floatNumberOfSideItems + ((floatNumberOfSideItems - 1) * kInterItemsSpacing)
        
        self.mainItemSize = CGSize(width: mainItemWidth, height: mainItemHeight)
    }
}

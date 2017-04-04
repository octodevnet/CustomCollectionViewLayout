//
//  OCTCollectionViewLayout_v2.swift
//  OCTCustomCollectionViewLayout
//
//  Created by dmitry.brovkin on 4/3/17.
//  Copyright © 2017 dmitry.brovkin. All rights reserved.
//

import UIKit

private let kSideItemWidthCoef: CGFloat = 0.3
private let kSideItemHeightAspect: CGFloat = 1
private let kNumberOfSideItems = 3

class OCTCollectionViewLayout_v2: OCTBaseCollectionViewLayout {
    private var mainItemSize: CGSize!
    private var sideItemSize: CGSize!
    private var columnsOffsetX: [CGFloat]!

    //MARK: Init
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.totalColumns = 2
    }
    
    //MARK: Override getters
    override var description: String {
        return "Layout v2"
    }

    //MARK: Override Abstract methods
    override func columnIndexForItemAt(indexPath: IndexPath) -> Int {
        let totalItemsInRow = kNumberOfSideItems + 1
        let columnIndex = indexPath.item % totalItemsInRow
        let columnIndexLimit = totalColumns - 1
        
        return columnIndex > columnIndexLimit  ? columnIndexLimit : columnIndex
    }
    
    override func calculateItemFrame(indexPath: IndexPath, columnIndex: Int, columnOffsetY: CGFloat) -> CGRect {
        let size = columnIndex == 0 ? mainItemSize : sideItemSize
        return CGRect(origin: CGPoint(x: columnsOffsetX[columnIndex], y: columnOffsetY), size: size!)
    }
    
    override func calculateItemsSize() {
        let floatNumberOfSideItems = CGFloat(kNumberOfSideItems)
        let contentWidthWithoutIndents = collectionView!.bounds.width - contentInsets.left - contentInsets.right
        let resolvedContentWidth = contentWidthWithoutIndents - interItemsSpacing
        
        // We need to calculate side item size first, in order to calculate main item height
        let sideItemWidth = resolvedContentWidth * kSideItemWidthCoef
        let sideItemHeight = sideItemWidth * kSideItemHeightAspect
        
        sideItemSize = CGSize(width: sideItemWidth, height: sideItemHeight)
        
        // Now we can calculate main item height
        let mainItemWidth = resolvedContentWidth - sideItemWidth
        let mainItemHeight = sideItemHeight * floatNumberOfSideItems + ((floatNumberOfSideItems - 1) * interItemsSpacing)
        
        mainItemSize = CGSize(width: mainItemWidth, height: mainItemHeight)
        
        // Calculating offsets by X for each column
        columnsOffsetX = [
            contentInsets.left,
            contentInsets.left + mainItemSize.width + interItemsSpacing
        ]
    }
}

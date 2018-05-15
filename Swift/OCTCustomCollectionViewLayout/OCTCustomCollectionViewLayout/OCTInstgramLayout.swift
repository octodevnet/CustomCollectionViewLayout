//
//  OCTInstgramLayout.swift
//  OCTCustomCollectionViewLayout
//
//  Created by Dmytro Brovkin on 2018-03-22.
//  Copyright © 2018 dmitry.brovkin. All rights reserved.
//

import UIKit

private let kSideItemHeightAspect: CGFloat = 1
private let kNumberOfSideItems = 2
private let kNumberOfElementsInPage = 9


class OCTInstgramLayout: UICollectionViewLayout {
        private var _layoutMap = [IndexPath : UICollectionViewLayoutAttributes]()
        private var _contentSize: CGSize!
        private var _columnsYoffset: [CGFloat]!

        private var _mainItemSize: CGSize!
        private var _sideItemSize: CGSize!
        
        private(set) var totalItemsInSection = 0
        
        var totalColumns = 3
        var interItemsSpacing: CGFloat = 1
        
        //MARK: getters
        var contentInsets: UIEdgeInsets {
            return collectionView!.contentInset
        }
        
        override var collectionViewContentSize: CGSize {
            return _contentSize
        }
        
        //MARK: Override methods
        override func prepare() {
            _layoutMap.removeAll()
            _columnsYoffset = Array(repeating: 0, count: totalColumns)

            totalItemsInSection = collectionView!.numberOfItems(inSection: 0)
            
            if totalItemsInSection > 0 && totalColumns > 0 {
                self.calculateItemsSize()
                
                var itemIndex = 0
                var contentSizeHeight: CGFloat = 0
                
                while itemIndex < totalItemsInSection {
                    let indexPath = IndexPath(item: itemIndex, section: 0)
                    let attributeRect = self.rectForItemAt(indexPath: indexPath)
                    let targetLayoutAttributes = UICollectionViewLayoutAttributes.init(forCellWith: indexPath)
                    targetLayoutAttributes.frame = attributeRect
                    
                    contentSizeHeight = max(attributeRect.maxY, contentSizeHeight)
                    _layoutMap[indexPath] = targetLayoutAttributes
                    
                    itemIndex += 1
                }
                
                
                _contentSize = CGSize(width: collectionView!.bounds.width - contentInsets.left - contentInsets.right,
                                      height: contentSizeHeight)
            }
        }
        
        override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
            var layoutAttributesArray = [UICollectionViewLayoutAttributes]()
            
            for (_, layoutAttributes) in _layoutMap {
                if rect.intersects(layoutAttributes.frame) {
                    layoutAttributesArray.append(layoutAttributes)
                }
            }
            
            return layoutAttributesArray
        }
        
        override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
            return _layoutMap[indexPath]
        }
        
        //MARK: Private methods
        private func calculateItemsSize() {
            let floatNumberOfSideItems = CGFloat(kNumberOfSideItems)
            let contentWidthWithoutIndents = collectionView!.bounds.width - contentInsets.left - contentInsets.right
            let resolvedContentWidth = contentWidthWithoutIndents - interItemsSpacing
            
            // We need to calculate side item size first, in order to calculate main item height
            let sideItemWidth = resolvedContentWidth / CGFloat(self.totalColumns)
            let sideItemHeight = sideItemWidth * kSideItemHeightAspect
            
            _sideItemSize = CGSize(width: sideItemWidth, height: sideItemHeight)
            
            // Now we can calculate main item height
            let mainItemWidth = resolvedContentWidth - sideItemWidth
            let mainItemHeight = sideItemHeight * floatNumberOfSideItems + ((floatNumberOfSideItems - 1) * interItemsSpacing)
            
            _mainItemSize = CGSize(width: mainItemWidth, height: mainItemHeight)
        }
    
        private func rectForItemAt(indexPath: IndexPath) -> CGRect {
            let pageNumber = indexPath.item / kNumberOfElementsInPage
            let pageIsEven = pageNumber % 2 == 0 ? true : false
            let elementIndexInPage = indexPath.row % kNumberOfElementsInPage
            
            let columnIndex: Int
            var positionY: CGFloat?
            let itemSize: CGSize
            
            if pageIsEven {
                // Big cell on the right
                if elementIndexInPage < kNumberOfSideItems {
                    itemSize = _sideItemSize
                    columnIndex = 0
                } else if elementIndexInPage == kNumberOfSideItems {
                    itemSize = _mainItemSize
                    columnIndex = 1
                    
                    positionY = _columnsYoffset[columnIndex]
                    for index in columnIndex..<self.totalColumns {
                        _columnsYoffset[index] = positionY! + itemSize.height + interItemsSpacing
                    }
                } else {
                    itemSize = _sideItemSize
                    columnIndex = elementIndexInPage % self.totalColumns
                }
            } else {
                // Big cell on the left
                if elementIndexInPage == 0 {
                    itemSize = _mainItemSize
                    columnIndex  = 0
                    positionY = _columnsYoffset[columnIndex]

                    for index in columnIndex..<self.totalColumns - 1 {
                        _columnsYoffset[index] = positionY! + itemSize.height + interItemsSpacing
                    }
                } else if elementIndexInPage <= kNumberOfSideItems {
                    itemSize = _sideItemSize
                    columnIndex = self.totalColumns - 1
                } else {
                    itemSize = _sideItemSize
                    columnIndex = elementIndexInPage % self.totalColumns
                }
            }
            
            if positionY == nil {
                positionY = _columnsYoffset[columnIndex]
                _columnsYoffset[columnIndex] = positionY! + itemSize.height + interItemsSpacing
            }
            
            let positionX = (_sideItemSize.width + self.interItemsSpacing) * CGFloat(columnIndex)
            return CGRect(x: positionX, y: positionY!, width: itemSize.width, height: itemSize.height)
        }
}


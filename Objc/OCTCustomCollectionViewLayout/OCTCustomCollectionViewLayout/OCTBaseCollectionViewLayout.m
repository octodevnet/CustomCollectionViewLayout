//
//  OCTBaseCollectionViewLayout.m
//  OCTCustomCollectionViewLayout
//
//  Created by dmitry.brovkin on 4/3/17.
//  Copyright © 2017 dmitry.brovkin. All rights reserved.
//

#import "OCTBaseCollectionViewLayout.h"

@implementation OCTBaseCollectionViewLayout
{
    NSMutableDictionary <NSIndexPath *, UICollectionViewLayoutAttributes *>* _layoutMap;
    NSMutableArray<NSNumber *> *_columnsOffsetY;
    CGSize _contentSize;
}

#pragma mark Init

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        _layoutMap = [NSMutableDictionary new];
        self.totalColumns = 0;
        self.interItemsSpacing = 8;
    }
    
    return self;
}

#pragma mark Override getters

- (UIEdgeInsets)contentInsets {
    return self.collectionView.contentInset;
}

#pragma mark Override methods

- (CGSize)collectionViewContentSize {
    return _contentSize;
}

- (void)prepareLayout {
    [_layoutMap removeAllObjects];
    _totalItemsInSection = [self.collectionView numberOfItemsInSection:0];
    _columnsOffsetY = [self initialDataForColumnsOffsetY];
    
    if (_totalItemsInSection > 0 && self.totalColumns > 0) {
        [self calculateItemsSize];
        
        NSInteger itemIndex = 0;
        CGFloat contentSizeHeight = 0;
        
        while (itemIndex < _totalItemsInSection) {
            NSIndexPath *targetIndexPath = [NSIndexPath indexPathForItem:itemIndex inSection:0];
            NSInteger columnIndex = [self columnIndexForItemAtIndexPath:targetIndexPath];
            
            CGRect attributeRect = [self calculateItemFrameAtIndexPath:targetIndexPath columnIndex:columnIndex columnOffsetY:_columnsOffsetY[columnIndex].integerValue];
            UICollectionViewLayoutAttributes *targetLayoutAttributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:targetIndexPath];
            targetLayoutAttributes.frame = attributeRect;
            
            contentSizeHeight = MAX(CGRectGetMaxY(attributeRect), contentSizeHeight);
            _columnsOffsetY[columnIndex] = @(CGRectGetMaxY(attributeRect) + self.interItemsSpacing);
            _layoutMap[targetIndexPath] = targetLayoutAttributes;
            
            itemIndex += 1;
        }
        
        _contentSize = CGSizeMake(self.collectionView.bounds.size.width - self.contentInsets.left - self.contentInsets.right,
                                  contentSizeHeight);
    }
}

- (NSArray <UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSMutableArray<UICollectionViewLayoutAttributes *> *layoutAttributesArray = [NSMutableArray new];
    
    for (UICollectionViewLayoutAttributes *layoutAttributes in _layoutMap.allValues) {
        if (CGRectIntersectsRect(layoutAttributes.frame, rect)) {
            [layoutAttributesArray addObject:layoutAttributes];
        }
    }
    
    return layoutAttributesArray;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    return _layoutMap[indexPath];
}

#pragma mark Abstract methods
- (NSInteger)columnIndexForItemAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.item % self.totalItemsInSection;
}

- (CGRect)calculateItemFrameAtIndexPath:(NSIndexPath *)indexPath columnIndex:(NSInteger)columnIndex columnOffsetY:(CGFloat)columnOffsetY {
    return CGRectZero;
}

- (void)calculateItemsSize {}

#pragma mark Private methods

- (NSMutableArray<NSNumber *> *)initialDataForColumnsOffsetY {
    NSMutableArray *tempArray = [NSMutableArray new];
    
    for (int i = 0; i < self.totalColumns; i++) {
        [tempArray addObject:@(0)];
    }
    return tempArray;
}

@end

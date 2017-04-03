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
    CGSize _contentSize;
}

#pragma mark Init

- (instancetype)init {
    self = [super init];
    
    if (self) {
        _layoutMap = [NSMutableDictionary new];
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        _layoutMap = [NSMutableDictionary new];
    }
    
    return self;
}

#pragma mark Override methods

- (CGSize)collectionViewContentSize {
    return _contentSize;
}

- (void)prepareLayout {
    [_layoutMap removeAllObjects];
    _totalItemsInSection = [self.collectionView numberOfItemsInSection:0];
    
    if (_totalItemsInSection > 0) {
        [self calculateItemsSize];
        
        NSInteger itemIndex = 0;
        CGFloat contentSizeHeight = 0;
        
        while (itemIndex < _totalItemsInSection) {
            NSIndexPath *targetIndexPath = [NSIndexPath indexPathForItem:itemIndex inSection:0];
            CGRect attributeRect = [self calculateItemFrameAtIndexPath:targetIndexPath];
            UICollectionViewLayoutAttributes *targetLayoutAttributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:targetIndexPath];
            targetLayoutAttributes.frame = attributeRect;
            
            if (CGRectGetMaxY(attributeRect) > contentSizeHeight) {
                contentSizeHeight = CGRectGetMaxY(attributeRect);
            }
            
            _layoutMap[targetIndexPath] = targetLayoutAttributes;
            itemIndex += 1;
        }
        
        _contentSize = CGSizeMake(self.collectionView.bounds.size.width,
                                  contentSizeHeight + self.sectionInsets.bottom);
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

- (nullable UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    return _layoutMap[indexPath];
}

#pragma mark Abstract methods

- (CGRect)calculateItemFrameAtIndexPath:(NSIndexPath *)indexPath {
    return CGRectZero;
}

- (void)calculateItemsSize {}

@end

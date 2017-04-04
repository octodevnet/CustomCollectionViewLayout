//
//  OCTBaseCollectionViewLayout_v1.m
//  OCTCustomCollectionViewLayout
//
//  Created by dmitry.brovkin on 4/3/17.
//  Copyright © 2017 dmitry.brovkin. All rights reserved.
//

#import "OCTCollectionViewLayout_v1.h"

static const NSInteger kReducedHeightColunmIndex = 1;
static const CGFloat kItemHeightAspect = 2;

@implementation OCTCollectionViewLayout_v1
{
    CGSize _itemSize;
    NSMutableArray<NSNumber *> *_columnsOffsetX;
}

#pragma mark Init

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        self.totalColumns = 3;
    }
    
    return self;
}

#pragma mark Override Abstract methods

- (NSInteger)columnIndexForItemAtIndexPath:(NSIndexPath *)indexPath {
    //If last item is single in row, we move it to reduced column, to make it looks nice
    NSInteger columnIndex = indexPath.item % self.totalColumns;
    return [self isLastItemSingleInRowForIndexPath:indexPath] ? kReducedHeightColunmIndex : columnIndex;
}

- (CGRect)calculateItemFrameAtIndexPath:(NSIndexPath *)indexPath columnIndex:(NSInteger)columnIndex columnOffsetY:(CGFloat)columnOffsetY {
    NSInteger rowIndex = indexPath.item / self.totalColumns;
    CGFloat halfItemHeight = (_itemSize.height - self.interItemsSpacing) / 2;
    
    //Resolving Item height
    CGFloat itemHeight = _itemSize.height;
    
    // By our logic, first and last items in reduced height column have height devided by 2.
    if ((rowIndex == 0 && columnIndex == kReducedHeightColunmIndex) || [self isLastItemSingleInRowForIndexPath:indexPath]) {
        itemHeight = halfItemHeight;
    }
    
    return CGRectMake(_columnsOffsetX[columnIndex].floatValue, columnOffsetY, _itemSize.width, itemHeight);
}

- (void)calculateItemsSize {
    CGFloat contentWidthWithoutIndents = self.collectionView.bounds.size.width - self.contentInsets.left - self.contentInsets.right;
    CGFloat itemWidth = (contentWidthWithoutIndents - (self.totalColumns - 1) * self.interItemsSpacing) / self.totalColumns;
    CGFloat itemHeight = itemWidth * kItemHeightAspect;

    _itemSize = CGSizeMake(itemWidth, itemHeight);
    
    // Calculating offsets by X for each column
    _columnsOffsetX = [NSMutableArray new];
    
    for (int columnIndex = 0; columnIndex < self.totalColumns; columnIndex++) {
        [_columnsOffsetX addObject:@(columnIndex * (_itemSize.width + self.interItemsSpacing))];
    }
}

- (NSString *)description {
    return @"Layout v1";
}

#pragma mark Private methdos

- (BOOL)isLastItemSingleInRowForIndexPath:(NSIndexPath *)indexPath {
    return indexPath.item == (self.totalItemsInSection - 1) && indexPath.item % self.totalColumns == 0;
}

@end

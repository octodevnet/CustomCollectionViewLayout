//
//  OCTBaseCollectionViewLayout_v2.m
//  OCTCustomCollectionViewLayout
//
//  Created by dmitry.brovkin on 4/3/17.
//  Copyright © 2017 dmitry.brovkin. All rights reserved.
//

#import "OCTCollectionViewLayout_v2.h"

static const CGFloat kInterItemsSpacing = 5;
static const CGFloat kSideItemWidthCoef = 0.3;
static const CGFloat kSideItemHeightAspect = 1;
static const NSInteger kNumberOfSideItems = 3;

typedef NS_ENUM(NSInteger, ColumnType) {
    ColumnTypeMain = 0,
    ColumnTypeSide
};

@implementation OCTCollectionViewLayout_v2
{
    CGSize _mainItemSize;
    CGSize _sideItemSize;
}

- (CGRect)calculateItemFrameAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger totalItemsInRow = kNumberOfSideItems + 1;
    NSInteger columnTypeRawValue = indexPath.item % totalItemsInRow;
    ColumnType columnType = columnTypeRawValue > 1 ? ColumnTypeSide : columnTypeRawValue;
    
    NSInteger mainRowIndex = indexPath.item / totalItemsInRow;

    // By default, we assign params for main item
    CGFloat offsetX = self.sectionInsets.left;
    CGFloat offsetY = self.sectionInsets.top + (_mainItemSize.height + kInterItemsSpacing) * mainRowIndex;
    CGSize size = _mainItemSize;

    // Here we recalculate offsets and size for side items
    if (columnType == ColumnTypeSide) {
        NSInteger sideRowIndex = (indexPath.item % totalItemsInRow) - 1;

        offsetX += _mainItemSize.width + kInterItemsSpacing;
        offsetY += (_sideItemSize.height + kInterItemsSpacing) * sideRowIndex;

        size = _sideItemSize;
    }

    return CGRectMake(offsetX, offsetY, size.width, size.height);
}

- (void)calculateItemsSize {
    CGFloat contentWidthWithoutIndents = self.collectionView.bounds.size.width - self.sectionInsets.left - self.sectionInsets.right;
    CGFloat resolvedContentWidth = contentWidthWithoutIndents - kInterItemsSpacing;

    // We need to calculate side item size first, in order to calculate main item height
    CGFloat sideItemWidth = resolvedContentWidth * kSideItemWidthCoef;
    CGFloat sideItemHeight = sideItemWidth * kSideItemHeightAspect;

    _sideItemSize = CGSizeMake(sideItemWidth, sideItemHeight);

    // Now we can calculate main item height
    CGFloat mainItemWidth = resolvedContentWidth - sideItemWidth;
    CGFloat mainItemHeight = sideItemHeight * kNumberOfSideItems + ((kNumberOfSideItems - 1) * kInterItemsSpacing);

    _mainItemSize = CGSizeMake(mainItemWidth, mainItemHeight);
}

- (NSString *)description {
    return @"Layout v2";
}

@end

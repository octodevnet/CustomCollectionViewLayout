//
//  OCTBaseCollectionViewLayout_v1.m
//  OCTCustomCollectionViewLayout
//
//  Created by dmitry.brovkin on 4/3/17.
//  Copyright © 2017 dmitry.brovkin. All rights reserved.
//

#import "OCTCollectionViewLayout_v1.h"

static const CGFloat kInterItemsSpacing = 5;
static const NSInteger kNumberOfColums = 3;
static const NSInteger kReducedHeightColunmIndex = 1;
static const CGFloat kItemHeightAspect = 2;


@implementation OCTCollectionViewLayout_v1
{
    CGSize _itemSize;
}

- (CGRect)calculateItemFrameAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger columnIndex = indexPath.item % kNumberOfColums;
    NSInteger rowIndex = indexPath.item / kNumberOfColums;
    CGFloat halfItemHeight = (_itemSize.height - kInterItemsSpacing) / 2;

    //If last item is single in row, we move it to reduced column, to make it looks nice
    BOOL isLastItemSingleInRow = indexPath.item == (self.totalItemsInSection - 1) && columnIndex == 0;
    NSInteger resolvedColumnIndex = isLastItemSingleInRow ? kReducedHeightColunmIndex : columnIndex;

    //Calculating Point
    CGFloat offsetX = self.sectionInsets.left + resolvedColumnIndex * (_itemSize.width + kInterItemsSpacing);
    CGFloat offsetY = self.sectionInsets.top + rowIndex * (_itemSize.height + kInterItemsSpacing);
    
    // By our logic, first and last items in reduced height column have height devided by 2.
    // So we need to adjust appropriately all further cell's pointY
    if (rowIndex > 0 && resolvedColumnIndex == kReducedHeightColunmIndex) {
        offsetY -= (halfItemHeight + kInterItemsSpacing);
    }
    CGPoint point = CGPointMake(offsetX, offsetY);

    //Calculating Size
    CGFloat itemHeight = _itemSize.height;

    if ((rowIndex == 0 && resolvedColumnIndex == kReducedHeightColunmIndex) || isLastItemSingleInRow) {
        itemHeight = halfItemHeight;
    }
    CGSize size = CGSizeMake(_itemSize.width, itemHeight);

    return (CGRect){point, size};
}

- (void)calculateItemsSize {
    CGFloat contentWidthWithoutIndents = self.collectionView.bounds.size.width - self.sectionInsets.left - self.sectionInsets.right;
    CGFloat itemWidth = (contentWidthWithoutIndents - (kNumberOfColums - 1) * kInterItemsSpacing) / kNumberOfColums;
    CGFloat itemHeight = itemWidth * kItemHeightAspect;

    _itemSize = CGSizeMake(itemWidth, itemHeight);
}

- (NSString *)description {
    return @"Layout v1";
}

@end

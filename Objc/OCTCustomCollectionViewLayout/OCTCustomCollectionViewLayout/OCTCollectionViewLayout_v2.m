//
//  OCTBaseCollectionViewLayout_v2.m
//  OCTCustomCollectionViewLayout
//
//  Created by dmitry.brovkin on 4/3/17.
//  Copyright © 2017 dmitry.brovkin. All rights reserved.
//

#import "OCTCollectionViewLayout_v2.h"

static const CGFloat kSideItemWidthCoef = 0.3;
static const CGFloat kSideItemHeightAspect = 1;
static const NSInteger kNumberOfSideItems = 3;

@implementation OCTCollectionViewLayout_v2
{
    CGSize _mainItemSize;
    CGSize _sideItemSize;
    NSArray<NSNumber *> *_columnsOffsetX;
}

#pragma mark Init

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        self.totalColumns = 2;
    }
    
    return self;
}

#pragma mark Override Abstract methods

- (NSInteger)columnIndexForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger totalItemsInRow = kNumberOfSideItems + 1;
    NSInteger columnIndex = indexPath.item % totalItemsInRow;
    NSInteger columnIndexLimit = self.totalColumns - 1;
    
    return columnIndex > columnIndexLimit  ? columnIndexLimit : columnIndex;
}

- (CGRect)calculateItemFrameAtIndexPath:(NSIndexPath *)indexPath columnIndex:(NSInteger)columnIndex columnOffsetY:(CGFloat)columnOffsetY {
    CGSize size = columnIndex == 0 ? _mainItemSize : _sideItemSize;
    return CGRectMake(_columnsOffsetX[columnIndex].floatValue, columnOffsetY, size.width, size.height);
}

- (void)calculateItemsSize {
    CGFloat contentWidthWithoutIndents = self.collectionView.bounds.size.width - self.contentInsets.left - self.contentInsets.right;
    CGFloat resolvedContentWidth = contentWidthWithoutIndents - self.interItemsSpacing;

    // We need to calculate side item size first, in order to calculate main item height
    CGFloat sideItemWidth = resolvedContentWidth * kSideItemWidthCoef;
    CGFloat sideItemHeight = sideItemWidth * kSideItemHeightAspect;

    _sideItemSize = CGSizeMake(sideItemWidth, sideItemHeight);

    // Now we can calculate main item height
    CGFloat mainItemWidth = resolvedContentWidth - sideItemWidth;
    CGFloat mainItemHeight = sideItemHeight * kNumberOfSideItems + ((kNumberOfSideItems - 1) * self.interItemsSpacing);

    _mainItemSize = CGSizeMake(mainItemWidth, mainItemHeight);
    
    // Calculating offsets by X for each column
    _columnsOffsetX = @[@(self.contentInsets.left),
                        @(self.contentInsets.left + _mainItemSize.width + self.interItemsSpacing)];
}

- (NSString *)description {
    return @"Layout v2";
}

@end

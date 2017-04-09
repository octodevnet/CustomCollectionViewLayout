//
//  OCTBaseCollectionViewLayout.h
//  OCTCustomCollectionViewLayout
//
//  Created by dmitry.brovkin on 4/3/17.
//  Copyright © 2017 dmitry.brovkin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OCTBaseCollectionViewLayout : UICollectionViewLayout

@property (nonatomic, readonly) NSInteger totalItemsInSection;
@property (nonatomic, readonly) UIEdgeInsets contentInsets;

@property (nonatomic, assign) NSInteger totalColumns;
@property (nonatomic, assign) CGFloat interItemsSpacing;

//These methods should be overriden by inheritor
- (NSInteger)columnIndexForItemAtIndexPath:(NSIndexPath *)indexPath;
- (CGRect)calculateItemFrameAtIndexPath:(NSIndexPath *)indexPath columnIndex:(NSInteger)columnIndex columnYoffset:(CGFloat)columnYoffset;
- (void)calculateItemsSize;

@end

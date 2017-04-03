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
@property (nonatomic, assign) UIEdgeInsets sectionInsets;

//These methods should be overriden by inheritor
- (CGRect)calculateItemFrameAtIndexPath:(NSIndexPath *)indexPath;
- (void)calculateItemsSize;

@end

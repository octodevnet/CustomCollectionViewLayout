//
//  OCTCollectionViewCell.m
//  OCTCustomCollectionViewLayout
//
//  Created by fantom on 4/4/17.
//  Copyright © 2017 dmitry.brovkin. All rights reserved.
//

#import "OCTCollectionViewCell.h"

@implementation OCTCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.imgView.layer.cornerRadius = 8;
    self.imgView.clipsToBounds = YES;
}

@end

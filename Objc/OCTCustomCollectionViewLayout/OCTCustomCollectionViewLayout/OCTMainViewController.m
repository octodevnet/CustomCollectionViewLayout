//
//  ViewController.m
//  OCTCustomCollectionViewLayout
//
//  Created by dmitry.brovkin on 4/3/17.
//  Copyright © 2017 dmitry.brovkin. All rights reserved.
//

#import "OCTMainViewController.h"

static NSString *const kReuseCellID = @"reuseCellID";


@interface OCTMainViewController () <UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end


@implementation OCTMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:kReuseCellID];
    self.title = [self.collectionView.collectionViewLayout description];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 13;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kReuseCellID forIndexPath:indexPath];
    cell.contentView.backgroundColor = [UIColor greenColor];
    
    return cell;
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    [self.collectionView.collectionViewLayout invalidateLayout];
}

@end

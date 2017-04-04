//
//  ViewController.m
//  OCTCustomCollectionViewLayout
//
//  Created by dmitry.brovkin on 4/3/17.
//  Copyright © 2017 dmitry.brovkin. All rights reserved.
//

#import "OCTMainViewController.h"
#import "OCTCollectionViewCell.h"

static NSString *const kReuseCellID = @"reuseCellID";
static NSString *const kImgName = @"img_";
static const NSInteger kTotalImgs = 10;


@interface OCTMainViewController () <UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end


@implementation OCTMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.title = [self.collectionView.collectionViewLayout description];
    
    self.collectionView.contentInset = UIEdgeInsetsMake(8, 8, 8, 8);
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([OCTCollectionViewCell class]) bundle:nil]
          forCellWithReuseIdentifier:kReuseCellID];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 13;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    int imgNumber = indexPath.item % kTotalImgs + 1;
    NSString *imageName = [NSString stringWithFormat:@"%@%d", kImgName, imgNumber];
    
    OCTCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kReuseCellID forIndexPath:indexPath];
    cell.imgView.image = [UIImage imageNamed:imageName];
    
    return cell;
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    [self.collectionView.collectionViewLayout invalidateLayout];
}

@end

//
//  FeedViewController.m
//  PCFeed
//
//  Created by Olivier Lechenne on 1/10/20.
//  Copyright © 2020 Olivier Lechenne. All rights reserved.
//

#import "FeedViewController.h"
#import "CollectionViewCell.h"
#import "TopCollectionViewCell.h"
#import "DetailViewController.h"
#import "FeedDataModel.h"
#import "CollectionReusableView.h"

static NSString *const kCollectionViewCell = @"CollectionViewCell";
static NSString *const kTopCollectionViewCell = @"TopCollectionViewCell";
static NSString *const kCollectionViewHeader = @"CollectionViewHeader";


@interface FeedViewController () <FeedDataModelProtocol, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic)FeedDataModel *feedData;
@property (nonatomic)UICollectionView *collectionView;

@end

@implementation FeedViewController

- (void)loadView {
    [super loadView];
    UICollectionViewFlowLayout *flowLayout = UICollectionViewFlowLayout.new;
    flowLayout.estimatedItemSize = CGSizeMake(1, 1);
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:UICollectionViewFlowLayout.new];
    self.collectionView.translatesAutoresizingMaskIntoConstraints = NO;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.collectionView];

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self
      action:@selector(onTapRefresh:)];

    [self.view.topAnchor constraintEqualToAnchor:self.collectionView.topAnchor].active = YES;
    [self.view.bottomAnchor constraintEqualToAnchor:self.collectionView.bottomAnchor].active = YES;
    [self.view.leadingAnchor constraintEqualToAnchor:self.collectionView.leadingAnchor].active = YES;
    [self.view.trailingAnchor constraintEqualToAnchor:self.collectionView.trailingAnchor].active = YES;
    
    self.feedData = FeedDataModel.new;
    self.feedData.delegate = self;
    
    self.title = NSLocalizedString(@"Research & Insigths", nil);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.alwaysBounceVertical = YES;
    [self.collectionView registerClass:[CollectionViewCell class] forCellWithReuseIdentifier:kCollectionViewCell];
    [self.collectionView registerClass:[TopCollectionViewCell class] forCellWithReuseIdentifier:kTopCollectionViewCell];
    [self.collectionView registerClass:[CollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kCollectionViewHeader];
    
    [self.feedData initWithFeed:@"https://www.personalcapital.com/blog/feed/"];
}

- (void)onTapRefresh:(UIButton *)button {
    [self.feedData reload];
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    DetailViewController *detailVC = [[DetailViewController alloc] init];
    NSInteger row = (indexPath.section == 0 ? indexPath.row : indexPath.row + 1);
    detailVC.urlStringToLoad = [self.feedData itemURLStringForRow:row];
    
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:detailVC];
    nc.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:nc animated:YES completion:nil];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 2;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 0) {
        return ([self.feedData count] > 0 ? 1 : 0);
    } else {
        return ([self.feedData count] > 1 ? [self.feedData count] - 1 : 0);
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = (indexPath.section == 0 ? indexPath.row : indexPath.row + 1);
        
    if (indexPath.section > 0) {
        CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCollectionViewCell forIndexPath:indexPath];
        cell.imageView.image = nil;
        [cell.activityIndicator startAnimating];
        [self.feedData imageForRow:row completionBlock:^(BOOL succeeded, UIImage * _Nonnull image) {
            if (succeeded) {
                [cell.activityIndicator stopAnimating];
                cell.imageView.image = image;
            }
        }];

        cell.titleLabel.text = [self.feedData titleForRow:row];
        return cell;
    } else {
        TopCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kTopCollectionViewCell forIndexPath:indexPath];
        
        cell.imageView.image = nil;
        [cell.activityIndicator startAnimating];
        [self.feedData imageForRow:row completionBlock:^(BOOL succeeded, UIImage * _Nonnull image) {
            if (succeeded) {
                [cell.activityIndicator stopAnimating];
                cell.imageView.image = image;
            }
        }];

        cell.titleLabel.text = [self.feedData titleForRow:row];
        cell.descriptionLabel.text = [self.feedData descriptionForRow:row];
        
        return cell;
    }
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionHeader) {
        CollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kCollectionViewHeader forIndexPath:indexPath];
        headerView.titleLabel.text = NSLocalizedString(@"Previous Articles", nil);
        
        reusableview = headerView;
    }
    
    return reusableview;
}
#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        CGFloat width = self.collectionView.bounds.size.width;
        CGFloat height = width/1.8 + 65;
        return CGSizeMake(self.collectionView.bounds.size.width, height);
    } else {
        CGFloat width;
        if ([[UIDevice currentDevice] userInterfaceIdiom]  == UIUserInterfaceIdiomPad ) {
            width = self.collectionView.bounds.size.width/3 - 10;
        } else {
            width = self.collectionView.bounds.size.width/2 - 10;
        }
        CGFloat height = width/1.8 + 40;
        return CGSizeMake(width, height);
    }
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    if (section == 0) {
        return UIEdgeInsetsMake(0, 0, 0, 0);
    } else {
        return UIEdgeInsetsMake(0, 5, 0, 5);
    }
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 10;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return CGSizeZero;
    } else {
        return CGSizeMake(self.collectionView.bounds.size.width, 35);
    }
}

#pragma mark - FeedDataModelProtocol

- (void)feedDidEndDocument {
    [self.collectionView reloadData];
}

@end


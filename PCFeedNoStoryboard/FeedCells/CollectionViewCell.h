//
//  CollectionViewCell.h
//  PCFeed
//
//  Created by Olivier Lechenne on 1/10/20.
//  Copyright © 2020 Olivier Lechenne. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CollectionViewCell : UICollectionViewCell

@property (nonatomic)UILabel *titleLabel;
@property (nonatomic)UIImageView *imageView;
@property (nonatomic)UIActivityIndicatorView *activityIndicator;

@end

NS_ASSUME_NONNULL_END

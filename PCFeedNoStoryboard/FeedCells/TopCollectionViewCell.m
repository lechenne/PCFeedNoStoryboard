//
//  TopCollectionViewCell.m
//  PCFeed
//
//  Created by Olivier Lechenne on 1/10/20.
//  Copyright © 2020 Olivier Lechenne. All rights reserved.
//

#import "TopCollectionViewCell.h"

@implementation TopCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.titleLabel.numberOfLines = 2;
        self.titleLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
        self.titleLabel.textAlignment = NSTextAlignmentLeft;
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
        self.titleLabel.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.titleLabel];
        
        self.descriptionLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.descriptionLabel.numberOfLines = 2;
        self.descriptionLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleCaption2];
        self.descriptionLabel.textAlignment = NSTextAlignmentLeft;
        self.descriptionLabel.translatesAutoresizingMaskIntoConstraints = NO;
        self.descriptionLabel.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.descriptionLabel];
        
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        self.imageView.translatesAutoresizingMaskIntoConstraints = NO;
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:self.imageView];
        
        // Add all the constraints
        UILayoutGuide *marginGuide = self.contentView.layoutMarginsGuide;
        
        [self.descriptionLabel.leadingAnchor constraintEqualToAnchor:marginGuide.leadingAnchor].active = YES;
        [self.descriptionLabel.trailingAnchor constraintEqualToAnchor:marginGuide.trailingAnchor].active = YES;
        [self.descriptionLabel.bottomAnchor constraintEqualToAnchor:marginGuide.bottomAnchor].active = YES;
        [self.descriptionLabel.heightAnchor constraintEqualToConstant:30].active = YES;

        [self.titleLabel.leadingAnchor constraintEqualToAnchor:marginGuide.leadingAnchor].active = YES;
        [self.titleLabel.trailingAnchor constraintEqualToAnchor:marginGuide.trailingAnchor].active = YES;
        [self.descriptionLabel.topAnchor constraintEqualToAnchor:self.titleLabel.bottomAnchor].active = YES;
        [self.titleLabel.heightAnchor constraintEqualToConstant:25].active = YES;

        [self.imageView.topAnchor constraintEqualToAnchor:marginGuide.topAnchor].active = YES;
        [self.imageView.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor].active = YES;
        [self.imageView.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor].active = YES;
        
        
        [self.titleLabel.topAnchor constraintEqualToAnchor:self.imageView.bottomAnchor].active = YES;
        
        
        self.layer.borderWidth = 1.0f;
        self.layer.borderColor = [UIColor lightGrayColor].CGColor;

        self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleLarge];
        self.activityIndicator.center = CGPointMake(self.contentView.frame.size.width / 2.0
                                                    , self.contentView.frame.size.height / 2.0);
        [self.contentView addSubview:self.activityIndicator];
        self.activityIndicator.backgroundColor = [UIColor whiteColor];
    }
    
    return self;
}
@end


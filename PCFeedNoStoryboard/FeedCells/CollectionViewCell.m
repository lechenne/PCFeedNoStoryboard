//
//  CollectionViewCell.m
//  PCFeed
//
//  Created by Olivier Lechenne on 1/10/20.
//  Copyright © 2020 Olivier Lechenne. All rights reserved.
//

#import "CollectionViewCell.h"

@implementation CollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:self.titleLabel];
        self.titleLabel.numberOfLines = 2;
        
        self.titleLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleCaption1];
        self.titleLabel.textAlignment = NSTextAlignmentLeft;
        self.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
        
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        self.imageView.translatesAutoresizingMaskIntoConstraints = NO;
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        
        [self.contentView addSubview:self.imageView];
        
        // Add all constraints
        UILayoutGuide *marginGuide = self.contentView.layoutMarginsGuide;
        [self.titleLabel.leadingAnchor constraintEqualToAnchor:marginGuide.leadingAnchor].active = YES;
        [self.titleLabel.trailingAnchor constraintEqualToAnchor:marginGuide.trailingAnchor].active = YES;
        [self.titleLabel.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor].active = YES;
        [self.titleLabel.heightAnchor constraintEqualToConstant:40].active = YES;
        
        [self.imageView.topAnchor constraintEqualToAnchor:self.contentView.topAnchor].active = YES;
        [self.imageView.bottomAnchor constraintEqualToAnchor:self.titleLabel.topAnchor].active = YES;
        [self.imageView.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor].active = YES;
        [self.imageView.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor].active = YES;
        
        self.contentView.backgroundColor = [UIColor whiteColor];
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


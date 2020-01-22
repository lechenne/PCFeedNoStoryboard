//
//  CollectionReusableView.m
//  PCFeedNoStoryboard
//
//  Created by Olivier Lechenne on 1/20/20.
//  Copyright © 2020 Olivier Lechenne. All rights reserved.
//

#import "CollectionReusableView.h"

@implementation CollectionReusableView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [self addSubview:self.titleLabel];
        self.titleLabel.numberOfLines = 1;
        self.titleLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
        self.titleLabel.textAlignment = NSTextAlignmentLeft;
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;

        [self.titleLabel.leadingAnchor constraintEqualToAnchor:self.layoutMarginsGuide.leadingAnchor].active = YES;
        [self.titleLabel.trailingAnchor constraintEqualToAnchor:self.layoutMarginsGuide.trailingAnchor].active = YES;
        [self.titleLabel.centerYAnchor constraintEqualToAnchor:self.centerYAnchor].active = YES;
    }
    return self;
}

@end

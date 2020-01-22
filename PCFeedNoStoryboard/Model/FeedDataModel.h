//
//  FeedDataModel.h
//  PCFeedNoStoryboard
//
//  Created by Olivier Lechenne on 1/20/20.
//  Copyright © 2020 Olivier Lechenne. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol FeedDataModelProtocol <NSObject>

- (void)feedDidEndDocument;

@end

@interface FeedDataModel : NSObject

@property (weak)id<FeedDataModelProtocol> delegate;

- (void)initWithFeed:(NSString *)feedURLString;
- (void)reload;
- (NSUInteger)count;
- (NSString *)titleForRow:(NSInteger)row;
- (NSString *)descriptionForRow:(NSInteger)row;
- (NSString *)itemURLStringForRow:(NSInteger)row;
- (void)imageForRow:(NSInteger)row completionBlock:(void (^)(BOOL succeeded, UIImage *image))completionBlock;


@end

NS_ASSUME_NONNULL_END

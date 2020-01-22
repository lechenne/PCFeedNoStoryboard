//
//  FeedDataModel.m
//  PCFeedNoStoryboard
//
//  Created by Olivier Lechenne on 1/20/20.
//  Copyright © 2020 Olivier Lechenne. All rights reserved.
//

#import "FeedDataModel.h"

@interface FeedDataModel() <NSXMLParserDelegate>

@property (nonatomic)NSXMLParser *parser;
@property (nonatomic)NSMutableArray *feeds;
@property (nonatomic)NSMutableDictionary *item;
@property (nonatomic)NSMutableString *itemTitle;
@property (nonatomic)NSMutableString *link;
@property (nonatomic)NSMutableString *itemDescription;
@property (nonatomic)NSMutableString *pubDate;
@property (nonatomic)NSString *mediaContentLink;
@property (nonatomic)NSString *currentElement;
@property (nonatomic)NSMutableDictionary *imageCache;
@property (nonatomic)NSString *feedURLString;

@end

@implementation FeedDataModel

- (void)initWithFeed:(NSString *)feedURLString {
    self.feedURLString = feedURLString;
    self.feeds = [[NSMutableArray alloc] init];
    self.imageCache = [[NSMutableDictionary alloc] init];
    NSURL *url = [NSURL URLWithString:feedURLString];
    self.parser = [[NSXMLParser alloc] initWithContentsOfURL:url];
    
    self.parser.delegate = self;
    [self.parser setShouldResolveExternalEntities:NO];
    [self.parser parse];
}

- (void)reload {
    [self initWithFeed:self.feedURLString];
    [self.parser parse];
}

- (NSUInteger)count {
    return self.feeds.count;
}

- (NSString *)imageURLStringForRow:(NSInteger)row {
    return self.feeds[row][@"mediaContent"];
}

- (NSString *)titleForRow:(NSInteger)row {
    return self.feeds[row][@"title"];
}

- (NSString *)descriptionForRow:(NSInteger)row {
    return self.feeds[row][@"description"];
}

- (NSString *)itemURLStringForRow:(NSInteger)row {
    return self.feeds[row][@"link"];
}

- (void)imageForRow:(NSInteger)row completionBlock:(void (^)(BOOL succeeded, UIImage *image))completionBlock {
    NSString *imageURLString = [self imageURLStringForRow:row];
    UIImage *image = [self.imageCache objectForKey:imageURLString];
    if (image) {
        completionBlock(YES,image);
    } else {
        NSURL *imageURL = [NSURL URLWithString:imageURLString];
        NSMutableURLRequest *request =[NSMutableURLRequest requestWithURL:imageURL];
        [NSURLConnection sendAsynchronousRequest:request
                                           queue:[NSOperationQueue mainQueue]
                               completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
            if ( !error )
            {
                UIImage *image = [[UIImage alloc] initWithData:data];
                [self.imageCache setObject:image forKey:imageURLString];
                completionBlock(YES,image);
            } else {
                completionBlock(NO,nil);
            }
        }];
        
    }
}

#pragma mark - NSXMLParserDelegate

- (void)parserDidStartDocument:(NSXMLParser *)parser {
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
    [self.delegate feedDidEndDocument];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(nullable NSString *)namespaceURI qualifiedName:(nullable NSString *)qName attributes:(NSDictionary<NSString *, NSString *> *)attributeDict {
    
    self.currentElement = elementName;
    
    if ([self.currentElement isEqualToString:@"item"]) {
        
        self.item = [[NSMutableDictionary alloc] init];
        self.itemTitle = [[NSMutableString alloc] init];
        self.link = [[NSMutableString alloc] init];
        self.itemDescription = [[NSMutableString alloc] init];
        self.pubDate = [[NSMutableString alloc] init];
        
    } else if ([self.currentElement isEqualToString:@"media:content"]) {
        self.mediaContentLink = attributeDict[@"url"];
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    
    if ([elementName isEqualToString:@"item"]) {
        
        [self.item setObject:self.itemTitle forKey:@"title"];
        NSString *cleanLink = [self.link stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        cleanLink = [cleanLink stringByReplacingOccurrencesOfString:@"\t" withString:@""];
        [self.item setObject:cleanLink forKey:@"link"];
        [self.item setObject:self.pubDate forKey:@"puDate"];
        [self.item setObject:self.itemDescription forKey:@"description"];
        [self.item setObject:self.mediaContentLink forKey:@"mediaContent"];
        
        [self.feeds addObject:[self.item copy]];
        
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    if ([self.currentElement isEqualToString:@"title"]) {
        [self.itemTitle appendString:string];
    } else if ([self.currentElement isEqualToString:@"link"]) {
        [self.link appendString:string];
    } else if ([self.currentElement isEqualToString:@"pubDate"]) {
        [self.pubDate appendString:string];
    } else if ([self.currentElement isEqualToString:@"description"]) {
        [self.itemDescription appendString:string];
    }
}


@end

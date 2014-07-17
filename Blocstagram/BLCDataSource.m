//
//  BLCDataSource.m
//  Blocstagram
//
//  Created by Jordan Hudgens on 7/10/14.
//  Copyright (c) 2014 Jordan Hudgens. All rights reserved.
//

#import "BLCDataSource.h"
#import "BLCUser.h"
#import "BLCMedia.h"
#import "BLCComment.h"
#import "BLCLoginViewController.h"

@interface BLCDataSource () {
    NSMutableArray *_mediaItems;
}

@property (nonatomic, assign) BOOL isRefreshing;
@property (nonatomic, assign) BOOL isLoadingOlderItems;
@property (nonatomic, strong) NSString *accessToken;

@end

@implementation BLCDataSource

+ (instancetype) sharedInstance {
    static dispatch_once_t once;
    static id sharedInstance;
    
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (instancetype) init {
    self = [super init];
    
    if (self) {
        [self registerForAccessTokenNotification];
    }
    
    return self;
}

# pragma mark - Key/Value Observing

- (NSUInteger) countOfMediaItems {
    return self.mediaItems.count;
}

- (id) objectInMediaItemsAtIndex:(NSUInteger)index {
    return [self.mediaItems objectAtIndex:index];
}

- (NSArray *) mediaItemsAtIndexes:(NSIndexSet *)indexes {
    return [self.mediaItems objectsAtIndexes:indexes];
}

- (void) insertObject:(BLCMedia *)object inMediaItemsAtIndex:(NSUInteger)index {
    [_mediaItems insertObject:object atIndex:index];
}

- (void) removeObjectFromMediaItemsAtIndex:(NSUInteger)index {
    [_mediaItems removeObjectAtIndex:index];
}

- (void) replaceObjectInMediaItemsAtIndex:(NSUInteger)index withObject:(id)object {
    [_mediaItems replaceObjectAtIndex:index withObject:object];
}

- (void) deleteMediaItem:(BLCMedia *)item {
    NSMutableArray *mutableArrayWithKVO = [self mutableArrayValueForKey:@"mediaItems"];
    [mutableArrayWithKVO removeObject:item];
}

#pragma mark - API call

- (void) requestNewItemsWithCompletionHandler:(BLCNewItemCompletionBlock)completionHandler {
    if (self.isRefreshing == NO) {
        self.isRefreshing = YES;
        
        // Need to add images here
        
        self.isRefreshing = NO;
        
        if (completionHandler) {
            completionHandler(nil);
        }
    }
}

- (void) requestOldItemsWithCompletionHandler:(BLCNewItemCompletionBlock)completionHandler {
    if (self.isLoadingOlderItems == NO) {
        self.isLoadingOlderItems = YES;
        
        // Need to add images here
        
        self.isLoadingOlderItems = NO;
        
        if (completionHandler) {
            completionHandler(nil);
        }
    }
}

#pragma mark - IG API

+ (NSString *) instagramClientID {
    return @"1d4d1989c2004d5aa4a39fa383e8a382";
}

- (void) registerForAccessTokenNotification {
    [[NSNotificationCenter defaultCenter] addObserverForName:BLCLoginViewControllerDidGetAccessTokenNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
        self.accessToken = note.object;
        
        [self populateDataWithParameters:nil];
    }];
}

#pragma mark - Data call from the IG API

- (void) populateDataWithParameters:(NSDictionary *)parameters {
    if (self.accessToken) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            NSMutableString *urlString = [NSMutableString stringWithFormat:@"https://api.instagram.com/v1/users/self/feed?access_token=%@", self.accessToken];
            
            for (NSString *parameterName in parameters) {
                [urlString appendFormat:@"&%@=%@", parameterName, parameters[parameterName]];
            }
            
            NSURL *url = [NSURL URLWithString:urlString];
            
            if (url) {
                NSURLRequest *request = [NSURLRequest requestWithURL:url];
                
                NSURLResponse *response;
                NSError *webError;
                NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&webError];
                
                NSError *jsonError;
                NSDictionary *feedDictionary = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:&jsonError];
                
                if (feedDictionary) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self parseDataFromFeedDictionary:feedDictionary fromRequestWithParameters:parameters];
                    });
                }
            }
        });
    }
}

- (void) parseDataFromFeedDictionary:(NSDictionary *) feedDictionary fromRequestWithParameters:(NSDictionary *)parameters {
    NSArray *mediaArray = feedDictionary[@"data"];
    
    NSMutableArray *tmpMediaItems = [NSMutableArray array];
    
    for (NSDictionary *mediaDictionary in mediaArray) {
        BLCMedia *mediaItem = [[BLCMedia alloc] initWithDictionary:mediaDictionary];
        
        if (mediaItem) {
            [tmpMediaItems addObject:mediaItem];
            [self downloadImageForMediaItem:mediaItem];
        }
    }
    
    [self willChangeValueForKey:@"mediaItems"];
    self.mediaItems = tmpMediaItems;
    [self didChangeValueForKey:@"mediaItems"];
}

- (void) downloadImageForMediaItem:(BLCMedia *)mediaItem {
    if (mediaItem.mediaURL && !mediaItem.image) {
        dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSURLRequest *request = [NSURLRequest requestWithURL:mediaItem.mediaURL];
            
            NSURLResponse *response;
            NSError *error;
            NSData *imageData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
            
            if (imageData) {
                UIImage *image = [UIImage imageWithData:imageData];
                
                if (image) {
                    mediaItem.image = image;
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        NSMutableArray *mutableArrayWithKVO = [self mutableArrayValueForKey:@"mediaItems"];
                        NSUInteger index = [mutableArrayWithKVO indexOfObject:mediaItem];
                        [mutableArrayWithKVO replaceObjectAtIndex:index withObject:mediaItem];
                    });
                }
            } else {
                NSLog(@"Error downloading image: %@", error);
            }
        });
    }
}


@end

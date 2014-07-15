//
//  BLCDataSource.h
//  Blocstagram
//
//  Created by Jordan Hudgens on 7/10/14.
//  Copyright (c) 2014 Jordan Hudgens. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BLCMedia;

@interface BLCDataSource : NSObject

+ (instancetype) sharedInstance;

@property (nonatomic, strong) NSMutableArray *mediaItems;

- (void) deleteMediaItem:(BLCMedia *)item;

@end

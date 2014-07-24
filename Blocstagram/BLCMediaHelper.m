//
//  BLCMediaHelper.m
//  Blocstagram
//
//  Created by Jordan Hudgens on 7/24/14.
//  Copyright (c) 2014 Jordan Hudgens. All rights reserved.
//

#import "BLCMediaHelper.h"

@implementation BLCMediaHelper

+ (void) mediaItemToShare:(UIViewController*) viewController withMedia:(BLCMedia*)media{
    
    NSMutableArray *itemsToShare = [NSMutableArray array];
    
    if (media.caption.length > 0) {
        [itemsToShare addObject:media.caption];
    }
    
    if (media.image) {
        [itemsToShare addObject:media.image];
    }
    
    if (itemsToShare.count > 0) {
        UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:itemsToShare applicationActivities:nil];
        [viewController presentViewController:activityVC animated:YES completion:nil];
    }
    
}

@end

//
//  BLCImagesTableViewController.m
//  Blocstagram
//
//  Created by Jordan Hudgens on 7/9/14.
//  Copyright (c) 2014 Jordan Hudgens. All rights reserved.
//

#import "BLCImagesTableViewController.h"
#import "BLCDataSource.h"
#import "BLCMedia.h"
#import "BLCUser.h"
#import "BLCComment.h"
#import "BLCMediaTableViewCell.h"

@interface BLCImagesTableViewController ()

//@property (nonatomic, strong) BLCDataSource *items;

@end

@implementation BLCImagesTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        
//        [BLCDataSource sharedInstance].mediaItems = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[BLCDataSource sharedInstance] addObserver:self forKeyPath:@"mediaItems" options:0 context:nil];
    
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.title = @"Intagram Feed";
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(refreshControlDidFire:) forControlEvents:UIControlEventValueChanged];
    
    [self.tableView registerClass:[BLCMediaTableViewCell class] forCellReuseIdentifier:@"mediaCell"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self items].count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BLCMediaTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mediaCell" forIndexPath:indexPath];
    cell.mediaItem = [BLCDataSource sharedInstance].mediaItems[indexPath.row];
    
    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    BLCMedia *item = [self items][indexPath.row];
    return [BLCMediaTableViewCell heightForMediaItem:item width:CGRectGetWidth(self.view.frame)];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        BLCMedia *item = [BLCDataSource sharedInstance].mediaItems[indexPath.row];
        [[BLCDataSource sharedInstance] deleteMediaItem:item];
    }
}

- (NSMutableArray *) items {
    return [BLCDataSource sharedInstance].mediaItems;
}

- (void) dealloc
{
    [[BLCDataSource sharedInstance] removeObserver:self forKeyPath:@"mediaItems"];
}

- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (object == [BLCDataSource sharedInstance] && [keyPath isEqualToString:@"mediaItems"]) {
        int kindOfChange = [change[NSKeyValueChangeKindKey] intValue];
        
        if (kindOfChange == NSKeyValueChangeSetting) {
            [self.tableView reloadData];
        } else if (kindOfChange == NSKeyValueChangeInsertion || kindOfChange == NSKeyValueChangeRemoval || kindOfChange == NSKeyValueChangeReplacement) {
            NSIndexSet *indexSetOfChanges = change[NSKeyValueChangeIndexesKey];
            NSMutableArray *indexPathsThatChanged = [NSMutableArray array];
            [indexSetOfChanges enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
                NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:idx inSection:0];
                [indexPathsThatChanged addObject:newIndexPath];
            }];
            
            [self.tableView beginUpdates];
            
            if (kindOfChange == NSKeyValueChangeInsertion) {
                [self.tableView insertRowsAtIndexPaths:indexPathsThatChanged withRowAnimation:UITableViewRowAnimationAutomatic];
            } else if (kindOfChange == NSKeyValueChangeRemoval) {
                [self.tableView deleteRowsAtIndexPaths:indexPathsThatChanged withRowAnimation:UITableViewRowAnimationAutomatic];
            } else if (kindOfChange == NSKeyValueChangeReplacement) {
                [self.tableView reloadRowsAtIndexPaths:indexPathsThatChanged withRowAnimation:UITableViewRowAnimationAutomatic];
            }
            
            [self.tableView endUpdates];
        }
    }
}

#pragma mark - Pull to refresh

- (void) refreshControlDidFire:(UIRefreshControl *) sender {
    [[BLCDataSource sharedInstance] requestNewItemsWithCompletionHandler:^(NSError *error) {
        [sender endRefreshing];
    }];
}

#pragma mark - Infinite scroll

- (void) infiniteScrollIfNecessary {
    NSIndexPath *bottomIndexPath = [[self.tableView indexPathsForVisibleRows] lastObject];
    
    if (bottomIndexPath && bottomIndexPath.row == [BLCDataSource sharedInstance].mediaItems.count - 1) {
        [[BLCDataSource sharedInstance] requestOldItemsWithCompletionHandler:nil];
    }
}

#pragma mark - Infinite scroll view delegate

-(void) scrollViewDidScroll:(UIScrollView*)scrollView{

    if ( scrollView.contentOffset.y >= scrollView.contentSize.height - scrollView.bounds.size.height ) {
        [self infiniteScrollIfNecessary];
    }
}

- (CGFloat) tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    BLCMedia *item = [BLCDataSource sharedInstance].mediaItems[indexPath.row];
    if (item.image) {
        return 350;
    } else {
        return 150;
    }
}

@end

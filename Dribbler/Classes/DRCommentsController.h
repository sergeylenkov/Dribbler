//
//  DRCommentsControllerViewController.h
//  Dribbler
//
//  Created by Sergey Lenkov on 23.12.12.
//  Copyright (c) 2012 Sergey Lenkov. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "AFNetworking.h"

@interface DRCommentsController : NSViewController {
    NSMutableArray *_comments;
    NSInteger currentPage;
    NSInteger totalPages;
    NSInteger y;
}

@property (assign) IBOutlet NSScrollView *scrollView;
@property (assign) IBOutlet NSView *contentView;
@property (assign) NSInteger shotID;

- (void)refresh;

@end

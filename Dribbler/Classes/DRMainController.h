//
//  DRMainController.h
//  Dribbler
//
//  Created by Sergey Lenkov on 17.12.12.
//  Copyright (c) 2012 Sergey Lenkov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "DRScrollView.h"
#import "DRCollectionItemView.h"
#import "DRCollectionView.h"
#import "DRShot.h"
#import "DRCommentsController.h"

@interface DRMainController : NSObject <DRScrollViewDelegate, DRCollectionViewDelegate> {
    NSMutableArray *_shots;
    NSString *currentList;
    NSInteger currentPage;
    NSInteger totalPages;
    NSInteger lastPage;
    DRCommentsController *commentsController;
    BOOL isLoading;
}

@property (strong) IBOutlet DRScrollView *scrollView;
@property (strong) IBOutlet DRCollectionView *imagesView;
@property (strong) IBOutlet NSSegmentedControl *listTypeSegment;
@property (strong) IBOutlet NSView *loadingView;
@property (strong) IBOutlet NSProgressIndicator *loadingIndicator;

- (void)refresh;

@end

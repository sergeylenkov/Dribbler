//
//  DRThumbView.h
//  Dribbler
//
//  Created by Sergey Lenkov on 19.12.12.
//  Copyright (c) 2012 Sergey Lenkov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DRItemDetailsView.h"

@class DRCollectionItemView;

@protocol DRCollectionItemViewDelegate <NSObject>

- (void)collectionItemViewDidSelect:(DRCollectionItemView *)view;

@end

@interface DRCollectionItemView : NSView {
    NSTrackingArea *trackingArea;
    DRItemDetailsView *detailsView;
    NSProgressIndicator *progressIndicator;
}

@property (strong) NSImage *image;
@property (assign) id object;
@property (assign) id <DRCollectionItemViewDelegate> delegate;

- (void)stopIndicator;

@end

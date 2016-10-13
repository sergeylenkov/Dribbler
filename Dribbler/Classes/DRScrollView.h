//
//  DRScrollView.h
//  Dribbler
//
//  Created by Sergey Lenkov on 22.12.12.
//  Copyright (c) 2012 Sergey Lenkov. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class DRScrollView;

@protocol DRScrollViewDelegate <NSObject>

- (void)scrollViewDidScrollToBottom:(DRScrollView *)scrollView;

@end

@interface DRScrollView : NSScrollView

@property (assign) id <DRScrollViewDelegate> delegate;

@end

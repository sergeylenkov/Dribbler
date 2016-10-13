//
//  DRScrollView.m
//  Dribbler
//
//  Created by Sergey Lenkov on 22.12.12.
//  Copyright (c) 2012 Sergey Lenkov. All rights reserved.
//

#import "DRScrollView.h"

@implementation DRScrollView

@synthesize delegate;

- (void)scrollClipView:(NSClipView *)aClipView toPoint:(NSPoint)aPoint {
    [super scrollClipView:aClipView toPoint:aPoint];
    
    if (aPoint.y + self.frame.size.height == [self.documentView frame].size.height) {
        //NSLog(@"%f %f", aPoint.y + self.frame.size.height, [self.documentView frame].size.height);
        if (delegate && [delegate respondsToSelector:@selector(scrollViewDidScrollToBottom:)]) {
            [delegate scrollViewDidScrollToBottom:self];
        }
    }
}

@end

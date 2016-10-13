//
//  DRShadowView.m
//  Dribbler
//
//  Created by Sergey Lenkov on 19.01.13.
//  Copyright (c) 2013 Sergey Lenkov. All rights reserved.
//

#import "DRShadowView.h"

@implementation DRShadowView

- (void)drawRect:(NSRect)dirtyRect {
    [[NSColor colorWithCalibratedRed:0.0 green:0.0 blue:0.0 alpha:1.0] setFill];
    NSRectFill(self.bounds);
}

@end

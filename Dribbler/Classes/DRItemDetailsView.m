//
//  DRItemDetailsView.m
//  Dribbler
//
//  Created by Sergey Lenkov on 22.12.12.
//  Copyright (c) 2012 Sergey Lenkov. All rights reserved.
//

#import "DRItemDetailsView.h"

@implementation DRItemDetailsView

- (void)drawRect:(NSRect)dirtyRect {
    NSColor *color = [NSColor colorWithDeviceRed:0.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:1.0];
    [color set];
    
    NSRectFill(self.bounds);
    
    NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    [paragraphStyle setAlignment:NSLeftTextAlignment];
    
    NSFontManager *fontManager = [NSFontManager sharedFontManager];
    NSFont *font = [fontManager fontWithFamily:@"Helvetica Neue" traits:NSBoldFontMask weight:0 size:12];
    
    color = [NSColor colorWithDeviceRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0];
    
    NSDictionary *attsDict = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName,
                              color, NSForegroundColorAttributeName, 
                              paragraphStyle, NSParagraphStyleAttributeName, nil];
    
    [self.views drawInRect:NSMakeRect(40, 10, 40, 18) withAttributes:attsDict];
    [self.likes drawInRect:NSMakeRect(100, 10, 40, 18) withAttributes:attsDict];
    [self.comments drawInRect:NSMakeRect(140, 10, 40, 18) withAttributes:attsDict];
}

@end

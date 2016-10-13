//
//  DRAppDelegate.m
//  Dribbler
//
//  Created by Sergey Lenkov on 17.12.12.
//  Copyright (c) 2012 Sergey Lenkov. All rights reserved.
//

#import "DRAppDelegate.h"

@implementation DRAppDelegate

@synthesize mainController;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    [mainController refresh];
}

@end

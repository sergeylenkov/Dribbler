//
//  DRAppDelegate.h
//  Dribbler
//
//  Created by Sergey Lenkov on 17.12.12.
//  Copyright (c) 2012 Sergey Lenkov. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "DRMainController.h"

@interface DRAppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;
@property (strong) IBOutlet DRMainController *mainController;

@end

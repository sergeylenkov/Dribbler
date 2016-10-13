//
//  DRShot.h
//  Dribbler
//
//  Created by Sergey Lenkov on 19.12.12.
//  Copyright (c) 2012 Sergey Lenkov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DRShot : NSObject

@property (assign) NSInteger identifier;
@property (strong) NSString *name;
@property (assign) NSInteger likesCount;
@property (assign) NSInteger viewsCount;
@property (assign) NSInteger commentsCount;
@property (assign) NSInteger rebounbsCount;
@property (strong) NSURL *imageURL;
@property (strong) NSImage *image;

@end

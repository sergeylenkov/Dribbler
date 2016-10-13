//
//  DRThumbView.m
//  Dribbler
//
//  Created by Sergey Lenkov on 19.12.12.
//  Copyright (c) 2012 Sergey Lenkov. All rights reserved.
//

#import "DRCollectionItemView.h"
#import "DRShot.h"

@implementation DRCollectionItemView

@synthesize image;
@synthesize object;
@synthesize delegate;

- (void)dealloc {
    [self removeTrackingArea:trackingArea];
}

- (id)initWithFrame:(NSRect)frameRect {
    self = [super initWithFrame:frameRect];
    
    if (self) {
        [self registerForDraggedTypes:[NSImage imagePasteboardTypes]];
        
        detailsView = [[DRItemDetailsView alloc] initWithFrame:NSMakeRect(0, frameRect.size.height - 60, frameRect.size.width, 60)];
        detailsView.alphaValue = 0.0;
        [self addSubview:detailsView];
        
        progressIndicator = [[NSProgressIndicator alloc] initWithFrame:NSMakeRect(frameRect.size.width / 2 - 10, frameRect.size.height / 2 - 10, 20, 20)];
        [progressIndicator setStyle:NSProgressIndicatorSpinningStyle];
        //[progressIndicator setUsesThreadedAnimation:YES];
        [progressIndicator setDisplayedWhenStopped:NO];
        [progressIndicator setIndeterminate:YES];
        [progressIndicator startAnimation:nil];
        
        [self addSubview:progressIndicator];
    }
    
    return self;
}

- (void)stopIndicator {
    [progressIndicator stopAnimation:nil];
}

- (void)setObject:(id)aObject {
    object = aObject;
    DRShot *shot = (DRShot *)object;
    
    detailsView.likes = [NSString stringWithFormat:@"%ld", shot.likesCount];
    detailsView.views = [NSString stringWithFormat:@"%ld", shot.viewsCount];
    detailsView.comments = [NSString stringWithFormat:@"%ld", shot.commentsCount];
}

- (id)object {
    return object;
}

- (void)setFrame:(NSRect)frameRect {
    [super setFrame:frameRect];
    
    [self removeTrackingArea:trackingArea];
    
    NSTrackingAreaOptions trackingOptions =	NSTrackingMouseMoved | NSTrackingMouseEnteredAndExited | NSTrackingActiveInActiveApp;
    
    trackingArea = [[NSTrackingArea alloc] initWithRect:[self bounds] options:trackingOptions owner:self userInfo:nil];
    [self addTrackingArea:trackingArea];
    
    detailsView.frame = NSMakeRect(10, frameRect.size.height - 60, frameRect.size.width - 20, 50);
    
    progressIndicator.frame = NSMakeRect(frameRect.size.width / 2 - 10, frameRect.size.height / 2 - 10, 20, 20);
}

- (void)mouseDragged:(NSEvent *)event {
    [self dragPromisedFilesOfTypes:[NSArray arrayWithObject:NSPasteboardTypeTIFF] fromRect:self.frame source:self slideBack:YES event:event];
}

- (void)mouseDown:(NSEvent *)event {
    //
}

- (void)mouseUp:(NSEvent *)event {
    if (delegate && [delegate respondsToSelector:@selector(collectionItemViewDidSelect:)]) {
        [delegate collectionItemViewDidSelect:self];
    }
}

- (void)mouseEntered:(NSEvent *)event {
    [detailsView.animator setAlphaValue:0.8];
}

- (void)mouseExited:(NSEvent *)event {
    [detailsView.animator setAlphaValue:0.0];
}

- (void)dragImage:(NSImage *)anImage at:(NSPoint)viewLocation offset:(NSSize)initialOffset event:(NSEvent *)event pasteboard:(NSPasteboard *)pboard source:(id)sourceObj slideBack:(BOOL)slideFlag {
    NSImage *dragImage = [[NSImage alloc] initWithSize:self.image.size];

    [dragImage lockFocus];
    [self.image dissolveToPoint:NSZeroPoint fraction:0.5];
    [dragImage unlockFocus];

    [dragImage setScalesWhenResized:YES];
    [dragImage setSize:self.frame.size];

    [super dragImage:dragImage at:NSMakePoint(0, self.frame.size.height) offset:NSZeroSize event:event pasteboard:pboard source:sourceObj slideBack:slideFlag];
}

- (NSArray *)namesOfPromisedFilesDroppedAtDestination:(NSURL *)dropDestination {
    NSString *name = [object name];
    
    NSArray *representations = [self.image representations];
    
    NSData *bitmapData = [NSBitmapImageRep representationOfImageRepsInArray:representations usingType:NSPNGFileType properties:nil];
    [bitmapData writeToFile:[[dropDestination path] stringByAppendingPathComponent:[name stringByAppendingPathExtension:@"png"]] atomically:YES];
        
    return [NSArray arrayWithObjects:[name stringByAppendingPathExtension:@"png"], nil];
}

- (NSDragOperation)draggingSession:(NSDraggingSession *)session sourceOperationMaskForDraggingContext:(NSDraggingContext)context {
    return NSDragOperationCopy;
}

- (BOOL)acceptsFirstResponder {
    return YES;
}

- (void)drawRect:(NSRect)dirtyRect {
    NSDrawNinePartImage(self.bounds, [NSImage imageNamed:@"LeftTopEnd"], [NSImage imageNamed:@"TopEnd"], [NSImage imageNamed:@"RightTopEnd"],
                        [NSImage imageNamed:@"LeftMiddleEnd"], [NSImage imageNamed:@"CenterMiddle"], [NSImage imageNamed:@"RightMiddleEnd"],
                        [NSImage imageNamed:@"LeftBottomEnd"], [NSImage imageNamed:@"BottomEnd"], [NSImage imageNamed:@"RightBottomEnd"], NSCompositeSourceOver, 1.0, self.isFlipped);
    
    NSRect rect = NSMakeRect(10, 8, self.bounds.size.width - 20, self.bounds.size.height - 20);
    [self.image drawInRect:rect fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0 respectFlipped:self.isFlipped hints:nil];
}

- (BOOL)isFlipped {
    return YES;
}

@end

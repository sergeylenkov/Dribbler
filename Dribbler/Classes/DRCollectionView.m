//
//  DRCollectionView.m
//  Dribbler
//
//  Created by Sergey Lenkov on 19.12.12.
//  Copyright (c) 2012 Sergey Lenkov. All rights reserved.
//

#import "DRCollectionView.h"

@implementation DRCollectionView

@synthesize maxCellSize;
@synthesize minCellSize;
@synthesize offset;
@synthesize maxCellSpace;
@synthesize minCellSpace;
@synthesize delegate;

- (id)initWithFrame:(NSRect)frameRect {
    self = [super initWithFrame:frameRect];
    
    if (self) {
        _thumbs = [[NSMutableArray alloc] init];
        _expandedThumbs = [[NSMutableArray alloc] init];
        isExpandItems = NO;
    }
    
    return self;
}

- (void)clear {
    [_thumbs makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [_thumbs removeAllObjects];
}

- (void)addItem:(id)object {
    DRCollectionItemView *thumbView = [[DRCollectionItemView alloc] initWithFrame:NSMakeRect(0, 0, 0, 0)];
    thumbView.object = object;
    thumbView.delegate = self;
    
    [self addSubview:thumbView];
    [_thumbs addObject:thumbView];
    
    [self resizeGrid];
}

- (void)setImage:(NSImage *)image atIndex:(NSInteger)index {
    DRCollectionItemView *thumbView = [_thumbs objectAtIndex:index];
    thumbView.image = image;
    
    [thumbView stopIndicator];
    [thumbView setNeedsDisplay:YES];
}

- (void)resizeGrid {
    int cellsInRow = (self.frame.size.width - (offset.x * 2)) / maxCellSize.width;
    int x = offset.x;
    int y = offset.y;
    int column = 0;
    int row = 0;
    int width = maxCellSize.width;
    int height = maxCellSize.height;
    int index = 0;
    int offsetX = minCellSpace.x;
    
    offsetX = (self.frame.size.width - (width * cellsInRow)) / (cellsInRow + 1);
    currentOffset = offsetX;
    x = offsetX;

    for (DRCollectionItemView *thumbView in _thumbs) {
        thumbView.frame = NSMakeRect(x, y, width, height);
        
        x = x + width + offsetX;
        column++;
        index++;
        if (column == cellsInRow && index < [_thumbs count]) {
            column = 0;
            row++;
            x = offsetX;
            y = y + height + minCellSpace.y;
        }
    }
    
    [self setFrameSize:NSMakeSize(self.frame.size.width, y + height + offset.y)];
}

- (void)setFrame:(NSRect)frameRect {
    [super setFrame:frameRect];
    [self resizeGrid];
}

- (BOOL)isFlipped {
    return YES;
}

- (void)collectionItemViewDidSelect:(DRCollectionItemView *)view {
    isExpandItems = !isExpandItems;
    
    if (isExpandItems) {
        DRShadowView *backgroundView = [[DRShadowView alloc] initWithFrame:self.bounds];
        backgroundView.alphaValue = 0.5;
        [self addSubview:backgroundView];
        
        [_expandedThumbs removeAllObjects];
        
        expandToRight = YES;

        if (view.frame.origin.x + DR_EXPAND_WIDTH + (currentOffset * 2) > self.frame.size.width) {
            expandToRight = NO;
        }
        
        [NSAnimationContext beginGrouping];
        [[NSAnimationContext currentContext] setDuration:0.3];
        
        for (DRCollectionItemView *thumbView in _thumbs) {
            NSRect frame = thumbView.frame;
            
            if (expandToRight) {
                if (thumbView.frame.origin.x > view.frame.origin.x) {
                    frame.origin.x = frame.origin.x + DR_EXPAND_WIDTH;
                    
                    [thumbView.animator setFrame:frame];
                    [_expandedThumbs addObject:thumbView];
                }
            } else {
                if (thumbView.frame.origin.x < view.frame.origin.x) {
                    frame.origin.x = frame.origin.x - DR_EXPAND_WIDTH;
                    
                    [thumbView.animator setFrame:frame];
                    [_expandedThumbs addObject:thumbView];
                }
            }
        }
        
        [NSAnimationContext endGrouping];
    } else {
        [NSAnimationContext beginGrouping];
        [[NSAnimationContext currentContext] setDuration:0.3];
        
        for (DRCollectionItemView *thumbView in _expandedThumbs) {
            NSRect frame = thumbView.frame;
            
            if (expandToRight) {
                frame.origin.x = frame.origin.x - DR_EXPAND_WIDTH;
            } else {
                frame.origin.x = frame.origin.x + DR_EXPAND_WIDTH;
            }
            
            [thumbView.animator setFrame:frame];
        }
        
        [NSAnimationContext endGrouping];
    }
    
    NSRect rect = NSMakeRect(view.frame.origin.x + view.frame.size.width, 0, DR_EXPAND_WIDTH, self.frame.size.height);
    
    if (!expandToRight) {
        rect.origin.x = view.frame.origin.x - DR_EXPAND_WIDTH;
    }
    
    if (isExpandItems) {
        if (delegate && [delegate respondsToSelector:@selector(collectionView: didExpandItem: rect:)]) {
            [delegate collectionView:self didExpandItem:view rect:rect];
        }
    } else {
        if (delegate && [delegate respondsToSelector:@selector(collectionView: didCollapseItem: rect:)]) {
            [delegate collectionView:self didCollapseItem:view rect:rect];
        }
    }
}

@end

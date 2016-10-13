//
//  DRCollectionView.h
//  Dribbler
//
//  Created by Sergey Lenkov on 19.12.12.
//  Copyright (c) 2012 Sergey Lenkov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DRCollectionItemView.h"
#import "DRShadowView.h"

typedef struct _DROffset {
    CGFloat x;
    CGFloat y;
} DROffset;

NS_INLINE DROffset DRMakeOffset(CGFloat x, CGFloat y) {
    DROffset o;
    o.x = x;
    o.y = y;
    return o;
}

typedef struct _DRCellSpace {
    CGFloat x;
    CGFloat y;
} DRCellSpace;

NS_INLINE DRCellSpace DRMakeCellSpace(CGFloat x, CGFloat y) {
    DRCellSpace o;
    o.x = x;
    o.y = y;
    return o;
}

@class DRCollectionView;

@protocol DRCollectionViewDelegate <NSObject>

- (void)collectionView:(DRCollectionView *)view didExpandItem:(DRCollectionItemView *)item rect:(NSRect)rect;
- (void)collectionView:(DRCollectionView *)view didCollapseItem:(DRCollectionItemView *)item rect:(NSRect)rect;

@end

@interface DRCollectionView : NSView <DRCollectionItemViewDelegate> {
    NSMutableArray *_thumbs;
    NSMutableArray *_expandedThumbs;
    BOOL isExpandItems;
    BOOL expandToRight;
    int currentOffset;
}

@property (assign) NSSize maxCellSize;
@property (assign) NSSize minCellSize;
@property (assign) DROffset offset;
@property (assign) DRCellSpace maxCellSpace;
@property (assign) DRCellSpace minCellSpace;
@property (assign) id <DRCollectionViewDelegate> delegate;

- (void)clear;
- (void)addItem:(id)object;
- (void)setImage:(NSImage *)image atIndex:(NSInteger)index;

@end

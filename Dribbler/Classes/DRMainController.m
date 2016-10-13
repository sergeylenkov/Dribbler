//
//  DRMainController.m
//  Dribbler
//
//  Created by Sergey Lenkov on 17.12.12.
//  Copyright (c) 2012 Sergey Lenkov. All rights reserved.
//

#import "DRMainController.h"

@implementation DRMainController

@synthesize scrollView;
@synthesize imagesView;
@synthesize listTypeSegment;
@synthesize loadingView;
@synthesize loadingIndicator;

- (void)awakeFromNib {
    _shots = [[NSMutableArray alloc] init];
    
    imagesView.maxCellSize = NSMakeSize(400, 300);
    imagesView.minCellSize = NSMakeSize(200, 150);
    imagesView.offset = DRMakeOffset(20, 20);
    imagesView.maxCellSpace = DRMakeCellSpace(20, 20);
    imagesView.minCellSpace = DRMakeCellSpace(10, 10);
    
    currentList = DR_CATEGORY_POPULAR;
    
    imagesView.frame = scrollView.bounds;
    [scrollView setDocumentView:imagesView];
    
    imagesView.delegate = self;
    scrollView.delegate = self;
    
    commentsController = [[DRCommentsController alloc] initWithNibName:@"CommentsView" bundle:nil];
    [commentsController loadView];
}

- (void)refresh {
    [_shots removeAllObjects];
    [imagesView clear];
    
    currentPage = 1;
    
    NSRect frame = imagesView.frame;
    frame.size.height = 0;
    imagesView.frame = frame;
    
    [self loadPage];
}

- (void)loadPage {
    NSRect rect = loadingView.frame;
    rect.origin.x = (scrollView.frame.size.width / 2) - (rect.size.width / 2);
    rect.origin.y = (scrollView.frame.size.height / 2) - (rect.size.height / 2);
    loadingView.frame = rect;
    
    [scrollView addSubview:loadingView];
    
    [loadingIndicator startAnimation:nil];
    
    isLoading = YES;
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@shots/%@?per_page=%d&page=%ld", DR_API_URL, currentList, DR_ITEMS_PER_PAGE, currentPage]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSLog(@"%@", url);
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                                                        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                                                                            totalPages = [[JSON objectForKey:@"pages"] integerValue];
                                                                                            currentPage++;
                                                                                            
                                                                                            [self loadImages:[JSON objectForKey:@"shots"]];
                                                                                        }
                                         
                                                                                        failure:nil];
    
    [operation start];
}

- (void)loadImages:(id)shots {
    for (id shot in shots) {
        DRShot *_shot = [[DRShot alloc] init];
        
        _shot.identifier = [[shot objectForKey:@"id"] integerValue];
        _shot.name = [shot objectForKey:@"title"];
        _shot.likesCount = [[shot objectForKey:@"likes_count"] integerValue];
        _shot.viewsCount = [[shot objectForKey:@"views_count"] integerValue];
        _shot.commentsCount = [[shot objectForKey:@"comments_count"] integerValue];
        _shot.rebounbsCount = [[shot objectForKey:@"rebounds_count"] integerValue];
        _shot.imageURL = [NSURL URLWithString:[shot objectForKey:@"image_url"]];
        
        [_shots addObject:_shot];
        
        [imagesView addItem:_shot];
    }
    
    [loadingView removeFromSuperview];
    [loadingIndicator stopAnimation:nil];
    
    isLoading = NO;
    
    for (DRShot *shot in _shots) {
        NSArray *writablePaths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        NSString *cachePath = [[writablePaths lastObject] stringByAppendingPathComponent:[[NSBundle mainBundle] bundleIdentifier]];
        
        NSString *filePath = [cachePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%ld.png", shot.identifier]];
        
        if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
            NSImage *image = [[NSImage alloc] initWithContentsOfFile:filePath];
            [imagesView setImage:image atIndex:[_shots indexOfObject:shot]];
        } else {
            [self loadImageForShot:shot];
        }
    }
}

- (void)loadImageForShot:(DRShot *)shot {
    NSInteger index = [_shots indexOfObject:shot];
    AFImageRequestOperation *operation = [AFImageRequestOperation imageRequestOperationWithRequest:[NSURLRequest requestWithURL:shot.imageURL]
                                                                              imageProcessingBlock:nil
                                                                                           success:^(NSURLRequest *request, NSHTTPURLResponse *response, NSImage *image) {
                                                                                               shot.image = image;
                                                                                               [imagesView setImage:image atIndex:index];
                                                                                               
                                                                                               NSArray *writablePaths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
                                                                                               NSString *cachePath = [[writablePaths lastObject] stringByAppendingPathComponent:[[NSBundle mainBundle] bundleIdentifier]];
                                                                                               
                                                                                               NSString *filePath = [cachePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%ld.png", shot.identifier]];
                                                                                            
                                                                                               [request.HTTPBody writeToFile:filePath atomically:YES];
                                                                                           }
                                                                                           failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                                                                           }];
    [operation start];
}

- (void)scrollViewDidScrollToBottom:(DRScrollView *)scrollView {
    NSLog(@"SCROLL");
    if (!isLoading && currentPage < totalPages) {
        [self loadPage];
    }
}

- (void)collectionView:(DRCollectionView *)view didExpandItem:(DRCollectionItemView *)item rect:(NSRect)rect {
    DRShot *shot = (DRShot *)item.object;
    commentsController.view.frame = rect;
    
    [self performSelector:@selector(showComments:) withObject:shot afterDelay:0.2];
}

- (void)collectionView:(DRCollectionView *)view didCollapseItem:(DRCollectionItemView *)item rect:(NSRect)rect {
    [commentsController.view removeFromSuperview];
}

- (void)showComments:(DRShot *)shot {
    commentsController.view.alphaValue = 0.0;
    [scrollView addSubview:commentsController.view];
    
    commentsController.shotID = shot.identifier;
    [commentsController refresh];
    
    [NSAnimationContext beginGrouping];
    [[NSAnimationContext currentContext] setDuration:0.3];
    
    [commentsController.view.animator setAlphaValue:1.0];
    
    [NSAnimationContext endGrouping];
}

#pragma mark -
#pragma mark IBAction
#pragma mark -

- (IBAction)listTypeDidChanged:(id)sender {
    switch (listTypeSegment.selectedSegment) {
        case 0:
            currentList = DR_CATEGORY_POPULAR;
            break;
        case 1:
            currentList = DR_CATEGORY_EVERYONE;
            break;
        case 2:
            currentList = DR_CATEGORY_DEBUTS;
            break;
        default:
            currentList = DR_CATEGORY_POPULAR;
            break;
    }

    [self refresh];
}

@end

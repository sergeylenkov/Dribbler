//
//  DRCommentsControllerViewController.m
//  Dribbler
//
//  Created by Sergey Lenkov on 23.12.12.
//  Copyright (c) 2012 Sergey Lenkov. All rights reserved.
//

#import "DRCommentsController.h"
#import "NSTextView+AutomaticLinkDetection.h"
#import "NSAttributedString+Geometrics.h"

@implementation DRCommentsController

@synthesize scrollView;
@synthesize contentView;
@synthesize shotID;

- (void)awakeFromNib {
    _comments = [[NSMutableArray alloc] init];
    [scrollView setDocumentView:contentView];
}

- (void)refresh {
    [_comments removeAllObjects];
    [contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    currentPage = 1;
    y = 20;
    
    [self loadPage];
}

- (void)loadPage {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@shots/%ld/comments?per_page=%d&page=%ld", DR_API_URL, shotID, DR_ITEMS_PER_PAGE, currentPage]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                                                        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                                                                            //NSLog(@"%@", JSON);
                                                                                            totalPages = [[JSON objectForKey:@"pages"] integerValue];
                                                                                            currentPage++;
                                                                                            
                                                                                            [self addComments:[JSON objectForKey:@"comments"]];
                                                                                        }
                                         
                                                                                        failure:nil];
    
    [operation start];
}

- (void)addComments:(NSArray *)comments {
    NSDictionary *attsDict = [NSDictionary dictionaryWithObjectsAndKeys:[NSColor colorWithDeviceRed:40.0/255.0 green:40.0/255.0 blue:40.0/255.0 alpha:1.0], NSForegroundColorAttributeName,
                              [NSFont fontWithName:@"Helvetica" size:12], NSFontAttributeName, nil];
    
    for (NSDictionary *comment in comments) {
        //NSLog(@"%@", comment);
        NSString *text = [comment objectForKey:@"body"];
        
        int height = [text heightForWidth:contentView.frame.size.width - 20 attributes:attsDict];
        
        NSTextView *textView = [[NSTextView alloc] initWithFrame:NSMakeRect(10, y, contentView.frame.size.width - 20, height)];
        
        [textView setEditable:NO];
        [textView setSelectable:YES];
        [textView setBackgroundColor:[NSColor clearColor]];
        [textView setTextContainerInset:NSMakeSize(0, 0)];
        [textView setFont:[NSFont fontWithName:@"Helvetica" size:12]];
        
        NSMutableAttributedString *attributedStatusString = [[NSMutableAttributedString alloc] initWithString:text];
        [attributedStatusString addAttributes:attsDict range:NSMakeRange(0, text.length)];
        
        [[textView textStorage] setAttributedString:attributedStatusString];
        
        [textView detectAndAddLinks];
        
        [contentView addSubview:textView];
        
        y = y + height + 20;
    }
    
    contentView.frame = NSMakeRect(0, 0, scrollView.frame.size.width, y);
    
    if (currentPage < totalPages) {
        [self loadPage];
    }
}

@end

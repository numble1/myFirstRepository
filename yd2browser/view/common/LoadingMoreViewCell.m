//
//  LoadingMoreViewCell.m
//  ddemtion
//
//  Created by yunfenghan Ling on 16/3/15.
//  Copyright © 2016年 lingyfh. All rights reserved.
//

#import "LoadingMoreViewCell.h"

@interface LoadingMoreViewCell ()
@property (weak, nonatomic) IBOutlet UIView *loadingView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingIndicatorView;
@property (weak, nonatomic) IBOutlet UILabel *loadingLabel;
@property (weak, nonatomic) IBOutlet UIView *noMoreView;
@property (weak, nonatomic) IBOutlet UIView *loadingFailView;

@end

@implementation LoadingMoreViewCell

- (void)startLoading {
    [self showLoadingView:YES];
    [self showLoadFaile:NO];
    [self showNoMore:NO];
}

- (void)noMore {
    [self showNoMore:YES];
    [self showLoadingView:NO];
    [self showLoadFaile:NO];
}

- (void)loadingFaile {
    [self showLoadFaile:YES];
    [self showLoadingView:NO];
    [self showNoMore:NO];
    
}


#pragma mark -

- (void)showLoadingView:(BOOL)show {
    [self.loadingView setHidden:!show];
    if (show) {
        [self.loadingIndicatorView startAnimating];
    } else {
        [self.loadingIndicatorView stopAnimating];
    }
}

- (void)showNoMore:(BOOL)noMore {
    [self.noMoreView setHidden:!noMore];
}

- (void)showLoadFaile:(BOOL)show {
    [self.loadingFailView setHidden:!show];
}

@end

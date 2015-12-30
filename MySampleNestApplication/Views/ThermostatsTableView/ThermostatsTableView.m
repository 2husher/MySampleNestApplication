//
//  ThermostatsTableView.m
//  MySampleNestApplication
//
//  Created by X on 30/12/15.
//  Copyright (c) 2015 Alex Izotov. All rights reserved.
//

#import "ThermostatsTableView.h"

@interface ThermostatsTableView ()

@property (nonatomic, strong) UIView *loadingView;
@property (nonatomic, strong) UIActivityIndicatorView *activity;

@end

@implementation ThermostatsTableView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.loadingView = [self setupLoadingView];

        [self.loadingView setHidden:YES];
        [self.loadingView setAlpha:0.0f];

        [self.activity setHidden:YES];
        [self.activity setAlpha:0.0f];
        [self.activity stopAnimating];
    }
    return self;
}

- (UIView *)setupLoadingView
{
    UIView *view = [[UIView alloc] initWithFrame:self.bounds];
    [view setBackgroundColor:[UIColor blackColor]];
    [view setAlpha:.5f];

    [view.layer setCornerRadius:6.f];
    [view.layer setMasksToBounds:YES];

    self.activity = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(CGRectGetMidX(view.frame), CGRectGetMidY(view.frame), self.activity.frame.size.width, self.activity.frame.size.height)];
    [self.activity setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];

    [view addSubview:self.activity];
    [self addSubview:view];
    return view;
}

- (void)showLoading
{
    [self.activity startAnimating];
    [self.loadingView setHidden:NO];
    [self.activity setHidden:NO];

    [UIView animateWithDuration:.3f animations:^{
        [self.activity setAlpha:0.6f];
        [self.loadingView setAlpha:0.6f];
    }];
}

- (void)hideLoading
{
    [UIView animateWithDuration:.3f animations:^{
        [self.activity setAlpha:0.0f];
        [self.loadingView setAlpha:0.0f];
    } completion:^(BOOL finished){
        [self.loadingView setHidden:YES];
        [self.activity setHidden:YES];
        [self.activity stopAnimating];
    }];
}

- (void)enableView
{
    [self.loadingView setHidden:YES];
    [self.loadingView setAlpha:0.0f];
}

@end

//
//  LoadingView.m
//  MySampleNestApplication
//
//  Created by X on 30/12/15.
//  Copyright (c) 2015 Alex Izotov. All rights reserved.
//

#import "LoadingView.h"

@interface LoadingView ()

@property (nonatomic, strong) UIActivityIndicatorView *activity;

@end

@implementation LoadingView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self = [self setupLoadingView];
    }
    return self;
}

- (LoadingView *)setupLoadingView
{
    self.backgroundColor = [UIColor blackColor];
    self.alpha = 0.5f;

    self.activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.activity.hidden = NO;
    [self addSubview:self.activity];

    self.activity.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *centerX =
    [NSLayoutConstraint constraintWithItem:self.activity
                                 attribute:NSLayoutAttributeCenterX
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self
                                 attribute:NSLayoutAttributeCenterX
                                multiplier:1.0f
                                  constant:0.0f];
    NSLayoutConstraint *centerY =
    [NSLayoutConstraint constraintWithItem:self.activity
                                 attribute:NSLayoutAttributeCenterY
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self
                                 attribute:NSLayoutAttributeCenterY
                                multiplier:1.0f
                                  constant:0.0f];
    [self addConstraints:@[centerX, centerY]];
    return self;
}

- (void)showLoading
{
    [self.activity startAnimating];
    [UIView animateWithDuration:0.4
                     animations:^{
                         self.alpha = 0.5f;
                     }];
}

- (void)hideLoading
{
    [UIView animateWithDuration:0.4
                     animations:^{
                         self.alpha = 0.0f;
                     }];
    [self.activity stopAnimating];
}

@end

//
//  SVModalWebViewController.h
//
//  Created by Oliver Letterer on 13.08.11.
//  Copyright 2011 Home. All rights reserved.
//
//  https://github.com/samvermette/SVWebViewController

#import <UIKit/UIKit.h>

@class SVWebViewController;
@class SVModalWebViewController;

typedef NS_ENUM(NSUInteger, SVWebViewControllerDismissButtonStyle) {
    SVWebViewControllerDismissButtonStyleDone = 0,
    SVWebViewControllerDismissButtonStyleCancel
};

@protocol SVModalWebViewControllerDelegate <UIWebViewDelegate>

@optional
- (void)controllerDidPressDoneButton:(SVModalWebViewController *)controller;

@end

@interface SVModalWebViewController : UINavigationController

- (instancetype)initWithAddress:(NSString*)urlString;
- (instancetype)initWithURL:(NSURL *)URL;
- (instancetype)initWithURLRequest:(NSURLRequest *)request;

@property (nonatomic, readonly) SVWebViewController *webViewController;

@property (nonatomic, strong) UIColor *barsTintColor;
@property (nonatomic, weak) id<SVModalWebViewControllerDelegate> webViewDelegate;
@property (nonatomic, assign) SVWebViewControllerDismissButtonStyle dismissButtonStyle;

@end

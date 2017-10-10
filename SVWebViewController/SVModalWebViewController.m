//
//  SVModalWebViewController.m
//
//  Created by Oliver Letterer on 13.08.11.
//  Copyright 2011 Home. All rights reserved.
//
//  https://github.com/samvermette/SVWebViewController

#import "SVModalWebViewController.h"
#import "SVWebViewController.h"

@interface SVModalWebViewController ()

@property (nonatomic, strong) SVWebViewController *webViewController;
@end

@interface SVWebViewController (DoneButton)

- (void)doneButtonTapped:(id)sender;

@end


@implementation SVModalWebViewController

#pragma mark - Initialization


- (instancetype)initWithAddress:(NSString*)urlString {
    return [self initWithURL:[NSURL URLWithString:urlString]];
}

- (instancetype)initWithURL:(NSURL *)URL {
    return [self initWithURLRequest:[NSURLRequest requestWithURL:URL]];
}

- (instancetype)initWithURLRequest:(NSURLRequest *)request {
    self.webViewController = [[SVWebViewController alloc] initWithURLRequest:request];
    if (self = [super initWithRootViewController:self.webViewController]) {
        [self configureDoneButton];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:NO];
    
    self.webViewController.title = self.title;
    self.navigationBar.tintColor = self.barsTintColor;
}

- (void)configureDoneButton {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad || self.dismissButtonStyle == SVWebViewControllerDismissButtonStyleCancel) {
        self.webViewController.navigationItem.leftBarButtonItem = [self barButtonItemForDismissButtonStyle:self.dismissButtonStyle];
        self.webViewController.navigationItem.rightBarButtonItem = nil;
    }
    else {
        self.webViewController.navigationItem.leftBarButtonItem = nil;
        self.webViewController.navigationItem.rightBarButtonItem = [self barButtonItemForDismissButtonStyle:self.dismissButtonStyle];
    }
}

- (void)setDismissButtonStyle:(SVWebViewControllerDismissButtonStyle)dismissButtonStyle {
    if (_dismissButtonStyle != dismissButtonStyle) {
        _dismissButtonStyle = dismissButtonStyle;
        [self configureDoneButton];
    }
}

- (UIBarButtonItem *)barButtonItemForDismissButtonStyle:(SVWebViewControllerDismissButtonStyle)dismissButtonStyle {
    switch (dismissButtonStyle) {
        case SVWebViewControllerDismissButtonStyleDone:
            return [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                 target:self
                                                                 action:@selector(doneButtonTapped:)];
            
        case SVWebViewControllerDismissButtonStyleCancel:
            return [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                 target:self
                                                                 action:@selector(doneButtonTapped:)];
    }
}

#pragma mark - Delegate

- (void)setWebViewDelegate:(id<UIWebViewDelegate>)webViewDelegate {
    self.webViewController.delegate = webViewDelegate;
}

- (id<UIWebViewDelegate>)webViewDelegate {
    return self.webViewController.delegate;
}

- (void)doneButtonTapped:(id)sender {
    [self.webViewController doneButtonTapped:sender];
    
    if ([self.webViewDelegate respondsToSelector:@selector(controllerDidPressDoneButton:)]) {
        [self.webViewDelegate controllerDidPressDoneButton:self];
    }
}

@end

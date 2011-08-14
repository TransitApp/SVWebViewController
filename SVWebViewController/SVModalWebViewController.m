//
//  SVModalWebViewController.m
//  iGithub
//
//  Created by Oliver Letterer on 13.08.11.
//  Copyright 2011 Home. All rights reserved.
//

#import "SVModalWebViewController.h"
#import "SVWebViewController.h"

@implementation SVModalWebViewController
@synthesize webDelegate=_webDelegate;

#pragma mark - target actions

- (void)doneButtonClicked:(UIBarButtonItem *)sender {
    [self.webDelegate modalWebViewControllerIsDone:self];
}

#pragma mark - Initialization

- (id)initWithURL:(NSURL *)URL {
    SVWebViewController *webViewController = [[[SVWebViewController alloc] initWithURL:URL] autorelease];
    if (self = [super initWithRootViewController:webViewController]) {
        webViewController.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonClicked:)] autorelease];
    }
    return self;
}

@end

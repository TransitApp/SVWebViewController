//
//  SVModalWebViewController.m
//
//  Created by Oliver Letterer on 13.08.11.
//  Copyright 2011 Home. All rights reserved.
//
//  https://github.com/samvermette/SVWebViewController

#import "SVModalWebViewController.h"
#import "SVWebViewController.h"

@implementation SVModalWebViewController

@synthesize barsTintColor;

#pragma mark - Initialization

- (void)dealloc {
    self.barsTintColor = nil;
    [super dealloc];
}

- (id)initWithAddress:(NSString*)urlString {
    return [self initWithURL:[NSURL URLWithString:urlString]];
}

- (id)initWithURL:(NSURL *)URL {
    SVWebViewController *webViewController = [[[SVWebViewController alloc] initWithURL:URL] autorelease];
    if (self = [super initWithRootViewController:webViewController]) {
        webViewController.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:webViewController action:@selector(doneButtonClicked:)] autorelease];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationBar.tintColor = self.toolbar.tintColor = self.barsTintColor;
}

@end

//
//  SVWebViewController.m
//
//  Created by Sam Vermette on 08.11.10.
//  Copyright 2010 Sam Vermette. All rights reserved.
//

#import "SVWebViewController.h"

@interface SVWebViewController ()

- (void)layoutSubviews;
- (void)setupTabletToolbar;
- (void)stopLoading;

- (void)updateToolbarItems;

@end

@implementation SVWebViewController
@synthesize URL=_URL, webView=_webView;

#pragma mark - setters and getters

#pragma iPhone

- (UIBarButtonItem *)backBarButtonItem {
    if (!_backBarButtonItem) {
        _backBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"SVWebViewController.bundle/iPhone/back"] style:UIBarButtonItemStylePlain target:self.webView action:@selector(goBack)];
        _backBarButtonItem.imageInsets = UIEdgeInsetsMake(2.0f, 0.0f, -2.0f, 0.0f);
		_backBarButtonItem.width = 18.0f;
    }
    return _backBarButtonItem;
}

- (UIBarButtonItem *)forwardBarButtonItem {
    if (!_forwardBarButtonItem) {
        _forwardBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"SVWebViewController.bundle/iPhone/forward"] style:UIBarButtonItemStylePlain target:self.webView action:@selector(goForward)];
        _forwardBarButtonItem.imageInsets = UIEdgeInsetsMake(2.0f, 0.0f, -2.0f, 0.0f);
		_forwardBarButtonItem.width = 18.0f;
    }
    return _forwardBarButtonItem;
}

- (UIBarButtonItem *)refreshBarButtonItem {
    if (!_refreshBarButtonItem) {
        _refreshBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self.webView action:@selector(reload)];
    }
    return _refreshBarButtonItem;
}

- (UIBarButtonItem *)stopBarButtonItem {
    if (!_stopBarButtonItem) {
        _stopBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(stopLoading)];
    }
    return _stopBarButtonItem;
}

- (UIBarButtonItem *)actionBarButtonItem {
    if (!_actionBarButtonItem) {
        _actionBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(actionButtonClicked:)];
    }
    return _actionBarButtonItem;
}

#pragma iPad

- (UIButton *)backButton {
    if (!backButton) {
        backButton = [UIButton buttonWithType:UIButtonTypeCustom];
		[backButton setBackgroundImage:[UIImage imageNamed:@"SVWebViewController.bundle/iPad/back"] forState:UIControlStateNormal];
		backButton.frame = CGRectZero;
		[backButton addTarget:self.webView action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
		backButton.adjustsImageWhenHighlighted = NO;
		backButton.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
		backButton.showsTouchWhenHighlighted = YES;
    }
    return backButton;
}

- (UIButton *)forwardButton {
    if (!forwardButton) {
        forwardButton = [UIButton buttonWithType:UIButtonTypeCustom];
		[forwardButton setBackgroundImage:[UIImage imageNamed:@"SVWebViewController.bundle/iPad/forward"] forState:UIControlStateNormal];
		forwardButton.frame = CGRectZero;
		[forwardButton addTarget:self.webView action:@selector(goForward) forControlEvents:UIControlEventTouchUpInside];
		forwardButton.adjustsImageWhenHighlighted = NO;
		forwardButton.showsTouchWhenHighlighted = YES;
    }
    return forwardButton;
}

- (UIButton *)refreshButton {
    if (!refreshButton) {
        refreshButton = [UIButton buttonWithType:UIButtonTypeCustom];
		[refreshButton setBackgroundImage:[UIImage imageNamed:@"SVWebViewController.bundle/iPad/refresh"] forState:UIControlStateNormal];
		refreshButton.frame = CGRectZero;
		refreshButton.adjustsImageWhenHighlighted = NO;
		refreshButton.showsTouchWhenHighlighted = YES;
    }
    return refreshButton;
}

- (UIButton *)stopButton {
    if (!stopButton) {
        stopButton = [UIButton buttonWithType:UIButtonTypeCustom];
		[stopButton setBackgroundImage:[UIImage imageNamed:@"SVWebViewController.bundle/iPad/stop"] forState:UIControlStateNormal];
		stopButton.frame = CGRectZero;
		stopButton.adjustsImageWhenHighlighted = NO;
		stopButton.showsTouchWhenHighlighted = YES;
        [stopButton addTarget:self action:@selector(stopLoading) forControlEvents:UIControlEventTouchUpInside];
    }
    return stopButton;
}

- (UIButton *)actionButton {
    if (!actionButton) {
        actionButton = [UIButton buttonWithType:UIButtonTypeCustom];
		[actionButton setBackgroundImage:[UIImage imageNamed:@"SVWebViewController.bundle/iPad/action"] forState:UIControlStateNormal];
		actionButton.frame = CGRectZero;
		[actionButton addTarget:self action:@selector(actionButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
		actionButton.adjustsImageWhenHighlighted = NO;
		actionButton.showsTouchWhenHighlighted = YES;
    }
    return actionButton;
}

#pragma mark - initialization

- (id)initWithURL:(NSURL *)URL {
    if (self = [super init]) {
        self.URL = URL;
        
        deviceIsTablet = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);
    }
    return self;
}

#pragma mark - View lifecycle

- (void)loadView {
    _webView = [[UIWebView alloc] initWithFrame:[UIScreen mainScreen].bounds ];
    _webView.delegate = self;
    _webView.scalesPageToFit = YES;
    [_webView loadRequest:[NSURLRequest requestWithURL:self.URL] ];
    self.view = _webView;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        
    } else {
        [self.navigationController setToolbarHidden:YES animated:NO];
        [self updateToolbarItems];
    }
    
    return;
    
	if(!deviceIsTablet) {
		navBar = self.navigationController.navigationBar;
        toolbar = self.navigationController.toolbar;
	}
	
	else {
        self.hidesBottomBarWhenPushed = YES;
        self.title = nil;
        
        navBar = self.navigationController.navigationBar;
        navBar.autoresizesSubviews = YES;
        
        NSArray* viewCtrlers = self.navigationController.viewControllers;
        UIViewController* prevCtrler = [viewCtrlers objectAtIndex:[viewCtrlers count]-2];
        titleLeftOffset = [prevCtrler.navigationItem.backBarButtonItem.title sizeWithFont:[UIFont boldSystemFontOfSize:12]].width+26;
		
//		asd
		
		
		
		
		
//		titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
//		titleLabel.font = [UIFont boldSystemFontOfSize:20];
//		titleLabel.textColor = [UIColor colorWithRed:0.42353 green:0.45098 blue:0.48235 alpha:1.];
//		titleLabel.shadowColor = [UIColor colorWithWhite:1 alpha:0.7];
//		titleLabel.backgroundColor = [UIColor clearColor];
//		titleLabel.lineBreakMode = UILineBreakModeTailTruncation;
//		titleLabel.textAlignment = UITextAlignmentRight;
//		titleLabel.shadowOffset = CGSizeMake(0, 1);
//
//		[navBar addSubview:titleLabel];	
//		[titleLabel release];
//		
//		[navBar addSubview:refreshStopButton];	
//		[navBar addSubview:backButton];	
//		[navBar addSubview:forwardButton];	
//		[navBar addSubview:actionButton];	
	}
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:YES];
	
    [self.navigationController setToolbarHidden:NO animated:animated];
    
	[self layoutSubviews];
	
	if(deviceIsTablet && self.navigationController) {
		titleLabel.alpha = 0;
//		refreshStopButton.alpha = 0;
		backButton.alpha = 0;
		forwardButton.alpha = 0;
		actionButton.alpha = 0;
		
		[UIView animateWithDuration:0.3 animations:^{
			titleLabel.alpha = 1;
//			refreshStopButton.alpha = 1;
			backButton.alpha = 1;
			forwardButton.alpha = 1;
			actionButton.alpha = 1;
		}];
	}
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController setToolbarHidden:YES animated:animated];
}

#pragma mark -
#pragma mark Layout Methods

- (void)layoutSubviews {
	CGRect deviceBounds = self.view.bounds;

    if(UIInterfaceOrientationIsLandscape(self.interfaceOrientation) && !deviceIsTablet && !self.navigationController) {
        navBar.frame = CGRectMake(0, 0, CGRectGetWidth(deviceBounds), 32);
        toolbar.frame = CGRectMake(0, CGRectGetHeight(deviceBounds)-32, CGRectGetWidth(deviceBounds), 32);
    } else if(UIInterfaceOrientationIsPortrait(self.interfaceOrientation) && !deviceIsTablet && !self.navigationController) {
        navBar.frame = CGRectMake(0, 0, CGRectGetWidth(deviceBounds), 44);
        toolbar.frame = CGRectMake(0, CGRectGetHeight(deviceBounds)-44, CGRectGetWidth(deviceBounds), 44);
    }
    
	if(self.navigationController && deviceIsTablet)
		self.webView.frame = CGRectMake(0, 0, CGRectGetWidth(deviceBounds), CGRectGetHeight(deviceBounds));
	else if(deviceIsTablet)
		self.webView.frame = CGRectMake(0, CGRectGetMaxY(navBar.frame), CGRectGetWidth(deviceBounds), CGRectGetHeight(deviceBounds)-CGRectGetMaxY(navBar.frame));
	else if(self.navigationController && !deviceIsTablet)
		self.webView.frame = CGRectMake(0, 0, CGRectGetWidth(deviceBounds), CGRectGetMaxY(self.view.bounds));
	else if(!deviceIsTablet)
		self.webView.frame = CGRectMake(0, CGRectGetMaxY(navBar.frame), CGRectGetWidth(deviceBounds), CGRectGetMinY(toolbar.frame)-CGRectGetMaxY(navBar.frame));
        
	backButton.frame = CGRectMake(CGRectGetWidth(deviceBounds)-180, 0, 44, 44);
	forwardButton.frame = CGRectMake(CGRectGetWidth(deviceBounds)-120, 0, 44, 44);
	actionButton.frame = CGRectMake(CGRectGetWidth(deviceBounds)-60, 0, 44, 44);
//	refreshStopButton.frame = CGRectMake(CGRectGetWidth(deviceBounds)-240, 0, 44, 44);
	titleLabel.frame = CGRectMake(titleLeftOffset, 0, CGRectGetWidth(deviceBounds)-240-titleLeftOffset-5, 44);
}

- (void)updateToolbarItems {
    self.backBarButtonItem.enabled = [self.webView canGoBack];
    self.forwardBarButtonItem.enabled = [self.webView canGoForward];
    
    UIBarButtonItem *refreshStopBarButtonItem = self.webView.isLoading ? self.stopBarButtonItem : self.refreshBarButtonItem;
    
    UIBarButtonItem *fixedSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    fixedSpace.width = 5;
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    NSArray *items = [NSArray arrayWithObjects:
                      fixedSpace,
                      self.backBarButtonItem, 
                      flexibleSpace,
                      self.forwardBarButtonItem,
                      flexibleSpace,
                      refreshStopBarButtonItem,
                      flexibleSpace,
                      self.actionBarButtonItem,
                      fixedSpace,
                      nil];
    self.toolbarItems = items;
}

- (void)setupTabletToolbar {
	
	titleLabel.text = [self.webView stringByEvaluatingJavaScriptFromString:@"document.title"];
	
	if(![self.webView canGoBack])
		backButton.enabled = NO;
	else
		backButton.enabled = YES;
	
	if(![self.webView canGoForward])
		forwardButton.enabled = NO;
	else
		forwardButton.enabled = YES;
	
//	if(self.webView.loading && !stoppedLoading) {
//		[refreshStopButton removeTarget:self.webView action:@selector(reload) forControlEvents:UIControlEventTouchUpInside];
//		[refreshStopButton addTarget:self action:@selector(stopLoading) forControlEvents:UIControlEventTouchUpInside];
//		[refreshStopButton setBackgroundImage:[UIImage imageNamed:@"SVWebViewController.bundle/iPad/stop"] forState:UIControlStateNormal];
//	}
//	
//	else {
//		[refreshStopButton removeTarget:self action:@selector(stopLoading) forControlEvents:UIControlEventTouchUpInside];
//		[refreshStopButton addTarget:self.webView action:@selector(reload) forControlEvents:UIControlEventTouchUpInside];
//		[refreshStopButton setBackgroundImage:[UIImage imageNamed:@"SVWebViewController.bundle/iPad/refresh"] forState:UIControlStateNormal];
//	}
}


#pragma mark -
#pragma mark Orientation Support

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation duration:(NSTimeInterval)duration {
	[self layoutSubviews];
}


#pragma mark -
#pragma mark UIWebViewDelegate

- (void)webViewDidStartLoad:(UIWebView *)webView {
	stoppedLoading = NO;
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];

	if(!deviceIsTablet)
        ;
	else
		[self setupTabletToolbar];
}


- (void)webViewDidFinishLoad:(UIWebView *)webView {
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
    self.navigationItem.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    
	if(!deviceIsTablet)
		[self updateToolbarItems];
	else
		[self setupTabletToolbar];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}


#pragma mark -
#pragma mark Action Methods

- (void)stopLoading {
	
	stoppedLoading = YES;
	[self.webView stopLoading];
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	
	if(!deviceIsTablet)
        ;
	else
		[self setupTabletToolbar];
}

- (void)actionButtonClicked:(id)sender {
	UIActionSheet *actionSheet = [[UIActionSheet alloc] 
                                   initWithTitle:nil
                                   delegate:self 
                                   cancelButtonTitle:nil   
                                   destructiveButtonTitle:nil   
                                   otherButtonTitles:NSLocalizedString(@"Open in Safari", @"SVWebViewController"), nil]; 
	
	
	if([MFMailComposeViewController canSendMail])
		[actionSheet addButtonWithTitle:NSLocalizedString(@"Mail Link to this Page", @"SVWebViewController")];
	
	[actionSheet addButtonWithTitle:NSLocalizedString(@"Cancel", @"SVWebViewController")];
	actionSheet.cancelButtonIndex = [actionSheet numberOfButtons]-1;
	
	if(!deviceIsTablet)
		[actionSheet showFromToolbar:self.navigationController.toolbar];
	else if(!self.navigationController)
		[actionSheet showFromRect:CGRectOffset(actionButton.frame, 0, -5) inView:self.view animated:YES];
	else if(self.navigationController)
		[actionSheet showFromRect:CGRectOffset(actionButton.frame, 0, -49) inView:self.view animated:YES];
}

#pragma mark -
#pragma mark UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	
	if([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:NSLocalizedString(@"Open in Safari", @"SVWebViewController")])
		[[UIApplication sharedApplication] openURL:self.webView.request.URL];
	
	else if([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:NSLocalizedString(@"Mail Link to this Page", @"SVWebViewController")]) {
		
		MFMailComposeViewController *emailComposer = [[MFMailComposeViewController alloc] init]; 
		
		[emailComposer setMailComposeDelegate: self]; 
        NSString *title = [self.webView stringByEvaluatingJavaScriptFromString:@"document.title"];
		[emailComposer setSubject:title];
        
  		[emailComposer setMessageBody:self.webView.request.URL.absoluteString isHTML:NO];
        
		emailComposer.modalPresentationStyle = UIModalPresentationFormSheet;
		
		[self presentModalViewController:emailComposer animated:YES];
	}
	
}

#pragma mark -
#pragma mark MFMailComposeViewControllerDelegate

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
	[controller dismissModalViewControllerAnimated:YES];
}


@end

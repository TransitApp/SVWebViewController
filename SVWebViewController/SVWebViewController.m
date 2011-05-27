//
//  SVWebViewController.m
//
//  Created by Sam Vermette on 08.11.10.
//  Copyright 2010 Sam Vermette. All rights reserved.
//

#import "SVWebViewController.h"

@interface SVWebViewController (private)

- (CGFloat)leftButtonWidth;
- (void)layoutSubviews;
- (void)setupToolbar;
- (void)setupTabletToolbar;

- (void)stopLoading;

@end

@implementation SVWebViewController

@synthesize urlString;

- (void)dealloc {
	navItem = nil;
	
	[backBarButton release];
	[forwardBarButton release];
	[actionBarButton release];
	
    [super dealloc];
}

- (id)initWithAddress:(NSString*)string {
	
	self = [super initWithNibName:@"SVWebViewController" bundle:[NSBundle mainBundle]];

	self.urlString = string;
	
	if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
		deviceIsTablet = YES;
	
	return self;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	
	CGRect deviceBounds = [[UIApplication sharedApplication] keyWindow].bounds;
	
	if(!deviceIsTablet) {
		separatorWidth = 50;
		buttonWidth = 18;
		
		backBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"SVWebViewController.bundle/iPhone/back"] style:UIBarButtonItemStylePlain target:rWebView action:@selector(goBack)];
		backBarButton.width = buttonWidth;
		
		forwardBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"SVWebViewController.bundle/iPhone/forward"] style:UIBarButtonItemStylePlain target:rWebView action:@selector(goForward)];
		forwardBarButton.width = buttonWidth;
		
		actionBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(showActions)];
		
		if(self.navigationController == nil) {
			
			UINavigationBar *navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0,0,CGRectGetWidth(deviceBounds),44)];
			[self.view addSubview:navBar];
			[navBar release];
			
			UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(dismissController)];

			navItem = [[UINavigationItem alloc] initWithTitle:self.title];
			navItem.leftBarButtonItem = doneButton;
			[doneButton release];
			
			[navBar setItems:[NSArray arrayWithObject:navItem] animated:YES];
			[navItem release];
			
			rWebView.frame = CGRectMake(0, CGRectGetMaxY(navBar.frame), CGRectGetWidth(deviceBounds), CGRectGetMinY(toolbar.frame)-88);
		}
	}
	
	else {
		
		[toolbar removeFromSuperview];
		UINavigationBar *navBar;
		
		if(self.navigationController == nil) {
			
			navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0,0,CGRectGetWidth(deviceBounds),44)];
			[self.view addSubview:navBar];
			[navBar release];
			
			UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(dismissController)];
			
			navItem = [[UINavigationItem alloc] initWithTitle:nil];
			navItem.leftBarButtonItem = doneButton;
			[doneButton release];
			
			[navBar setItems:[NSArray arrayWithObject:navItem] animated:YES];
			[navItem release];
			
			titleLeftOffset = [@"Done" sizeWithFont:[UIFont boldSystemFontOfSize:12]].width+33;
		}
		
		else {
			self.title = nil;
			navBar = self.navigationController.navigationBar;
			navBar.autoresizesSubviews = YES;
			
			NSArray* viewCtrlers = self.navigationController.viewControllers;
			UIViewController* prevCtrler = [viewCtrlers objectAtIndex:[viewCtrlers count]-2];
			titleLeftOffset = [prevCtrler.navigationItem.backBarButtonItem.title sizeWithFont:[UIFont boldSystemFontOfSize:12]].width+26;
		}
		
		backButton = [UIButton buttonWithType:UIButtonTypeCustom];
		[backButton setBackgroundImage:[UIImage imageNamed:@"SVWebViewController.bundle/iPad/back"] forState:UIControlStateNormal];
		backButton.frame = CGRectZero;
		[backButton addTarget:rWebView action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
		backButton.adjustsImageWhenHighlighted = NO;
		backButton.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
		backButton.showsTouchWhenHighlighted = YES;
		
		forwardButton = [UIButton buttonWithType:UIButtonTypeCustom];
		[forwardButton setBackgroundImage:[UIImage imageNamed:@"SVWebViewController.bundle/iPad/forward"] forState:UIControlStateNormal];
		forwardButton.frame = CGRectZero;
		[forwardButton addTarget:rWebView action:@selector(goForward) forControlEvents:UIControlEventTouchUpInside];
		forwardButton.adjustsImageWhenHighlighted = NO;
		forwardButton.showsTouchWhenHighlighted = YES;
		
		actionButton = [UIButton buttonWithType:UIButtonTypeCustom];
		[actionButton setBackgroundImage:[UIImage imageNamed:@"SVWebViewController.bundle/iPad/action"] forState:UIControlStateNormal];
		actionButton.frame = CGRectZero;
		[actionButton addTarget:self action:@selector(showActions) forControlEvents:UIControlEventTouchUpInside];
		actionButton.adjustsImageWhenHighlighted = NO;
		actionButton.showsTouchWhenHighlighted = YES;
		
		refreshStopButton = [UIButton buttonWithType:UIButtonTypeCustom];
		[refreshStopButton setBackgroundImage:[UIImage imageNamed:@"SVWebViewController.bundle/iPad/refresh"] forState:UIControlStateNormal];
		refreshStopButton.frame = CGRectZero;
		refreshStopButton.adjustsImageWhenHighlighted = NO;
		refreshStopButton.showsTouchWhenHighlighted = YES;
		
		titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		titleLabel.font = [UIFont boldSystemFontOfSize:20];
		titleLabel.textColor = [UIColor colorWithRed:0.42353 green:0.45098 blue:0.48235 alpha:1.];
		titleLabel.shadowColor = [UIColor colorWithWhite:1 alpha:0.7];
		titleLabel.backgroundColor = [UIColor clearColor];
		titleLabel.lineBreakMode = UILineBreakModeTailTruncation;
		titleLabel.textAlignment = UITextAlignmentRight;
		titleLabel.shadowOffset = CGSizeMake(0, 1);

		[navBar addSubview:titleLabel];	
		[titleLabel release];
		
		[navBar addSubview:refreshStopButton];	
		[navBar addSubview:backButton];	
		[navBar addSubview:forwardButton];	
		[navBar addSubview:actionButton];	
	}
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:YES];
	
	NSURL *searchURL = [NSURL URLWithString:self.urlString];
	[rWebView loadRequest:[NSURLRequest requestWithURL:searchURL]];

	[self setupToolbar];
	
	[self layoutSubviews];
	
	if(deviceIsTablet && self.navigationController) {
		titleLabel.alpha = 0;
		refreshStopButton.alpha = 0;
		backButton.alpha = 0;
		forwardButton.alpha = 0;
		actionButton.alpha = 0;
		
		[UIView animateWithDuration:0.3 animations:^{
			titleLabel.alpha = 1;
			refreshStopButton.alpha = 1;
			backButton.alpha = 1;
			forwardButton.alpha = 1;
			actionButton.alpha = 1;
		}];
	}
}



- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	
	rWebView.delegate = nil;
	rWebView = nil;
	
	[self stopLoading];
	
	if(deviceIsTablet && self.navigationController) {
		[UIView animateWithDuration:0.3 animations:^{
			titleLabel.alpha = 0;
			refreshStopButton.alpha = 0;
			backButton.alpha = 0;
			forwardButton.alpha = 0;
			actionButton.alpha = 0;
		}];
	}
}

#pragma mark -
#pragma mark Layout Methods

- (void)layoutSubviews {
	CGRect deviceBounds = self.view.bounds;

	if(self.navigationController && deviceIsTablet)
		rWebView.frame = CGRectMake(0, 0, CGRectGetWidth(deviceBounds), CGRectGetHeight(deviceBounds));
	else if(deviceIsTablet)
		rWebView.frame = CGRectMake(0, 44, CGRectGetWidth(deviceBounds), CGRectGetHeight(deviceBounds)-44);
	else if(self.navigationController && !deviceIsTablet)
		rWebView.frame = CGRectMake(0, 0, CGRectGetWidth(deviceBounds), CGRectGetHeight(deviceBounds)-44);
	else if(!deviceIsTablet)
		rWebView.frame = CGRectMake(0, 44, CGRectGetWidth(deviceBounds), CGRectGetHeight(deviceBounds)-88);
	
	backButton.frame = CGRectMake(CGRectGetWidth(deviceBounds)-180, 0, 44, 44);
	forwardButton.frame = CGRectMake(CGRectGetWidth(deviceBounds)-120, 0, 44, 44);
	actionButton.frame = CGRectMake(CGRectGetWidth(deviceBounds)-60, 0, 44, 44);
	refreshStopButton.frame = CGRectMake(CGRectGetWidth(deviceBounds)-240, 0, 44, 44);
	titleLabel.frame = CGRectMake(titleLeftOffset, 0, CGRectGetWidth(deviceBounds)-240-titleLeftOffset-5, 44);
}


- (void)setupToolbar {
	
	if(self.navigationController != nil)
		self.navigationItem.title = [rWebView stringByEvaluatingJavaScriptFromString:@"document.title"];
	else
		navItem.title = [rWebView stringByEvaluatingJavaScriptFromString:@"document.title"];
	
	if(![rWebView canGoBack])
		backBarButton.enabled = NO;
	else
		backBarButton.enabled = YES;
	
	if(![rWebView canGoForward])
		forwardBarButton.enabled = NO;
	else
		forwardBarButton.enabled = YES;
	
	UIBarButtonItem *sSeparator = [[UIBarButtonItem alloc] initWithCustomView:nil];
	sSeparator.enabled = NO;
		
	if(rWebView.loading && !stoppedLoading) {
		refreshStopBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(stopLoading)];
		sSeparator.width = separatorWidth+4;
	}
	
	else {
		refreshStopBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:rWebView action:@selector(reload)];
		sSeparator.width = separatorWidth+3;
	}
	
	
	UIBarButtonItem *rSeparator = [[UIBarButtonItem alloc] initWithCustomView:nil];
	rSeparator.width = separatorWidth;
	rSeparator.enabled = NO;
	
	NSArray *newButtons = [NSArray arrayWithObjects:backBarButton, rSeparator, forwardBarButton, rSeparator, refreshStopBarButton, sSeparator, actionBarButton, nil];
	[toolbar setItems:newButtons];
	
	[refreshStopBarButton release];
	[sSeparator release];
	[rSeparator release];
}


- (void)setupTabletToolbar {
	
	titleLabel.text = [rWebView stringByEvaluatingJavaScriptFromString:@"document.title"];
	
	if(![rWebView canGoBack])
		backButton.enabled = NO;
	else
		backButton.enabled = YES;
	
	if(![rWebView canGoForward])
		forwardButton.enabled = NO;
	else
		forwardButton.enabled = YES;
	
	if(rWebView.loading && !stoppedLoading) {
		[refreshStopButton removeTarget:rWebView action:@selector(reload) forControlEvents:UIControlEventTouchUpInside];
		[refreshStopButton addTarget:self action:@selector(stopLoading) forControlEvents:UIControlEventTouchUpInside];
		[refreshStopButton setBackgroundImage:[UIImage imageNamed:@"SVWebViewController.bundle/iPad/stop"] forState:UIControlStateNormal];
	}
	
	else {
		[refreshStopButton removeTarget:self action:@selector(stopLoading) forControlEvents:UIControlEventTouchUpInside];
		[refreshStopButton addTarget:rWebView action:@selector(reload) forControlEvents:UIControlEventTouchUpInside];
		[refreshStopButton setBackgroundImage:[UIImage imageNamed:@"SVWebViewController.bundle/iPad/refresh"] forState:UIControlStateNormal];
	}
}


#pragma mark -
#pragma mark Orientation Support

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	
	if(deviceIsTablet)
		return YES;
	
	return NO;
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation duration:(NSTimeInterval)duration {
	[self layoutSubviews];
}


#pragma mark -
#pragma mark UIWebViewDelegate

- (void)webViewDidStartLoad:(UIWebView *)webView {
	
	stoppedLoading = NO;
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];

	if(!deviceIsTablet)
		[self setupToolbar];
	else
		[self setupTabletToolbar];
}


- (void)webViewDidFinishLoad:(UIWebView *)webView {
	
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];

	if(!deviceIsTablet)
		[self setupToolbar];
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
	[rWebView stopLoading];
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	
	if(!deviceIsTablet)
		[self setupToolbar];
	else
		[self setupTabletToolbar];
}

- (void)showActions {
	
	UIActionSheet *actionSheet = [[UIActionSheet alloc] 
						  initWithTitle: nil
						  delegate: self 
						  cancelButtonTitle: nil   
						  destructiveButtonTitle: nil   
						  otherButtonTitles: @"Open in Safari", nil]; 
	
	
	if([MFMailComposeViewController canSendMail])
		[actionSheet addButtonWithTitle:@"Email this"];
	
	[actionSheet addButtonWithTitle:@"Cancel"];
	actionSheet.cancelButtonIndex = [actionSheet numberOfButtons]-1;
	
	if(!deviceIsTablet)
		[actionSheet showFromToolbar:toolbar];
	else if(!self.navigationController)
		[actionSheet showFromRect:CGRectOffset(actionButton.frame, 0, -5) inView:self.view animated:YES];
	else if(self.navigationController)
		[actionSheet showFromRect:CGRectOffset(actionButton.frame, 0, -49) inView:self.view animated:YES];
		
	[actionSheet release];
}


- (void)dismissController {
	[self dismissModalViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	
	if([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"Open in Safari"])
		[[UIApplication sharedApplication] openURL:rWebView.request.URL];
	
	else if([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"Email this"]) {
		
		MFMailComposeViewController *emailComposer = [[MFMailComposeViewController alloc] init]; 
		
		[emailComposer setMailComposeDelegate: self]; 
		[emailComposer setSubject:[rWebView stringByEvaluatingJavaScriptFromString:@"document.title"]];
		[emailComposer setMessageBody:rWebView.request.URL.absoluteString isHTML:NO];
		emailComposer.modalPresentationStyle = UIModalPresentationFormSheet;
		
		[self presentModalViewController:emailComposer animated:YES];
		[emailComposer release];
	}
	
}

#pragma mark -
#pragma mark MFMailComposeViewControllerDelegate

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
	[controller dismissModalViewControllerAnimated:YES];
}


@end

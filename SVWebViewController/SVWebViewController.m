//
//  SVWebViewController.m
//
//  Created by Sam Vermette on 08.11.10.
//  Copyright 2010 Sam Vermette. All rights reserved.
//

#import "SVWebViewController.h"

#define kButtonWidth 18
#define kSeparatorWidth 50

@interface SVWebViewController (private)

- (void)setupToolbar;

@end

@implementation SVWebViewController

@synthesize urlString;

- (void)dealloc {
	[backButton release];
	[forwardButton release];
	[actionButton release];
	
    [super dealloc];
}

- (id)initWithAddress:(NSString*)string {
	
	self = [super initWithNibName:@"SVWebViewController" bundle:[NSBundle mainBundle]];

	self.urlString = string;
	
	return self;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	
	backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"webBack.png"] style:UIBarButtonItemStylePlain target:rWebView action:@selector(goBack)];
	backButton.width = kButtonWidth;
	
	forwardButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"webForward.png"] style:UIBarButtonItemStylePlain target:rWebView action:@selector(goForward)];
	forwardButton.width = kButtonWidth;
	
	actionButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(showActions)];
	
	if(self.navigationController == nil) {
		
		UINavigationBar *navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0,0,320,44)];
		[self.view addSubview:navBar];
		[navBar release];
		
		UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(dismissController)];

		UINavigationItem *navItem = [[UINavigationItem alloc] initWithTitle:self.title];
		navItem.rightBarButtonItem = doneButton;
		
		[navBar setItems:[NSArray arrayWithObject:navItem] animated:YES];
		[navItem release];
		
		rWebView.frame = CGRectMake(0, CGRectGetMaxY(navBar.frame), 320, CGRectGetMinY(toolbar.frame)-CGRectGetMaxY(navBar.frame));
	}
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:YES];
	
	NSURL *searchURL = [[NSURL alloc] initWithString:self.urlString];
	[rWebView loadRequest:[NSURLRequest requestWithURL:searchURL]];
	[searchURL release];
	
	[self setupToolbar];
}



- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	
	[rWebView stopLoading];
}

- (void)dismissController {

	[self dismissModalViewControllerAnimated:YES];
}


#pragma mark -
#pragma mark UIWebViewDelegate

- (void)webViewDidStartLoad:(UIWebView *)webView {
	
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];

	[self setupToolbar];
}


- (void)webViewDidFinishLoad:(UIWebView *)webView {
	
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];

	[self setupToolbar];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
	
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}


#pragma mark -
#pragma mark Action Methods

- (void)setupToolbar {
	
	if(![rWebView canGoBack])
		backButton.enabled = NO;
	else
		backButton.enabled = YES;
	
	if(![rWebView canGoForward])
		forwardButton.enabled = NO;
	else
		forwardButton.enabled = YES;
	
	UIBarButtonItem *sSeparator = [[UIBarButtonItem alloc] initWithCustomView:nil];
	sSeparator.enabled = NO;
	
	if(rWebView.loading) {
		refreshStopButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:rWebView action:@selector(stopLoading)];
		sSeparator.width = kSeparatorWidth+4;
	}
	
	else {
		refreshStopButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:rWebView action:@selector(reload)];
		sSeparator.width = kSeparatorWidth+3;
	}
	
	
	UIBarButtonItem *rSeparator = [[UIBarButtonItem alloc] initWithCustomView:nil];
	rSeparator.width = kSeparatorWidth;
	rSeparator.enabled = NO;
	
	NSArray *newButtons = [NSArray arrayWithObjects:backButton, rSeparator, forwardButton, rSeparator, refreshStopButton, sSeparator, actionButton, nil];
	[toolbar setItems:newButtons];
	
	[refreshStopButton release];
	[sSeparator release];
	[rSeparator release];
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
	
	[actionSheet showFromToolbar:toolbar];
	[actionSheet release];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	
	if([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"Open in Safari"])
		[[UIApplication sharedApplication] openURL:rWebView.request.URL];
	
	else if([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"Email this"]) {
		
		MFMailComposeViewController *emailComposer = [[MFMailComposeViewController alloc] init]; 
		
		[emailComposer setMailComposeDelegate: self]; 
		[emailComposer setSubject:@"Link"];
		[emailComposer setMessageBody:rWebView.request.URL.absoluteString isHTML:NO];
		
		[self presentModalViewController:emailComposer animated:YES];
		[emailComposer release];
	}
	
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
	[controller dismissModalViewControllerAnimated:YES];
}



@end

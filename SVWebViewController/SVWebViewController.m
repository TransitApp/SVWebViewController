//
//  SVWebViewController.m
//
//  Created by Sam Vermette on 08.11.10.
//  Copyright 2010 Sam Vermette. All rights reserved.
//

#import "SVWebViewController.h"

@interface SVWebViewController ()

- (void)updateToolbarItems;

- (void)_goBackClicked:(UIBarButtonItem *)sender;
- (void)_goForwardClicked:(UIBarButtonItem *)sender;
- (void)_reloadClicked:(UIBarButtonItem *)sender;
- (void)_stopClicked:(UIBarButtonItem *)sender;
- (void)_actionButtonClicked:(UIBarButtonItem *)sender;

@end

@implementation SVWebViewController
@synthesize URL=_URL, webView=_webView;

#pragma mark - setters and getters

- (UIBarButtonItem *)backBarButtonItem {
    if (!_backBarButtonItem) {
        _backBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"SVWebViewController.bundle/iPhone/back"] style:UIBarButtonItemStylePlain target:self action:@selector(_goBackClicked:)];
        _backBarButtonItem.imageInsets = UIEdgeInsetsMake(2.0f, 0.0f, -2.0f, 0.0f);
		_backBarButtonItem.width = 18.0f;
    }
    return _backBarButtonItem;
}

- (UIBarButtonItem *)forwardBarButtonItem {
    if (!_forwardBarButtonItem) {
        _forwardBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"SVWebViewController.bundle/iPhone/forward"] style:UIBarButtonItemStylePlain target:self action:@selector(_goForwardClicked:)];
        _forwardBarButtonItem.imageInsets = UIEdgeInsetsMake(2.0f, 0.0f, -2.0f, 0.0f);
		_forwardBarButtonItem.width = 18.0f;
    }
    return _forwardBarButtonItem;
}

- (UIBarButtonItem *)refreshBarButtonItem {
    if (!_refreshBarButtonItem) {
        _refreshBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(_reloadClicked:)];
    }
    return _refreshBarButtonItem;
}

- (UIBarButtonItem *)stopBarButtonItem {
    if (!_stopBarButtonItem) {
        _stopBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(_stopClicked:)];
    }
    return _stopBarButtonItem;
}

- (UIBarButtonItem *)actionBarButtonItem {
    if (!_actionBarButtonItem) {
        _actionBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(_actionButtonClicked:)];
    }
    return _actionBarButtonItem;
}

#pragma mark - initialization

- (id)initWithURL:(NSURL *)URL {
    if (self = [super init]) {
        self.URL = URL;
    }
    return self;
}

#pragma mark - Memory management

- (void)dealloc {
    _webView.delegate = nil;
    [_webView release];
    
    [_URL release];
    [_backBarButtonItem release];
    [_forwardBarButtonItem release];
    [_refreshBarButtonItem release];
    [_stopBarButtonItem release];
    [_actionBarButtonItem release];
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
    [super dealloc];
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
    [self updateToolbarItems];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    
    [_webView release], _webView = nil;
    
    [_backBarButtonItem release], _backBarButtonItem = nil;
    [_forwardBarButtonItem release], _forwardBarButtonItem = nil;
    [_refreshBarButtonItem release], _refreshBarButtonItem = nil;
    [_stopBarButtonItem release], _stopBarButtonItem = nil;
    [_actionBarButtonItem release], _actionBarButtonItem = nil;
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        [self.navigationController setToolbarHidden:NO animated:animated];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        [self.navigationController setToolbarHidden:YES animated:animated];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return YES;
}

#pragma mark - Toolbar

- (void)updateToolbarItems {
    self.backBarButtonItem.enabled = [self.webView canGoBack];
    self.forwardBarButtonItem.enabled = [self.webView canGoForward];
    
    UIBarButtonItem *refreshStopBarButtonItem = self.webView.isLoading ? self.stopBarButtonItem : self.refreshBarButtonItem;
    
    UIBarButtonItem *fixedSpace = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil] autorelease];
    fixedSpace.width = 5.0f;
    UIBarButtonItem *flexibleSpace = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil] autorelease];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        NSArray *items = [NSArray arrayWithObjects:
                          fixedSpace,
                          refreshStopBarButtonItem,
                          flexibleSpace,
                          self.backBarButtonItem,
                          flexibleSpace,
                          self.forwardBarButtonItem,
                          flexibleSpace,
                          self.actionBarButtonItem,
                          fixedSpace,
                          nil];
        
        UIToolbar *toolbar = [[[UIToolbar alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 250.0f, 44.0f)] autorelease];
        toolbar.items = items;
        self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:toolbar] autorelease];
    } else {
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
}

#pragma mark -
#pragma mark UIWebViewDelegate

- (void)webViewDidStartLoad:(UIWebView *)webView {
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [self updateToolbarItems];
}


- (void)webViewDidFinishLoad:(UIWebView *)webView {
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
    self.navigationItem.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    [self updateToolbarItems];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    [self updateToolbarItems];
}

#pragma mark - Target actions

- (void)_goBackClicked:(UIBarButtonItem *)sender {
    [_webView goBack];
}

- (void)_goForwardClicked:(UIBarButtonItem *)sender {
    [_webView goForward];
}

- (void)_reloadClicked:(UIBarButtonItem *)sender {
    [_webView reload];
}

- (void)_stopClicked:(UIBarButtonItem *)sender {
    [_webView stopLoading];
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	[self updateToolbarItems];
}

- (void)_actionButtonClicked:(id)sender {
	UIActionSheet *actionSheet = [[[UIActionSheet alloc] 
                                   initWithTitle:nil
                                   delegate:self 
                                   cancelButtonTitle:nil   
                                   destructiveButtonTitle:nil   
                                   otherButtonTitles:NSLocalizedString(@"Open in Safari", @""), nil] autorelease]; 
	
	
	if([MFMailComposeViewController canSendMail]) {
        [actionSheet addButtonWithTitle:NSLocalizedString(@"Mail Link to this Page", @"")];
    }
	
	[actionSheet addButtonWithTitle:NSLocalizedString(@"Cancel", @"")];
	actionSheet.cancelButtonIndex = [actionSheet numberOfButtons]-1;
	
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        [actionSheet showFromBarButtonItem:self.actionBarButtonItem animated:YES];
    } else {
        [actionSheet showFromToolbar:self.navigationController.toolbar];
    }
}

#pragma mark -
#pragma mark UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	NSString *title = nil;
    
    @try {
        title = [actionSheet buttonTitleAtIndex:buttonIndex];
    }
    @catch (NSException *exception) { }
    
	if([title isEqualToString:NSLocalizedString(@"Open in Safari", @"")]) {
        [[UIApplication sharedApplication] openURL:self.webView.request.URL];
    } else if([title isEqualToString:NSLocalizedString(@"Mail Link to this Page", @"")]) {
		MFMailComposeViewController *mailViewController = [[[MFMailComposeViewController alloc] init] autorelease];
        
		mailViewController.mailComposeDelegate = self;
        [mailViewController setSubject:[self.webView stringByEvaluatingJavaScriptFromString:@"document.title"]];
  		[mailViewController setMessageBody:self.webView.request.URL.absoluteString isHTML:NO];
		mailViewController.modalPresentationStyle = UIModalPresentationFormSheet;
        
		[self presentModalViewController:mailViewController animated:YES];
	}
}

#pragma mark -
#pragma mark MFMailComposeViewControllerDelegate

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
	[self dismissModalViewControllerAnimated:YES];
}

@end

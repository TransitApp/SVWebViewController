//
//  SVWebViewController.h
//
//  Created by Sam Vermette on 08.11.10.
//  Copyright 2010 Sam Vermette. All rights reserved.
//

#import <MessageUI/MessageUI.h>


@interface SVWebViewController : UIViewController <UIWebViewDelegate, UIActionSheetDelegate, MFMailComposeViewControllerDelegate> {
    UINavigationBar *navBar;
    UIToolbar *toolbar;
	
	// iPad UI
	UIButton *backButton, *forwardButton, *refreshButton, *stopButton, *actionButton;
	UILabel *titleLabel;
	CGFloat titleLeftOffset;
	
	BOOL deviceIsTablet, stoppedLoading;
    
    UIWebView *_webView;
    NSURL *_URL;
    
    UIBarButtonItem *_backBarButtonItem, *_forwardBarButtonItem, *_refreshBarButtonItem, *_stopBarButtonItem, *_actionBarButtonItem;
    UIButton *_backButton, *_forwardButton, *_refreshButton, *_stopButton, *_actionButton;
}

@property (nonatomic, readonly) UIBarButtonItem *backBarButtonItem;
@property (nonatomic, readonly) UIBarButtonItem *forwardBarButtonItem;
@property (nonatomic, readonly) UIBarButtonItem *refreshBarButtonItem;
@property (nonatomic, readonly) UIBarButtonItem *stopBarButtonItem;
@property (nonatomic, readonly) UIBarButtonItem *actionBarButtonItem;

@property (nonatomic, strong, readonly) UIWebView *webView;
@property (nonatomic, strong) NSURL *URL;

- (id)initWithURL:(NSURL *)URL;

@end

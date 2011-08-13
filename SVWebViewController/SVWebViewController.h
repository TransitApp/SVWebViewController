//
//  SVWebViewController.h
//
//  Created by Sam Vermette on 08.11.10.
//  Copyright 2010 Sam Vermette. All rights reserved.
//

#import <MessageUI/MessageUI.h>


@interface SVWebViewController : UIViewController <UIWebViewDelegate, UIActionSheetDelegate, MFMailComposeViewControllerDelegate> {
    UIWebView *_webView;
    NSURL *_URL;
    
    UIBarButtonItem *_backBarButtonItem, *_forwardBarButtonItem, *_refreshBarButtonItem, *_stopBarButtonItem, *_actionBarButtonItem;
}

@property (nonatomic, strong, readonly) UIBarButtonItem *backBarButtonItem;
@property (nonatomic, strong, readonly) UIBarButtonItem *forwardBarButtonItem;
@property (nonatomic, strong, readonly) UIBarButtonItem *refreshBarButtonItem;
@property (nonatomic, strong, readonly) UIBarButtonItem *stopBarButtonItem;
@property (nonatomic, strong, readonly) UIBarButtonItem *actionBarButtonItem;

@property (nonatomic, strong, readonly) UIWebView *webView;
@property (nonatomic, strong) NSURL *URL;

- (id)initWithURL:(NSURL *)URL;

@end

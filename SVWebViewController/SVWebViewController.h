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

@property (nonatomic, retain, readonly) UIBarButtonItem *backBarButtonItem;
@property (nonatomic, retain, readonly) UIBarButtonItem *forwardBarButtonItem;
@property (nonatomic, retain, readonly) UIBarButtonItem *refreshBarButtonItem;
@property (nonatomic, retain, readonly) UIBarButtonItem *stopBarButtonItem;
@property (nonatomic, retain, readonly) UIBarButtonItem *actionBarButtonItem;

@property (nonatomic, retain, readonly) UIWebView *webView;
@property (nonatomic, retain) NSURL *URL;

- (id)initWithURL:(NSURL *)URL;

@end

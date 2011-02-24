//
//  SVWebViewController.h
//
//  Created by Sam Vermette on 08.11.10.
//  Copyright 2010 Sam Vermette. All rights reserved.
//

#import <MessageUI/MessageUI.h>


@interface SVWebViewController : UIViewController <UIWebViewDelegate, UIActionSheetDelegate, MFMailComposeViewControllerDelegate> {
	IBOutlet UIWebView *rWebView;
	IBOutlet UIBarButtonItem *backButton, *forwardButton, *refreshStopButton, *actionButton;
	IBOutlet UIToolbar *toolbar;
}

@property (nonatomic, retain) NSString *urlString;

- (id)initWithAddress:(NSString*)string;

@end

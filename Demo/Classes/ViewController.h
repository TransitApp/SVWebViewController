//
//  RootViewController.h
//  SVWebViewController
//
//  Created by Sam Vermette on 21.02.11.
//  Copyright 2011 Sam Vermette. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SVModalWebViewController.h"

@interface ViewController : UIViewController <SVModalWebViewControllerDelegate> {
	
}

- (IBAction)pushWebViewController;
- (IBAction)presentWebViewController;

@end

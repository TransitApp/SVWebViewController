//
//  RootViewController.m
//  SVWebViewController
//
//  Created by Sam Vermette on 21.02.11.
//  Copyright 2011 Sam Vermette. All rights reserved.
//

#import "ViewController.h"
#import "SVWebViewController.h"

@implementation ViewController


- (void)pushWebViewController {

	SVWebViewController *webViewController = [[SVWebViewController alloc] initWithAddress:@"http://en.wikipedia.org/wiki/Friday_(Rebecca_Black_song)"];
	[self.navigationController pushViewController:webViewController animated:YES];
	[webViewController release];
}


- (void)presentWebViewController {
	
	SVWebViewController *webViewController = [[SVWebViewController alloc] initWithAddress:@"http://wikipedia.org"];
	webViewController.modalPresentationStyle = UIModalPresentationPageSheet;
	[self presentModalViewController:webViewController animated:YES];	
	[webViewController release];
}

@end


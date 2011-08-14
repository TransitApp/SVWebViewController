//
//  SVModalWebViewController.h
//  iGithub
//
//  Created by Oliver Letterer on 13.08.11.
//  Copyright 2011 Home. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SVModalWebViewController;

@protocol SVModalWebViewControllerDelegate <NSObject>
- (void)modalWebViewControllerIsDone:(SVModalWebViewController *)viewController;
@end



@interface SVModalWebViewController : UINavigationController {
@private
    id<SVModalWebViewControllerDelegate> __weak _webDelegate;
}

@property (nonatomic, weak) id<SVModalWebViewControllerDelegate> webDelegate;

- (id)initWithURL:(NSURL *)URL;

@end

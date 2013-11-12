//
//  SVWebViewControllerActivity.m
//  SVWeb
//
//  Created by Sam Vermette on 11/11/2013.
//
//

#import "SVWebViewControllerActivity.h"

@implementation SVWebViewControllerActivity

- (NSString *)activityType {
	return NSStringFromClass([self class]);
}

- (UIImage *)activityImage {
	return [UIImage imageNamed:self.activityType];
}

- (void)prepareWithActivityItems:(NSArray *)activityItems {
	for (id activityItem in activityItems) {
		if ([activityItem isKindOfClass:[NSURL class]]) {
			self.URLToOpen = activityItem;
		}
	}
}

@end

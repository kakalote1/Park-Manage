//
//  WebViewController.h
//  yzExpoIOS
//
//  Created by 王思远 on 2021/4/1.
//  Copyright © 2021 DATA. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WebViewController : UIViewController

- (void)initWebView: (NSString *) urlStr withTitle: (NSString *) title;

@end

NS_ASSUME_NONNULL_END

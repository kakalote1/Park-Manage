//
//  WebViewController.m
//  yzExpoIOS
//
//  Created by 王思远 on 2021/4/1.
//  Copyright © 2021 DATA. All rights reserved.
//

#import "WebViewController.h"
#import <WebKit/WebKit.h>



@interface WebViewController ()<WKNavigationDelegate,WKUIDelegate, WKScriptMessageHandler>

@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) WKWebViewConfiguration *wkWebViewConfiguration;
@property (nonatomic, strong) WKUserContentController *wkUserContentController;
@property (nonatomic, strong) UIImageView *iv;
@property (nonatomic, strong) NSUserDefaults *userDefaults;
@property (nonatomic, strong) WKPreferences *perferences;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;


@end

@implementation WebViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.tabBarController.tabBar.hidden = YES;
    [self.activityIndicator startAnimating];
}

- (void)viewDidAppear:(BOOL)animated {
    [self.activityIndicator stopAnimating];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    
}

- (void)viewWillDisappear:(BOOL)animated{
}

- (void)initWebView: (NSString *) urlStr withTitle: (NSString *) title{
    
//    [self doLogin];
    //配置wkWebViewConfiguration
    [self wkConfiguration];
    self.navigationController.title = @"title";
    //初始化webView
    self.webView = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:self.wkWebViewConfiguration];
    self.webView.backgroundColor = [UIColor whiteColor];
    
    //关闭左划回退功能
    self.webView.allowsBackForwardNavigationGestures = YES;
    self.webView.navigationDelegate = self;
    self.webView.UIDelegate = self;
    
    [self.webView goBack];
    [self.webView goForward];
    [self.webView reload];

    
    //    设置 URL 访问，如要修改访问地址，需要修改 常量/Constants.h/BASE_WEB_URL
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:500];
    [self.webView loadRequest:request];
    
    //解决 iOS 11 屏幕顶部显示不全
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 11.0) {
        
        self.webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    self.perferences.javaScriptCanOpenWindowsAutomatically=YES;
    [self.view addSubview:self.webView];
    [self.view addSubview:self.iv];
    
    //OC注册供JS调用的方法
    [self addScriptFunction];
}

- (void)wkConfiguration {
    self.wkWebViewConfiguration = [[WKWebViewConfiguration alloc]init];
    
    WKPreferences *preferences = [[WKPreferences alloc] init];
    preferences.javaScriptCanOpenWindowsAutomatically = YES;
    self.wkWebViewConfiguration.preferences = preferences;
    
}

#pragma mark -  OC注册供JS调用的方法
- (void)addScriptFunction {
    self.wkUserContentController = [self.webView configuration].userContentController;
    
    [self.wkUserContentController addScriptMessageHandler:self name:@"goHome"];
}

#pragma mark --- WKScriptMessageHandler ---
//OC在JS调用方法做的处理
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
{
    NSLog(@"message.name = %@",message.name);
    NSLog(@"message.body = %@",message.body);
    
    // 根据name做想做的操作
    //前端主动JS发送消息，前端指令动作
    if ([@"goHome" isEqualToString:message.name]) {
        [self goHome];
    }

}

- (void)goHome {
    [self.navigationController popViewControllerAnimated:YES];
}

- (UIActivityIndicatorView *)activityIndicator {
    if (!_activityIndicator) {
        _activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:(UIActivityIndicatorViewStyleWhiteLarge)];
        _activityIndicator.frame = CGRectMake(0, 0, 100.0f, 100.0f);
          //设置小菊花的frame
        _activityIndicator.center = self.view.center;
          //设置小菊花颜色
//          _activityIndicator.color = [UIColor redColor];
          //设置背景颜色
        _activityIndicator.backgroundColor = [UIColor colorWithWhite:0.33 alpha:0.9];        _activityIndicator.layer.cornerRadius = 10.0f;
        _activityIndicator.hidesWhenStopped = YES;
          //刚进入这个界面会显示控件，并且停止旋转也会显示，只是没有在转动而已，没有设置或者设置为YES的时候，刚进入页面不会显示
//          _activityIndicator.hidesWhenStopped = NO;
        [self.view addSubview:_activityIndicator];
    }

    return _activityIndicator;
  
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

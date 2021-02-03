//  ViewController.m
//  ImoocHybridIOSNative
//
//  Created by LGD_Sunday .
//  Copyright © LGD_Sunday. All rights reserved.
//

#import "TabFirst.h"
#import <WebKit/WebKit.h>
#import "Constants.h"
#import "GenerateTestUserSig.h"

@interface TabFirst ()<WKNavigationDelegate,WKUIDelegate, WKScriptMessageHandler>

@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) WKWebViewConfiguration *wkWebViewConfiguration;
@property (nonatomic, strong) WKUserContentController *wkUserContentController;
@property (nonatomic, strong) UIImageView *iv;
@property (nonatomic, strong) NSUserDefaults *userDefaults;
@property (nonatomic, strong) WKPreferences *perferences;

@end

@implementation TabFirst

- (UIImageView *)iv {
    if (!_iv) {
        _iv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"welcome.png"]];
        _iv.frame = self.view.bounds;
    }
    return _iv;
}

- (NSUserDefaults *)userDefaults {
    if (!_userDefaults) {
        _userDefaults = [NSUserDefaults standardUserDefaults];
    }
    return _userDefaults;
}

//- (void)doLogin
////{
////    NSString *userSign = [GenerateTestUserSig genTestUserSig:@"admin4"];
////    [TUIKit.sharedInstance login:@"admin4" userSig:userSign succ:^{
////        NSLog(@"------》登录成功");
////    } fail:^(int code, NSString *msg){
////        NSLog(@"------》登录失败, code: %d, msg: %@", code, msg);
////    }];
////}//

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.tabBarController.tabBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    
    [self initWebView];
}

- (void)viewWillDisappear:(BOOL)animated{
}


- (void)initWebView {
    
//    [self doLogin];
    //配置wkWebViewConfiguration
    [self wkConfiguration];
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
    NSURL *url = [NSURL URLWithString:BASE_WEB_URL];
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
    
    [self.wkUserContentController addScriptMessageHandler:self name:@"register"];
    [self.wkUserContentController addScriptMessageHandler:self name:@"login"];
    [self.wkUserContentController addScriptMessageHandler:self name:@"logout"];
    [self.wkUserContentController addScriptMessageHandler:self name:@"routeTo"];
}

#pragma mark -  Alert弹窗
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"提示" message:message ? : @"" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * action = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }];
    [alertController addAction:action];
    [self presentViewController:alertController animated:YES completion:nil];
}


#pragma mark - WKWebView
// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
}
// 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
}


// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    //    关闭欢迎图片
    self.iv.hidden = YES;
    
    [self isAutoLogin];
}
// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation {
}

// 接收到服务器跳转请求之后调用
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation{
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    //如果是跳转一个新页面
        if (navigationAction.targetFrame == nil) {
            [webView loadRequest:navigationAction.request];
        }
        NSLog(@"54321");
        decisionHandler(WKNavigationActionPolicyAllow);
}

- (WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(nonnull WKWebViewConfiguration *)configuration forNavigationAction:(nonnull WKNavigationAction *)navigationAction windowFeatures:(nonnull WKWindowFeatures *)windowFeatures
{
    NSLog(@"createWebViewWithConfiguration");
    if (!navigationAction.targetFrame.isMainFrame) {
        [webView loadRequest:navigationAction.request];
    }
    return nil;
}

#pragma mark 判断用户自动登录
- (void)isAutoLogin {
    NSString *username = [self.userDefaults objectForKey:AUTO_LOGIN];
    
    if (username == nil || [username isEqualToString:@""]) {
        return;
    }
    
    [self.webView evaluateJavaScript:[NSString stringWithFormat:@"nativeFunctionUserLogin('%@')", username] completionHandler:nil];
}

#pragma mark --- WKScriptMessageHandler ---
//OC在JS调用方法做的处理
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
{
    NSLog(@"message.name = %@",message.name);
    NSLog(@"message.body = %@",message.body);
    
    // 根据name做想做的操作
    //前端主动JS发送消息，前端指令动作
    if ([@"register" isEqualToString:message.name]) {
        [self register:message.body];
    } else if ([@"login" isEqualToString:message.name]) {
        [self login:message.body];
    } else if ([@"logout" isEqualToString:message.name]) {
        [self logout:message.body];
    }
//    else if ([@"routeTo" isEqualToString:message.name]) {
//        NSLog(@"body:%@",message.body);
//        [self routeTo:message.body];
//    }
}

#pragma mark - 获取跳转页title
- (NSString *)getTitle:(NSString *)sender{
    return sender;
}

#pragma mark - 调用原生跳转
//- (void)routeTo:(NSString *)sender{
//    self.hidesBottomBarWhenPushed=YES;
//    NSArray *urlAndTitle = [sender componentsSeparatedByString:@","];
//    NSLog(@"888,%@",urlAndTitle);
//    WebViewController *newViewController = [[WebViewController alloc] init];
//
//    [newViewController initWebView:urlAndTitle[0] withTitle:urlAndTitle[1]];
////    self.navigationController.navigationBarHidden = NO;
//    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:nil];
//    [self.navigationController pushViewController:newViewController animated:YES];
//    self.hidesBottomBarWhenPushed=NO;
//}

#pragma mark - 注册
- (void)register:(id)body {
    NSDictionary *dict = body;
    [self.userDefaults setObject:[dict objectForKey:@"password"] forKey:[dict objectForKey:@"username"]];
    [self.webView evaluateJavaScript:@"registerCallback(true)" completionHandler:nil];
}

#pragma mark - 登录
- (void)login:(id)body {
    NSDictionary *dict = body;
    
    // 根据用户名来获取在原生端保存的密码
    NSString *password = [self.userDefaults objectForKey:[dict objectForKey:@"username"]];
    // 如果获取到的密码为null，表示当前的用户未注册
    if (password == nil || [password isEqualToString:@""]) {
        [self.webView evaluateJavaScript:@"loginCallback('1')" completionHandler:nil];
        return;
    }
    
    // 如果原生保存的密码和用户输入的密码不相同，表示用户密码输入错误
    if (![password isEqualToString:[dict objectForKey:@"password"]]) {
        [self.webView evaluateJavaScript:@"loginCallback('2')" completionHandler:nil];
        return;
    }
    
    // 通过前面的判断表示，用户登录成功，保存当前登录的用户名称，并通知前端
    [self.userDefaults setObject:[dict objectForKey:@"username"] forKey: AUTO_LOGIN];
    [self.webView evaluateJavaScript:@"loginCallback('0')" completionHandler:nil];
}

#pragma mark - 退出登录
- (void)logout:(id)body {
    [self.userDefaults removeObjectForKey:AUTO_LOGIN];
    [self.webView evaluateJavaScript:@"logoutCallback(true)" completionHandler:nil];
}


@end


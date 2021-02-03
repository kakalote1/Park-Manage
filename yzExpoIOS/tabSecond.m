////
////  TabSecond.m
////  ImoocHybridIOSNative
////
////  Created by 陈书瑶 on 2020/12/16.
////  Copyright © 2020 LGD_Sunday. All rights reserved.
////
//
//#import "TabSecond.h"
//#import <WebKit/WebKit.h>
//#import "TUIConversationListController.h"
//#import "TPopView.h"
//#import "TPopCell.h"
//#import "Constants.h"
//#import "TNaviBarIndicatorView.h"
//#import <TUIChatController.h>
//
//
//@interface TabSecond ()<WKNavigationDelegate,WKUIDelegate, WKScriptMessageHandler,TUIConversationListControllerDelegate, TPopViewDelegate>
//
//@property (nonatomic, strong) TNaviBarIndicatorView *titleView;
//@property (nonatomic, strong) WKWebView *webView;
//@property (nonatomic, strong) WKWebViewConfiguration *wkWebViewConfiguration;
//@property (nonatomic, strong) WKUserContentController *wkUserContentController;
//@property (nonatomic, strong) UIImageView *iv;
//@property (nonatomic, strong) NSUserDefaults *userDefaults;
//
//@end
//
//@implementation TabSecond
//
////- (UITableViewCell *)tableView: (UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
////{
////    ConversationCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"ConversationCell" owner:nil options:nil] firstObject];
////
////    return cell;
////}
//
//- (void)viewDidLoad
//{
//    [super viewDidLoad];
//    
//    self.view.backgroundColor = [UIColor whiteColor];
//    
//    TUIConversationListController *vc = [[TUIConversationListController alloc] init];
//    vc.delegate = self;
//    [self addChildViewController:vc];
//    [self.view addSubview:vc.view];
//    vc.view.frame = self.view.bounds;
//    
//}
//
//#pragma mark - TUIConversationListControllerDelegate
//- (void)conversationListController:(TUIConversationListController *)conversationController didSelectConversation:(TUIConversationCell *)conversation
//{
//    TUIConversationCellData *data = conversation.convData;
//    TUIChatController *vc = [[TUIChatController alloc] initWithConversation:data];
//    vc.navigationItem.title = data.title;
//    [self.navigationController pushViewController:vc animated:YES];
//}
//
//@end

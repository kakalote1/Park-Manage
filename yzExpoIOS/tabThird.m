////
////  TabThird.m
////  ImoocHybridIOSNative
////
////  Created by 陈书瑶 on 2020/12/16.
////  Copyright © 2020 LGD_Sunday. All rights reserved.
////
//
//#import "TabThird.h"
//#import <ImSDK/ImSDK.h>
//#import <THeader.h>
//#import "TPopView.h"
//#import "TPopCell.h"
//#import "GenerateTestUserSig.h"
//#import <TUIKit.h>
//
//@interface TabThird () <TPopViewDelegate>
//
//@end
//
//@implementation TabThird
//
//- (void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//}
//
//- (void)viewDidLoad {
//    [super viewDidLoad];
//    
//    self.view.backgroundColor = [UIColor whiteColor];
//    
//    
//    [V2TIMManager.sharedInstance getFriendList:^(NSArray<V2TIMFriendInfo *> *infoList) {
//            NSLog(@"获取好友列表成功");
//        } fail:^(int code, NSString *desc) {
//            NSLog(@"获取好友列表失败,code: %d, desc: %@", code, desc);
//        }];
//    
//    UIButton *moreButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
//    [moreButton setImage:[UIImage imageNamed:TUIKitResource(@"more")] forState:UIControlStateNormal];
//    [moreButton addTarget:self action:@selector(onRightItem:) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *moreItem = [[UIBarButtonItem alloc] initWithCustomView:moreButton];
//    self.navigationItem.rightBarButtonItem = moreItem;
//
//   
//
//    //如果不加这一行代码，依然可以实现点击反馈，但反馈会有轻微延迟，体验不好。
//    self.tableView.delaysContentTouches = NO;
//    
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"添加" style:UIBarButtonItemStylePlain target:self action:@selector(actionAdd)];
//    // Do any additional setup after loading the view.
//}
//
///**
// *在导航栏中添加右侧按钮，使用popView展示进一步的内容
// */
////- (void)onRightItem:(UIButton *)rightBarButton;
////{
////    NSMutableArray *menus = [NSMutableArray array];
////    TPopCellData *friend = [[TPopCellData alloc] init];
////    friend.title = @"添加好友";
////    friend.image = TUIKitResource(@"new_friend");
////
////    [menus addObject:friend];
////
////    TPopCellData *group = [[TPopCellData alloc] init];
////    group.image = TUIKitResource(@"add_group");
////    group.title = NSLocalizedString(@"添加群组", nil);//@"添加群组";
////    [menus addObject:group];
////
////    CGFloat height = [TPopCell getHeight] * menus.count + TPopView_Arrow_Size.height;
////    CGFloat orginY = StatusBar_Height + NavBar_Height;
////    TPopView *popView = [[TPopView alloc] initWithFrame:CGRectMake(Screen_Width - 140, orginY, 130, height)];
////    CGRect frameInNaviView = [self.navigationController.view convertRect:rightBarButton.frame fromView:rightBarButton.superview];
////    popView.arrowPoint = CGPointMake(frameInNaviView.origin.x + frameInNaviView.size.width * 0.5, orginY);
////    popView.delegate = self;
////    [popView setData:menus];
////    [popView showInWindow:self.view.window];
////}
//
////- (void)popView:(TPopView *)popView didSelectRowAtIndex:(NSInteger)index
////{
////    if(index == 0){
////        //添加好友
////        UIViewController *add = [[SearchFriendViewController alloc] init];
////        [self.navigationController pushViewController:add animated:YES];
////    }
////    if(index == 1){
////        //添加群组
////        UIViewController *add = [[SearchGroupViewController alloc] init];
////        [self.navigationController pushViewController:add animated:YES];
////    }
////}
//
//- (void)actionAdd
//{
//    V2TIMFriendAddApplication *applicate = [[V2TIMFriendAddApplication alloc] init];
//    applicate.userID = @"admin6";
//    applicate.addWording = @"你好，我是任治厅";
//    applicate.friendRemark = @"厅子哥";
//    applicate.addType = V2TIM_FRIEND_TYPE_SINGLE;
//
//    [V2TIMManager.sharedInstance addFriend:applicate succ:^(V2TIMFriendOperationResult *result) {
//            NSLog(@"添加好友成功回调: userId:%@, code:%zd, info:%@",result.userID,result.resultCode,result.resultInfo);
//        } fail:^(int code, NSString *desc) {
//            NSLog(@"添加好友失败回调: code:%d, info:%@", code, desc);
//        }];
//}
///*
//#pragma mark - Navigation
//
//// In a storyboard-based application, you will often want to do a little preparation before navigation
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    // Get the new view controller using [segue destinationViewController].
//    // Pass the selected object to the new view controller.
//}
//*/
//
//@end

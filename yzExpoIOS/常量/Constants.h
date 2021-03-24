//
//  Constants.h
//  ImoocHybridIOSNative
//
//  Created by LGD_Sunday on 2019/5/28.
//  Copyright © 2019年 LGD_Sunday. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifndef HttpConstants_h
#define HttpConstants_h

//服务地址
//#define BASE_WEB_URL @"http://192.168.1.161/yzExpo/"
//#define BASE_WEB_URL @"http://192.168.1.221:8081/"
//#define BASE_WEB_URL @"http://123.207.189.27:7108/yzExpo/"
//#define BASE_WEB_URL @"http://localhost:8081"
#define BASE_WEB_URL @"http://192.168.1.200:8081/"




//个人中心地址
#define MINE_WEB_URL  @"http://192.168.1.161/yzExpo/#/mine/personalCenter"

// 自动登录Key
#define AUTO_LOGIN  @"autoLogin"

/** 处理本地存储 */
#define EMPTY_STRING        @""

#define STR(key)            NSLocalizedString(key, nil)

#define PATH_OF_APP_HOME    NSHomeDirectory()
#define PATH_OF_TEMP        NSTemporaryDirectory()
#define PATH_OF_DOCUMENT    [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]

#endif /* HttpConstants_h */

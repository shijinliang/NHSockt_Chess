//
//  NHConnectApi.m
//  socket五子棋
//
//  Created by 牛辉 on 16/5/24.
//  Copyright © 2016年 Niu. All rights reserved.
//

#import "NHConnectApi.h"
#import "NHsocketManager.h"
#import "NHSocketProtocolHeader.h"
@implementation NHConnectApi

+ (void)connectApi:(NSString *)hostIP passWord:(NSString *)passWord;
{
    BOOL isConnect = [[NHsocketManager defaultManager] connectSockettoHost:hostIP];
    //
    if (isConnect) {
        //校验身份
        [[NHsocketManager defaultManager] writeDataProtocolHeader:ConnectSIdConnect cId:ConnectCIdConnect message:passWord];
    }

}

@end

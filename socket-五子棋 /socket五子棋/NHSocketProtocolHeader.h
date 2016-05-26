//
//  NHSocketProtocolHeader.h
//  socket五子棋
//
//  Created by 牛辉 on 16/5/23.
//  Copyright © 2016年 Niu. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger ,ConnectSId){
    ConnectSIdConnect = 1//链接服务器相关的
};
typedef NS_ENUM(NSInteger ,ConnectCId){
    ConnectCIdConnect = 1//链接服务器
};
@interface NHSocketProtocolHeader : NSObject


@property (nonatomic,assign) UInt16 serviceId;
@property (nonatomic,assign) UInt16 commandId;
@end

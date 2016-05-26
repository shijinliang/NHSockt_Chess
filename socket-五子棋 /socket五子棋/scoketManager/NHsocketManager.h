//
//  NHsocketManager.h
//  socket五子棋
//
//  Created by 牛辉 on 16/5/23.
//  Copyright © 2016年 Niu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NHsocketManager : NSObject
/**
 *  获取单例对象
 */
+ (instancetype)defaultManager;
/**
 *  写数据
 */
- (void)writeDataProtocolHeader:(int16_t)sId cId:(int16_t)cId message:(NSString *)message;
/**
 *  连接对方
 */
- (BOOL)connectSockettoHost:(NSString *)host;
/**
 *  获取当前ip地址
 */
- (NSString *)getCurrentIP;
@end

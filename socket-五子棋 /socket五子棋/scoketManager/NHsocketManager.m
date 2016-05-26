//
//  NHsocketManager.m
//  socket五子棋
//
//  Created by 牛辉 on 16/5/23.
//  Copyright © 2016年 Niu. All rights reserved.
//

#import "NHsocketManager.h"
#import "AsyncSocket.h"
#import "NHInputStream.h"
#import "NHOutputStream.h"
#import "NHSocketProtocolHeader.h"
#import "NHOutputStream+write.h"
#import <ifaddrs.h>
#import <arpa/inet.h>
#include <arpa/inet.h>
#include <netdb.h>
#include <net/if.h>
#include <ifaddrs.h>
#import <dlfcn.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import "ShowPromptMessage.h"
// 屏幕高度
#define SCREEN_HEIGHT         [[UIScreen mainScreen] bounds].size.height

// 屏幕宽度
#define SCREEN_WIDTH          [[UIScreen mainScreen] bounds].size.width

@interface NHsocketManager()<AsyncSocketDelegate>

//声明客户端
@property (nonatomic ,strong) AsyncSocket *clientSocket;
//声明服务器端，可以接受数据
@property (nonatomic ,strong) AsyncSocket *serverSocket;
//记录链接到服务器的socket
@property (nonatomic ,strong) NSMutableArray *socketArr;

@end

@implementation NHsocketManager
+ (instancetype)defaultManager
{
    static NHsocketManager *manager = nil;
    @synchronized(self) {
        if (!manager) {
            manager = [[NHsocketManager alloc]init];
        }
    }
    return manager;
}
- (NSString *)getCurrentIP
{
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL) {
            if(temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    // Free memory
    freeifaddrs(interfaces);
    return address;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
//        //实例化服务端对象
        self.serverSocket=[[AsyncSocket alloc]initWithDelegate:self];
        [self.serverSocket readDataWithTimeout:-1 tag:0];
        //设置端口号  并且对端口进行监听
        [self.serverSocket acceptOnPort:6666 error:nil];
    }
    return self;
}
//客户端连接成功时调用的该方法
- (void)onSocket:(AsyncSocket *)sock didAcceptNewSocket:(AsyncSocket *)newSocket
{
    //客户端的ip地址
    // newsocker是客户端地址
    NSLog(@"%@",newSocket.connectedHost);
    //设置客户端对象的延迟时间
    [newSocket readDataWithTimeout:-1 tag:1];
    [self.socketArr addObject:newSocket];
    NSLog(@"客户端连接到本服务器");
}
//当自己是客户端时  成功链接到服务器
- (void)onSocket:(AsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port {
    NSLog(@"onSocket:%p didConnectToHost:%@ port:%hu",sock,host,port);
    int tempTag = [self.clientSocket isEqual:sock] ? 0 : 1;
    [sock readDataWithTimeout:-1 tag:tempTag];
}
//客户端发消息时调用的方法
- (void)onSocket:(AsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    int tempTag = [self.clientSocket isEqual:sock] ? 0 : 1;
    [sock readDataWithTimeout:-1 tag:tempTag];
    [self didReadData:data tag:tag ];
}
- (void)onSocket:(AsyncSocket *)sock didSecure:(BOOL)flag
{
    NSLog(@"onSocket:%p didSecure:YES", sock);
}

- (void)onSocket:(AsyncSocket *)sock willDisconnectWithError:(NSError *)err
{
    NSLog(@"将要断开链接:%@-%@", err.domain,err.userInfo);
}
- (void)onSocketDidDisconnect:(AsyncSocket *)sock
{
    //断开连接了
    NSLog(@"socket断开链接");
    [self.socketArr removeObject:sock];
}
- (BOOL)connectSockettoHost:(NSString *)host
{
    //实例化客户端对象
    self.clientSocket=[[AsyncSocket alloc]initWithDelegate:self];
    //host 为服务器IP地址  port为服务器监听的端口
    BOOL isConnect = [self.clientSocket connectToHost:host onPort:6666 error:nil];
    return isConnect;
}

#pragma mark - 发送数据
- (void)writeDataProtocolHeader:(int16_t)sId cId:(int16_t)cId message:(NSString *)message
{
    NSData *data=[message dataUsingEncoding:NSUTF8StringEncoding];
    //发送消息
    NHOutputStream *dataout = [[NHOutputStream alloc] init];
    //指定自定义协议  15-15
    [dataout writeTcpProtocolHeader:sId cId:cId];
    //传输数据
    [dataout directWriteBytes:data];
    NSData *tempData = [dataout toByteArray];
    [_clientSocket writeData: tempData withTimeout:-1 tag:0];
}
-(NSMutableArray *)socketArr
{
    if (!_socketArr) {
        _socketArr = [NSMutableArray array];
    }
    return _socketArr;
}
#pragma mark - 协议校验
- (void)didReadData:(NSData*)data tag:(long)tag
{
    //截取自定义协议的data
    NSRange range = NSMakeRange(0, 4);
    NSData *headerData = [data subdataWithRange:range];
    NHInputStream *inputData = [NHInputStream dataInputStreamWithData:headerData];
    NHSocketProtocolHeader* tcpHeader = [[NHSocketProtocolHeader alloc] init];
    tcpHeader.serviceId = [inputData readShort];
    tcpHeader.commandId = [inputData readShort];
    uint32_t pduLen = (int)[data length];
    NSLog(@"%d,%d",tcpHeader.serviceId, tcpHeader.commandId);
    //截取协议后面的内容
    range = NSMakeRange(4, pduLen - 4);
    NSData *payloadData = [data subdataWithRange:range];
    //内容
    id  aStr = [[NSString alloc] initWithData:payloadData encoding:NSUTF8StringEncoding];
    if (tag == 1) {//来自客户端发来的信息
        [self fromeclient:tcpHeader.serviceId cId:tcpHeader.commandId message:aStr];
    } else {//来自服务端发来的信息
        [self fromeServer:tcpHeader.serviceId  cId:tcpHeader.commandId message:aStr];
    }
}
- (void)fromeServer:(int)sId cId:(int)cid message:(NSString *)message
{
    if (sId == 1 && cid == 2) {
//        AsyncSocket *socket = self.socketArr[0];
        [self.clientSocket disconnect];
        NSLog(@"%@",message);
    } else if (sId == 1 && cid == 3) {
        NSLog(@"%@",message);
    }
    [[ShowPromptMessage sharedManager] showPromptMessage:message WithPoint:CGSizeMake(SCREEN_WIDTH,SCREEN_HEIGHT)];
}
- (void)fromeclient:(int)sId cId:(int)cid message:(NSString *)message
{
    if (sId==1&&cid==1) {//链接的协议
        if ([message isEqualToString:@"牛辉真帅"]) {//校验链接身份
            NSData *data=[@"口令验证成功" dataUsingEncoding:NSUTF8StringEncoding];
            //发送消息
            NHOutputStream *dataout = [[NHOutputStream alloc] init];
            [dataout writeTcpProtocolHeader:1 cId:3];
            //传输数据
            [dataout directWriteBytes:data];
            NSData *tempData = [dataout toByteArray];
            AsyncSocket *socket = self.socketArr[0];
            [socket writeData:tempData withTimeout:-1 tag:0];
        } else {
            NSData *data=[@"口令验证失败" dataUsingEncoding:NSUTF8StringEncoding];
            //发送消息
            NHOutputStream *dataout = [[NHOutputStream alloc] init];
            //指定自定义协议  15-15
            [dataout writeTcpProtocolHeader:1 cId:2];
            //传输数据
            [dataout directWriteBytes:data];
            NSData *tempData = [dataout toByteArray];
            AsyncSocket *socket = self.socketArr[0];
            [socket writeData:tempData withTimeout:-1 tag:0];
        }
    } else {
        [[ShowPromptMessage sharedManager] showPromptMessage:[NSString stringWithFormat:@"%d-%d-%@",cid,sId,message] WithPoint:CGSizeMake(SCREEN_WIDTH,SCREEN_HEIGHT)];
    }
}
@end

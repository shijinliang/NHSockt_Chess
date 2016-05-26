//
//  NHInputStream.h
//  socket五子棋
//
//  Created by 牛辉 on 16/5/23.
//  Copyright © 2016年 Niu. All rights reserved.
//

#import <Foundation/Foundation.h>
// 从输入流读取基本数据类型的方法，以便解组自定义值类型
@interface NHInputStream : NSObject
{
    NSData *data;
    NSInteger length;
}
- (id)initWithData:(NSData *)data;
+ (id)dataInputStreamWithData:(NSData *)aData;

// 从输入流读取 char 值。
- (int8_t)readChar;

//从输入流读取 short 值。
- (int16_t)readShort;

//从输入流读取 int 值。
- (int32_t)readInt;

//从输入流读取 long 值。
- (int64_t)readLong;

//从输入流读取 NSString 字符串。
- (NSString *)readUTF;

//取得可读的长度
-(NSUInteger)getAvailabledLen;

-(NSData *)readDataWithLength:(int)len;

//取得剩下的数据
-(NSData *)readLeftData;

@end

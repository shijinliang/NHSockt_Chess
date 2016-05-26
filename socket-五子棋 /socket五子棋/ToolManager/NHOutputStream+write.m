//
//  NHOutputStream+write.m
//  socket五子棋
//
//  Created by 牛辉 on 16/5/23.
//  Copyright © 2016年 Niu. All rights reserved.
//

#import "NHOutputStream+write.h"

@implementation NHOutputStream (write)


-(void)writeTcpProtocolHeader:(int16_t)sId cId:(int16_t)cId
{
    [self writeShort:sId];
    [self writeShort:cId];
    
}
@end

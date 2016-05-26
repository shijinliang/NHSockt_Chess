//
//  GlobalToolClass.h
//  yunwoke
//
//  Created by yunzujia on 15/8/31.
//  Copyright (c) 2015年 Michael Hu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/** 开始游戏通知 */
extern NSString *const KSStartGameNotification;

/** 结束游戏通知 */
extern NSString *const KSEndGameNotification;

@interface GlobalToolClass : NSObject
+ (CGSize) getLabel:(UILabel*)label Size:(CGSize)size;
+ (CGSize) getString:(NSString *)content Size:(CGSize)size WithFont:(UIFont *)font;
+ (NSString *)getFormateDate:(long)dateTime;
/**
 *  根据分类id返回分类图标
 *
 *  @param categoryID 分类id
 *  @param isBig      是否大图
 *
 *  @return 图标名字
 */
+ (NSString *)getCategoryImageName:(NSInteger)categoryID IsBig:(BOOL)isBig;
/**
 *  获取分类对应的颜色
 *
 *  @param categoryID categoryID description
 *
 *  @return 颜色编码
 */
+ (NSString *)getCategoryColor:(NSInteger)categoryID;
@end

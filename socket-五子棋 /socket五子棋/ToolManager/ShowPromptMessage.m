//
//  ShowPromptMessage.m
//  hometest
//
//  Created by yunzujia on 15/6/21.
//  Copyright (c) 2015年 shi. All rights reserved.
//

#import "ShowPromptMessage.h"
#import "GlobalToolClass.h"
@implementation ShowPromptMessage
+(ShowPromptMessage*)sharedManager
{
    static ShowPromptMessage*showMessage = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        showMessage = [[super allocWithZone:NULL] init];
    });
    return showMessage;
}
+(instancetype)allocWithZone:(struct _NSZone *)zone
{
    return [self sharedManager];
}
-(void)showPromptMessage:(NSString *)message WithPoint:(CGSize)size
{
    UIWindow * window = [UIApplication sharedApplication].windows.lastObject;
    UIView *showview =  [[UIView alloc]init];
    showview.backgroundColor = [UIColor blackColor];
    showview.frame = CGRectMake(1, 1, 1, 1);
    showview.alpha = 0.7f;
    showview.layer.cornerRadius = 5.0f;
    showview.layer.masksToBounds = YES;
    [window addSubview:showview];
    
    UILabel *label = [[UILabel alloc]init];
    CGSize LabelSize = [message sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]}];
    //    label.frame = CGRectMake(10, 5, LabelSize.width, LabelSize.height);
    label.text = message;
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:15];
    label.numberOfLines = 0;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    //计算标签文本宽高
    CGSize labelSize = [GlobalToolClass getLabel:label Size:CGSizeMake(size.width - 75, 100)];
    label.frame = CGRectMake(0, 10, labelSize.width + 10, labelSize.height);
    [showview addSubview:label];
    
    //    showview.frame = CGRectMake((size.width - labelSize.width )/2 - 10,(size.height - 100),labelSize.width+20,labelSize.height+10);
    showview.frame = CGRectMake((size.width - label.bounds.size.width)/2, (size.height - labelSize.height)/2 - 10, label.bounds.size.width, labelSize.height + 20);
    [UIView animateWithDuration:2.0 animations:^{
        showview.alpha = 0;
    } completion:^(BOOL finished) {
        [showview removeFromSuperview];
    }];
}
@end

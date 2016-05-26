//
//  GlobalToolClass.m
//  yunwoke
//
//  Created by yunzujia on 15/8/31.
//  Copyright (c) 2015年 Michael Hu. All rights reserved.
//

#import "GlobalToolClass.h"
#define isIOS7 [[UIDevice currentDevice].systemVersion doubleValue]>=7.0?YES:NO

@implementation GlobalToolClass
//-(void)postParam:(NSString *)Parameters WithUrl:(NSURL *)url Sucessful:(void (^)(NSDictionary *))Sucessful failure:(void (^)(NSString *))failure

//获取label的宽高
+ (CGSize) getLabel:(UILabel*)label Size:(CGSize)size
{
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.alignment = NSLineBreakByWordWrapping;
    NSDictionary *attribute = @{
                                NSFontAttributeName: label.font,
                                NSParagraphStyleAttributeName: paragraph
                                };
    CGSize labelSize;
    if(isIOS7){
        labelSize = [label.text boundingRectWithSize:size
                                             options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    }else{
        labelSize = [label.text sizeWithFont:label.font
                           constrainedToSize:size lineBreakMode:NSLineBreakByClipping];
    }
    
    return labelSize;
}

//根据字符串获取label的宽高
+ (CGSize) getString:(NSString *)content Size:(CGSize)size WithFont:(UIFont *)font
{
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.alignment = NSLineBreakByWordWrapping;
    NSDictionary *attribute = @{
                                NSFontAttributeName: font,
                                NSParagraphStyleAttributeName: paragraph
                                };
    CGSize labelSize;
    if(isIOS7){
        labelSize = [content boundingRectWithSize:size
                                          options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    }else{
        labelSize = [content sizeWithFont:font
                        constrainedToSize:size lineBreakMode:NSLineBreakByClipping];
    }
    
    return labelSize;
}

//根据时间戳判断属于几天前/几月前
+ (NSString *)getFormateDate:(long)dateTime
{
    NSDate *newsDate = [NSDate dateWithTimeIntervalSince1970:dateTime];
    NSDate* current_date = [[NSDate alloc] init];
    
    NSTimeInterval time=[current_date timeIntervalSinceDate:newsDate];//间隔的秒数
    int year =((int)time)/(3600*24*30*365);
    int month=((int)time)/(3600*24*30);
    int days=((int)time)/(3600*24);
    int hours=((int)time)%(3600*24)/3600;
    int minute=((int)time)%(3600*24)/60;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.dateFormat = @"yy-MM-dd";
    
    NSString *dateContent;
    
    if (year != 0){
        dateContent = [dateFormatter stringFromDate:newsDate];
    } else if(month!=0){
        dateContent = [NSString stringWithFormat:@"%@%i%@",@"发布于",month,@"个月前"];
    }else if(days!=0){
        
        dateContent = [NSString stringWithFormat:@"%@%i%@",@"发布于",days,@"天前"];
    }else if(hours!=0){
        
        dateContent = [NSString stringWithFormat:@"%@%i%@",@"发布于",hours,@"小时前"];
    }else {
        
        dateContent = [NSString stringWithFormat:@"%@%i%@",@"发布于",minute,@"分钟前"];
    }
    
    return dateContent;
}

+ (NSString *)getCategoryImageName:(NSInteger)categoryID IsBig:(BOOL)isBig
{
    //处理categoryID
    if(categoryID > 333 || categoryID < 323)
    {
        categoryID = 11;
    } else {
        categoryID = categoryID - 322;
    }
    //return [NSString stringWithFormat:@"category%@%ld",isBig?@"Big":@"",(long)categoryID];
    return [NSString stringWithFormat:@"category%ld", (long)categoryID];
}

+ (NSString *)getCategoryColor:(NSInteger)categoryID
{
    categoryID = categoryID - 322;
    switch (categoryID) {
        case 1:
            return @"5dd068";
            break;
        case 2:
            return @"f9b141";
            break;
        case 3:
            return @"dea3f7";
            break;
        case 4:
            return @"fcb94f";
            break;
        case 5:
            return @"fcb94f";
            break;
        case 6:
            return @"6d9ee9";
            break;
        case 7:
            return @"57c2f9";
            break;
        case 8:
            return @"969bff";
            break;
        case 9:
            return @"e38ef3";
            break;
        case 10:
            return @"4fda7d";
            break;
        case 11:
            return @"ded24d";
            break;
        default:
            return @"ded24d";
            break;
    }
}
@end

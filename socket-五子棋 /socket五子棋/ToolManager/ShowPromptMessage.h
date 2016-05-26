//
//  ShowPromptMessage.h
//  hometest
//
//  Created by luguoliang on 15/6/21.
//  Copyright (c) 2015年 baofoo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface ShowPromptMessage : NSObject
+(ShowPromptMessage*)sharedManager;
-(void)showPromptMessage:(NSString*)message WithPoint:(CGSize)size;
@end

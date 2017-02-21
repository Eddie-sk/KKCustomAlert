//
//  KKDefaultAlertWithBlock.h
//  KKCustomAlert
//
//  Created by sunkai on 2017/2/21.
//  Copyright © 2017年 Kook. All rights reserved.
//

#import <Foundation/Foundation.h>

@class KKAlertView;

typedef void(^KKAlertViewBlock)(KKAlertView *alertView, NSInteger buttonIndex);

@interface KKDefaultAlertWithBlock : NSObject

+ (void)showWithTitle:(NSString *)title message:(NSString *)message block:(KKAlertViewBlock)comp;


@end

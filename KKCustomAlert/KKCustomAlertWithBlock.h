//
//  KKCustomAlertWithBlock.h
//  KKCustomAlert
//
//  Created by sunkai on 2017/2/21.
//  Copyright © 2017年 Kook. All rights reserved.
//

#import <Foundation/Foundation.h>
@class KKAlertView;

typedef void(^KKCustomAlertViewBlock)(KKAlertView *alertView, NSInteger buttonIndex);

@interface KKCustomAlertWithBlock : NSObject


+ (void)showWithTitle:(NSString *)title block:(KKCustomAlertViewBlock)comp;

@end

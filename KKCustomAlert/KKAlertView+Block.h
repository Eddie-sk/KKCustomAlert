//
//  KKAlertView+Block.h
//  KKCustomAlert
//
//  Created by sunkai on 2017/2/16.
//  Copyright © 2017年 Kook. All rights reserved.
//

#import "KKAlertView.h"
typedef void (^KKAlertViewCompletionBlock) (NSString *message, NSInteger buttonIndex);

@interface KKAlertView (Block)

+ (void)showWithTitle:(NSString *)title block:(KKAlertViewCompletionBlock)comp;

@end

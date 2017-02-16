//
//  KKAlertView+Block.m
//  KKCustomAlert
//
//  Created by sunkai on 2017/2/16.
//  Copyright © 2017年 Kook. All rights reserved.
//

#import "KKAlertView+Block.h"
#import <objc/runtime.h>
static const void *KKAlertViewOriginalDelegateKey                   = &KKAlertViewOriginalDelegateKey;

static const void *KKAlertViewMessageBlockKey                           = &KKAlertViewMessageBlockKey;

@implementation KKAlertView (Block)

+ (void)showWithTitle:(NSString *)title block:(KKAlertViewCompletionBlock)comp {
    KKAlertView *alertView = [[KKAlertView alloc] initWithTitle:title message:nil cancelButtonTitle:@"cancel" otherButtonTitles:@"OK", nil];
    alertView.alertViewStyle = KKAlertViewStyleTextInput;
    alertView.placeholder = @"placeholder";
    alertView.placeholder = alertView.defaultMessage;
    alertView.messageMaxSize = 20;
    if (comp) {
        alertView.messageBlock = comp;
    }
    [alertView show];
}
- (void)_checkAlertViewDelegate {
    if (self.delegate != (id<KKAlertViewDelegate>)self) {
        objc_setAssociatedObject(self, KKAlertViewOriginalDelegateKey, self.delegate, OBJC_ASSOCIATION_ASSIGN);
        self.delegate = (id<KKAlertViewDelegate>)self;
    }
}

- (KKAlertViewCompletionBlock)messageBlock {
    
    return objc_getAssociatedObject(self, KKAlertViewMessageBlockKey);
    
}

- (void)setMessageBlock:(KKAlertViewCompletionBlock)messageBlock {
    [self _checkAlertViewDelegate];
    objc_setAssociatedObject(self, KKAlertViewMessageBlockKey, messageBlock, OBJC_ASSOCIATION_COPY);
    
}

- (void)alertView:(KKAlertView *)alertView didClickButtonAtIndex:(NSInteger)index withMessage:(NSString *)message {
    KKAlertViewCompletionBlock completion = alertView.messageBlock;
    
    if (completion) {
        completion(message, index);
    }
    
    id originalDelegate = objc_getAssociatedObject(self, KKAlertViewOriginalDelegateKey);
    if (originalDelegate && [originalDelegate respondsToSelector:@selector(alertView:didClickButtonAtIndex:withMessage:)]) {
        [originalDelegate alertView:alertView didClickButtonAtIndex:index withMessage:message];
    }
}

@end

//
//  KKDefaultAlertWithBlock.m
//  KKCustomAlert
//
//  Created by sunkai on 2017/2/21.
//  Copyright © 2017年 Kook. All rights reserved.
//

#import "KKDefaultAlertWithBlock.h"
#import "KKAlertView.h"

@interface KKDefaultAlertWithBlock()<KKAlertViewDelegate>

@property (copy, nonatomic) KKAlertViewBlock alertlock;

@end

static KKDefaultAlertWithBlock *defaultAlert = nil;


@implementation KKDefaultAlertWithBlock

+ (void)showWithTitle:(NSString *)title message:(NSString *)message block:(KKAlertViewBlock)comp {
    defaultAlert = [[KKDefaultAlertWithBlock alloc] init];
    KKAlertView *alert = [[KKAlertView alloc] initWithTitle:title message:message cancelButtonTitle:@"kCancel" otherButtonTitles:@"kOK", nil];
    if (comp) {
        defaultAlert.alertlock = comp;
    }
    alert.delegate = defaultAlert;
    [alert show];
}

- (void)alertView:(KKAlertView *)alertView didClickButtonAtIndex:(NSInteger)index withMessage:(NSString *)message {
    if (defaultAlert.alertlock) {
        defaultAlert.alertlock(alertView, index);
        defaultAlert = nil;
    }
}


@end

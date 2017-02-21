//
//  KKCustomAlertWithBlock.m
//  KKCustomAlert
//
//  Created by sunkai on 2017/2/21.
//  Copyright © 2017年 Kook. All rights reserved.
//

#import "KKCustomAlertWithBlock.h"
#import "KKAlertView.h"
#import <Masonry/Masonry.h>

@interface KKCustomAlertWithBlock()<KKAlertViewDelegate>

@property (copy, nonatomic) KKCustomAlertViewBlock alertlock;

@end
static KKCustomAlertWithBlock *customAlert = nil;

@implementation KKCustomAlertWithBlock

+ (void)showWithTitle:(NSString *)title block:(KKCustomAlertViewBlock)comp {
    customAlert = [[KKCustomAlertWithBlock alloc] init];
    KKAlertView *alert = [[KKAlertView alloc] initWithTitle:title message:nil cancelButtonTitle:@"kCancel" otherButtonTitles:@"kOK", nil];
    alert.alertViewStyle = KKAlertViewStyleCustomContent;
    if (comp) {
        customAlert.alertlock = comp;
    }
    alert.delegate = customAlert;
    [alert show];
    [customAlert addCustomViewWithAlert:alert];
}

- (void)addCustomViewWithAlert:(KKAlertView *)alert {
    UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
    [alert addContentView:view];
    
    UILabel *label = [[UILabel alloc] init];
    label.text = @"KKCustomAlertViewWithBlock test Customview";
    label.numberOfLines = 0;
    [view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(view).offset(20);
        make.right.mas_equalTo(view).offset(-20);
        make.top.mas_equalTo(view).offset(0);
        make.bottom.mas_equalTo(view).offset(-20);
    }];
}

- (void)alertView:(KKAlertView *)alertView didClickButtonAtIndex:(NSInteger)index withMessage:(NSString *)message {
    if (customAlert.alertlock) {
        customAlert.alertlock(alertView, index);
        customAlert = nil;
    }
}

@end

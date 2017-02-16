//
//  KKAlertView.h
//  KKCustomAlert
//
//  Created by sunkai on 2017/2/15.
//  Copyright © 2017年 Kook. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, KKAlertViewStyle) {
    KKAlertViewStyleDefault = 0,
    KKAlertViewStyleTextInput,
    KKAlertViewStyleCustomContent
};

typedef void(^KKAlertViewBlockWithMessage)(NSString *message, NSInteger buttonIndex);

@interface KKAlertView : UIView

+ (void)showWithTitle:(NSString *)title block:(KKAlertViewBlockWithMessage)comp;

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles,...NS_REQUIRES_NIL_TERMINATION;

- (void)show;

- (void)addContentView:(UIView *)subView;

- (UITextField *)getAlertTextField;

@property (nonatomic, assign) KKAlertViewStyle alertViewStyle;


@end

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
@class KKAlertView;

@protocol KKAlertViewDelegate <NSObject>

- (void)alertView:(KKAlertView *)alertView didClickButtonAtIndex:(NSInteger)index withMessage:(NSString *)message;

@end


@interface KKAlertView : UIView

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles,...NS_REQUIRES_NIL_TERMINATION;

- (void)show;

- (void)addContentView:(UIView *)subView;

- (UITextField *)getAlertTextField;

@property (nonatomic, assign) KKAlertViewStyle alertViewStyle;
@property (nonatomic, copy) NSString *defaultMessage;
@property (nonatomic, copy) NSString *placeholder;
@property (nonatomic, assign) NSInteger messageMaxSize;
@property (nonatomic, assign) id<KKAlertViewDelegate> delegate;


@end

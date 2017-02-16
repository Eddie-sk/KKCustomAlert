//
//  KKCreateGroupMeetingAlert.m
//  Kook
//
//  Created by sunkai on 2017/2/15.
//  Copyright © 2017年 Kook. All rights reserved.
//

#import "KKCreateGroupMeetingAlert.h"
#import "KKAlertView.h"

#define kKeyWindow [[UIApplication sharedApplication].delegate window];
#define kScreenWidth [UIScreen mainScreen].bounds.size.width;

static const CGFloat kAlertMargin = 40.0f;

@interface KKCreateGroupMeetingAlert()

@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) KKAlertView *alertView;

@property (nonatomic, copy) KKCreateGroupMeetingAlertBlock block;

@end


@implementation KKCreateGroupMeetingAlert

+ (void)showWithBlock:(KKCreateGroupMeetingAlertBlock)comp {
    KKCreateGroupMeetingAlert * alert = [[KKCreateGroupMeetingAlert alloc] init];
    alert.block = comp;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initViews];
        ;
    }
    return self;
}

- (void)initViews {
    [self addSubview:self.backgroundView];
    [self addSubview:self.alertView];
}

- (void)show {
    
    UIWindow *window = kKeyWindow;
    if (window) {
        [window addSubview:self];
    }
}

#pragma mark - Action

- (void)cancelAction {
    if (self.block) {
        self.block(0);
    }
}

- (void)sendAction {
    if (self.block) {
        self.block(1);
    }
}

#pragma mark - Getter

- (UIView *)backgroundView {
    if (!_backgroundView) {
        _backgroundView = [[UIView alloc] init];
        _backgroundView.backgroundColor = [UIColor colorWithWhite:0.3 alpha:1];
    }
    return _backgroundView;
}

- (KKAlertView *)alertView {
    if (!_alertView) {
        _alertView = [[KKAlertView alloc] init];
    }
    return _alertView;
}




@end

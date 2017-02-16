//
//  KKAlertView.m
//  KKCustomAlert
//
//  Created by sunkai on 2017/2/15.
//  Copyright © 2017年 Kook. All rights reserved.
//

#import "KKAlertView.h"
#import "KKButton.h"
#import "UIView+LayoutMethods.h"
#import <Masonry/Masonry.h>

#define kKeyWindow [[UIApplication sharedApplication].delegate window];
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

static const CGFloat kAlertMargin = 50.0f;
static const CGFloat kAlertSubViewMargin = 20.0f;
static const CGFloat kAlertSpaceLineWidth = 0.5f;
static const CGFloat kAlertButtonHeight = 45.0f;

@interface KKAlertView()<UITextFieldDelegate>

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *message;

@property (nonatomic, strong) NSMutableArray *buttons;

@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) UIView *alertView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIView *buttonView;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UILabel *textFieldMaxSize;
@property (nonatomic, strong) NSMutableArray *buttonTitles;


@end

@implementation KKAlertView

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles,... {
    self = [super initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    if (self) {
        _title = title;
        _message = message;
        _messageMaxSize = INT_MAX;
        if (cancelButtonTitle.length > 0) {
            if (!_buttonTitles) {
                _buttonTitles = [NSMutableArray array];
            }
            [_buttonTitles addObject:cancelButtonTitle];
        }
        if(otherButtonTitles.length > 0)
        {
            if (!_buttonTitles) {
                _buttonTitles = [NSMutableArray array];
            }
            NSString *str;
            va_list list;
            [self.buttonTitles addObject:otherButtonTitles];
            
            va_start(list, otherButtonTitles);
            while ((str = va_arg(list, NSString *))){
                [self.buttonTitles addObject:str];
            }
            va_end(list);
        }
        [self initViews];
    }
    return self;
    
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initViews];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initViews];
    }
    return self;
}

- (void)updateConstraints {
    [self.backgroundView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(@(0));
        make.trailing.equalTo(@(0));
        make.top.equalTo(@(0));
        make.bottom.equalTo(@(0));
    }];
    
    [self.alertView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.centerY.mas_equalTo(self);
        make.leading.mas_equalTo(@(kAlertMargin));
        make.trailing.mas_equalTo(@(-kAlertMargin));
        make.height.lessThanOrEqualTo(@(kScreenHeight - 40));
    }];
    
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.alertView).offset(kAlertSubViewMargin);
        make.trailing.mas_equalTo(self.alertView).offset(-kAlertSubViewMargin);
        make.top.mas_equalTo(self.alertView).offset(kAlertSubViewMargin);
        make.height.mas_lessThanOrEqualTo(self.alertView);
    }];
    
    [self.contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.alertView).offset(0);
        make.trailing.mas_equalTo(self.alertView).offset(0);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(kAlertSubViewMargin);
    }];
    
    [self.buttonView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.alertView).offset(0);
        make.trailing.mas_equalTo(self.alertView).offset(0);
        make.top.equalTo(self.contentView.mas_bottom).offset(kAlertSubViewMargin);
        make.bottom.mas_equalTo(self.alertView).offset(0);
    }];
    
    
    [super updateConstraints];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    NSLog(@"");
}

#pragma mark - BuildUI

- (void)initViews {
    self.backgroundColor = [UIColor clearColor];
    self.titleLabel.text = self.title;
    if (self.message.length > 0) {
        self.contentLabel.text = self.message;
    }
    if (self.buttonTitles.count > 0) {
        [self updateButtonView];
    }
    self.alertViewStyle = KKAlertViewStyleDefault;
}

- (void)addSubview:(UIView *)view {
    if (view != _alertView) {
        return;
    }
    [super addSubview:view];
}

- (void)updateButtonView {
    if (self.buttonTitles.count == 2) {
        UIView *spaceLineView = [[UIView alloc] init];
        spaceLineView.backgroundColor = [UIColor blackColor];
        [self.buttonView addSubview:spaceLineView];
        spaceLineView.translatesAutoresizingMaskIntoConstraints = NO;
        [spaceLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(self.buttonView).offset(0);
            make.trailing.mas_equalTo(self.buttonView).offset(0);
            make.height.equalTo(@0.5);
            make.top.mas_equalTo(self.buttonView).offset(0);
        }];
        KKButton *button = [KKButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:self.buttonTitles.firstObject forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonActoin:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitleColor:[[UIColor blackColor] colorWithAlphaComponent:0.8] forState:UIControlStateHighlighted];
        button.translatesAutoresizingMaskIntoConstraints = NO;
        button.tag = 0;
        [self.buttonView addSubview:button];
        
        UIView *spaceLineView1 = [[UIView alloc] init];
        spaceLineView1.backgroundColor = [UIColor blackColor];
        [self.buttonView addSubview:spaceLineView1];
        KKButton *button1 = [KKButton buttonWithType:UIButtonTypeCustom];
        [button1 setTitleColor:[[UIColor blackColor] colorWithAlphaComponent:0.8] forState:UIControlStateHighlighted];
        [button1 addTarget:self action:@selector(buttonActoin:) forControlEvents:UIControlEventTouchUpInside];
        [button1 setTitle:self.buttonTitles[1] forState:UIControlStateNormal];
        [button1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        button1.translatesAutoresizingMaskIntoConstraints = NO;
        button1.tag = 1;
        [self.buttonView addSubview:button1];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(spaceLineView.mas_bottom).offset(0);
            make.leading.mas_equalTo(self.buttonView).offset(0);
            make.height.equalTo(@(kAlertButtonHeight));
            make.bottom.mas_equalTo(self.buttonView).offset(0);
        }];
        [spaceLineView1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(button.mas_trailing).offset(0);
            make.top.equalTo(spaceLineView.mas_bottom).offset(0);
            make.bottom.mas_equalTo(self.buttonView).offset(0);
            make.width.equalTo(@(kAlertSpaceLineWidth));
        }];
        [button1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(spaceLineView1.mas_trailing).offset(0);
            make.top.equalTo(spaceLineView.mas_bottom).offset(0);
            make.trailing.mas_equalTo(self.buttonView).offset(0);
            make.height.equalTo(@(kAlertButtonHeight));
            make.bottom.mas_equalTo(self.buttonView).offset(0);
            make.width.equalTo(button.mas_width);
        }];
        return ;
    }
    
    
    UIView *topView = self.buttonView;
    for (int i = 0; i < self.buttonTitles.count ; i++) {
        int j = (i == self.buttonTitles.count - 1) ? 0 : i + 1;
        NSString *title = self.buttonTitles[j];
        UIView *spaceLineView = [[UIView alloc] init];
        spaceLineView.backgroundColor = [UIColor blackColor];
        [self.buttonView addSubview:spaceLineView];
        spaceLineView.translatesAutoresizingMaskIntoConstraints = NO;
        [spaceLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(self.buttonView).offset(0);
            make.trailing.mas_equalTo(self.buttonView).offset(0);
            make.height.equalTo(@0.5);
            if (topView == self.buttonView) {
                make.top.mas_equalTo(self.buttonView).offset(0);
            } else {
                make.top.equalTo(topView.mas_bottom).offset(0);
            }
        }];
        
        KKButton *button = [KKButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:title forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setTitleColor:[[UIColor blackColor] colorWithAlphaComponent:0.8] forState:UIControlStateHighlighted];
        button.tag = ((i == self.buttonTitles.count - 1)) ? 0 : i + 1;
        [button addTarget:self action:@selector(buttonActoin:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.buttonView addSubview:button];
        button.translatesAutoresizingMaskIntoConstraints = NO;
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(spaceLineView.mas_bottom).offset(0);
            make.leading.mas_equalTo(self.buttonView).offset(0);
            make.trailing.mas_equalTo(self.buttonView).offset(0);
            make.height.equalTo(@45);
            if (i == (self.buttonTitles.count - 1)) {
                make.bottom.mas_equalTo(self.buttonView).offset(0);
            }
        }];
        topView = button;
    }
    
    
}

- (void)buttonActoin:(UIButton *)button {
    if ([self.delegate respondsToSelector:@selector(alertView:didClickButtonAtIndex:withMessage:)]) {
        NSString *message;
        if (_textField) {
            message = _textField.text;
        }
        [self.delegate alertView:self didClickButtonAtIndex:button.tag withMessage:message];
        [self removeFromSuperview];
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if ([textField.text isEqualToString:self.defaultMessage]) {
        textField.text = nil;
    }
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    _textFieldMaxSize.text = [NSString stringWithFormat:@"%d",(int)(20 - toBeString.length)];
    if (toBeString.length > _messageMaxSize && range.length!=1){
        textField.text = [toBeString substringToIndex:_messageMaxSize];
        _textFieldMaxSize.text = @"0";
        return NO;
    }
    
    return YES;
}

#pragma mark - Public Methods

- (void)show {
    
    UIWindow *window = kKeyWindow;
    if (window) {
        [window addSubview:self];
    }
    self.alpha = 0;
    _alertView.transform = CGAffineTransformScale(_alertView.transform,0.1,0.1);
    [UIView animateWithDuration:0.3 animations:^{
        _alertView.transform = CGAffineTransformIdentity;
        self.alpha = 1;
    }];
}

- (void)addContentView:(UIView *)subView {
    if (!self.alertViewStyle) return;
    [self.contentView addSubview:subView];
    [subView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.contentView).offset(0);
        make.top.mas_equalTo(self.contentView).offset(kAlertSubViewMargin);
        make.trailing.mas_equalTo(self.contentView).offset(0);
        make.bottom.mas_equalTo(self.contentView).offset(0);
    }];
}

- (UITextField *)getAlertTextField {
    if (_textField) {
        return _textField;
    }
    return nil;
}

#pragma mark - PrivateMethods

- (void)updateContentView {
    
    NSArray *views = self.contentView.subviews;
    if (views.count) {
        for (UIView *view in views) {
            [view removeFromSuperview];
        }
    }
    
    switch (self.alertViewStyle) {
        case KKAlertViewStyleDefault: {
            [self.contentView addSubview:self.contentLabel];
        }
            break;
        case KKAlertViewStyleTextInput: {
            [self.contentView addSubview:self.textField];
        }
            break;
            
        case KKAlertViewStyleCustomContent: {
            
        }
            break;
        default:
            break;
    }
}

- (void)hideAlertAction {
    [self removeFromSuperview];
}

#pragma mark - Setter

- (void)setAlertViewStyle:(KKAlertViewStyle)alertViewStyle {
    if (_alertViewStyle == alertViewStyle) return;
    
    _alertViewStyle = alertViewStyle;
    [self updateContentView];
}

#pragma mark - Getter

- (UIView *)alertView {
    if (!_alertView) {
        _alertView = [[UIView alloc] initWithFrame:CGRectZero];
        _alertView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.9];
        _alertView.layer.masksToBounds = YES;
        _alertView.layer.cornerRadius = 10;
        _alertView.userInteractionEnabled = YES;
        [self addSubview:_alertView];
    }
    return _alertView;
}

- (UIView *)backgroundView {
    if (!_backgroundView) {
        _backgroundView = [[UIView alloc] init];
        _backgroundView.backgroundColor = [[UIColor clearColor] colorWithAlphaComponent:0.3];
        [self insertSubview:_backgroundView atIndex:0];
    }
    return _backgroundView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.font = [UIFont boldSystemFontOfSize:17.0f];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.numberOfLines = 0;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self.alertView addSubview:_titleLabel];
    }
    return _titleLabel;
}

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] initWithFrame:CGRectZero];
        _contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self.alertView addSubview:_contentView];
    }
    return _contentView;
}

- (UIView *)buttonView {
    if (!_buttonView) {
        _buttonView = [[UIView alloc] initWithFrame:CGRectZero];
        _buttonView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self.alertView addSubview:_buttonView];
    }
    return _buttonView;
}

- (UILabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _contentLabel.numberOfLines = 0;
        _contentLabel.textAlignment = NSTextAlignmentCenter;
        _contentLabel.font = [UIFont systemFontOfSize:13.0f];
        [self.contentView addSubview:_contentLabel];
        _contentLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(self.contentView).offset(kAlertSubViewMargin);
            make.trailing.mas_equalTo(self.contentView).offset(-kAlertSubViewMargin);
            make.top.mas_equalTo(self.contentView).offset(0);
            make.bottom.mas_equalTo(self.contentView).offset(0);
        }];
    }
    return _contentLabel;
}

- (UITextField *)textField {
    if (!_textField) {
        UIView * _textView = [[UIView alloc] initWithFrame:CGRectZero];
        _textView.backgroundColor = [UIColor clearColor];
        _textView.layer.masksToBounds = YES;
        _textView.layer.borderWidth = 1.0f;
        _textView.layer.borderColor = [[UIColor blackColor] colorWithAlphaComponent:0.6].CGColor;
        [self.contentView addSubview:_textView];
        
        _textField = [[UITextField alloc] initWithFrame:CGRectZero];
        _textField.borderStyle = UITextBorderStyleNone;
        _textField.text = self.defaultMessage;
        _textField.placeholder = self.placeholder;
        [self.contentView addSubview:_textField];
        _textField.delegate = self;
        
        
        if (_messageMaxSize != INT_MAX) {
            _textFieldMaxSize = [[UILabel alloc] init];
            _textFieldMaxSize.text = @(_messageMaxSize).stringValue;
            _textFieldMaxSize.textColor = [UIColor grayColor];
            _textFieldMaxSize.textAlignment = NSTextAlignmentCenter;
            _textFieldMaxSize.font = [UIFont systemFontOfSize:16];
            [_textView addSubview:_textFieldMaxSize];
        }
        
        [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(self.contentView).offset(kAlertSubViewMargin);
            make.trailing.mas_equalTo(self.contentView).offset(-kAlertSubViewMargin);
            make.height.equalTo(@30);
            make.top.mas_equalTo(self.contentView).offset(0);
            make.bottom.mas_equalTo(self.contentView).offset(0);
        }];
        
        [_textField mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(_textView).offset(5);
            make.top.mas_equalTo(_textView).offset(0);
            make.bottom.mas_equalTo(_textView).offset(0);
//            make.width.equalTo(@(kScreenWidth - kAlertMargin * 2 - kAlertSubViewMargin * 2 - ((_messageMaxSize != INT_MAX) ? 30 : 0)));
            if (_messageMaxSize == INT_MAX) {
                make.trailing.mas_equalTo(_textView).offset(0);
            }
        }];
        
        if (_messageMaxSize != INT_MAX) {
            [_textFieldMaxSize mas_makeConstraints:^(MASConstraintMaker *make) {
                make.trailing.mas_equalTo(_textView).offset(0);
                make.width.equalTo(@30);
                make.height.equalTo(@30);
                make.centerY.mas_equalTo(_textView);
            }];
        }
    }
    return _textField;
}

- (NSMutableArray *)buttonTitles {
    if (!_buttonTitles) {
        _buttonTitles = [NSMutableArray array];
    }
    return _buttonTitles;
}

@end

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

#define kKeyWindow                  [[UIApplication sharedApplication].delegate window];
#define KK_SCREEN_WIDTH             [UIScreen mainScreen].bounds.size.width
#define KK_SCREEN_HEIGHT            [[UIScreen mainScreen] bounds].size.height

const CGFloat kAlertMargin = 50.0f;
const CGFloat kAlertSubViewMargin = 20.0f;
const CGFloat kAlertSpaceLineWidth = 0.5f;
const CGFloat kAlertButtonHeight = 45.0f;

@interface KKAlertView()<UITextFieldDelegate, UIScrollViewDelegate>

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *message;
@property (nonatomic, assign) CGFloat contentHeight;

@property (nonatomic, strong) NSMutableArray *buttons;

@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) UIView *alertView;

//用于装载titleview和contentview
@property (nonatomic, strong) UIScrollView *contentScrollView;
@property (nonatomic, strong) UIView *contentScrollRootView;//内容容器

@property (nonatomic, strong) UIScrollView *buttonScrollView;
@property (nonatomic, strong) UIView *buttonScrollRootView;

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UILabel *textFieldMaxSize;
@property (nonatomic, strong) NSMutableArray *buttonTitles;


@end

@implementation KKAlertView

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles,... {
    self = [super initWithFrame:CGRectMake(0, 0, KK_SCREEN_WIDTH, KK_SCREEN_HEIGHT)];
    if (self) {
        _title = title;
        _message = message;
        _messageMaxSize = INT_MAX;
        _titleAlignment = NSTextAlignmentCenter;
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
        [self registerKeyboardNotification];
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
    [self.backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
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
        make.height.mas_lessThanOrEqualTo(@(KK_SCREEN_HEIGHT - 40));
    }];
    
    [self.contentScrollView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.alertView).offset(0);
        make.trailing.mas_equalTo(self.alertView).offset(0);
        make.top.mas_equalTo(self.alertView).offset(0);
        if (self.contentHeight > 0) {
            make.height.equalTo(@(self.contentHeight));
        } else {
            make.height.mas_greaterThanOrEqualTo(@40);
            make.height.mas_lessThanOrEqualTo(@(KK_SCREEN_HEIGHT - 40 - 45));
        }
    }];
    
    [self.buttonScrollView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.alertView).offset(0);
        make.trailing.mas_equalTo(self.alertView).offset(0);
        make.top.equalTo(self.contentScrollView.mas_bottom).offset(0);
        make.bottom.mas_equalTo(self.alertView).offset(0);
        if (self.buttonTitles.count > 2) {
            make.height.equalTo(@70);
        } else {
            make.height.equalTo(@45.5);
        }
    }];
    
    
    [super updateConstraints];
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    self.contentHeight = self.contentScrollRootView.height;
    if (self.alertView.height < self.contentHeight) {
        [self setNeedsUpdateConstraints];
    }
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
        UIView *spaceLineView = [self createSpaceLine];
        [self.buttonScrollRootView addSubview:spaceLineView];
        [spaceLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(self.buttonScrollRootView).offset(0);
            make.trailing.mas_equalTo(self.buttonScrollRootView).offset(0);
            make.height.equalTo(@0.5);
            make.top.mas_equalTo(self.buttonScrollRootView).offset(0);
        }];
        
        KKButton *button = [self createButtonWithTitle:self.buttonTitles.firstObject];
        button.tag = 0;
        [self.buttonScrollRootView addSubview:button];
        
        UIView *spaceLineView1 = [self createSpaceLine];
        [self.buttonScrollRootView addSubview:spaceLineView1];
        KKButton *button1 = [self createButtonWithTitle:self.buttonTitles[1]];
        button1.tag = 1;
        [self.buttonScrollRootView addSubview:button1];
        
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(spaceLineView.mas_bottom).offset(0);
            make.leading.mas_equalTo(self.buttonScrollRootView).offset(0);
            make.height.equalTo(@(kAlertButtonHeight));
            make.bottom.mas_equalTo(self.buttonScrollRootView).offset(0);
        }];
        [spaceLineView1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(button.mas_trailing).offset(0);
            make.top.equalTo(spaceLineView.mas_bottom).offset(0);
            make.bottom.mas_equalTo(self.buttonScrollRootView).offset(0);
            make.width.equalTo(@(kAlertSpaceLineWidth));
        }];
        [button1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(spaceLineView1.mas_trailing).offset(0);
            make.top.equalTo(spaceLineView.mas_bottom).offset(0);
            make.trailing.mas_equalTo(self.buttonScrollRootView).offset(0);
            make.height.equalTo(@(kAlertButtonHeight));
            make.bottom.mas_equalTo(self.buttonScrollRootView).offset(0);
            make.width.equalTo(button.mas_width);
        }];
        return ;
    }
    
        
    UIView *topView = self.buttonScrollRootView;
    for (int i = 0; i < self.buttonTitles.count ; i++) {
        int j = (i == self.buttonTitles.count - 1) ? 0 : i + 1;
        NSString *title = self.buttonTitles[j];
        UIView *spaceLineView = [self createSpaceLine];
        [self.buttonScrollRootView addSubview:spaceLineView];
        [spaceLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(self.buttonScrollRootView).offset(0);
            make.trailing.mas_equalTo(self.buttonScrollRootView).offset(0);
            make.height.equalTo(@0.5);
            if (topView == self.buttonScrollRootView) {
                make.top.mas_equalTo(self.buttonScrollRootView).offset(0);
            } else {
                make.top.equalTo(topView.mas_bottom).offset(0);
            }
        }];
        
        KKButton *button = [self createButtonWithTitle:title];
        button.tag = ((i == self.buttonTitles.count - 1)) ? 0 : i + 1;
        [self.buttonScrollRootView addSubview:button];
        
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(spaceLineView.mas_bottom).offset(0);
            make.leading.mas_equalTo(self.buttonScrollRootView).offset(0);
            make.trailing.mas_equalTo(self.buttonScrollRootView).offset(0);
            make.height.equalTo(@45);
            if (i == (self.buttonTitles.count - 1)) {
                make.bottom.mas_equalTo(self.buttonScrollRootView).offset(0);
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

#pragma mark - UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    if (scrollView == self.contentScrollView) {
        return self.contentScrollRootView;
    }
    if (scrollView == self.buttonScrollView) {
        return self.buttonScrollRootView;
    }
    return nil;
}



#pragma mark - Notificaion 

- (void)registerKeyboardNotification {
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    
    
}

- (void)keyboardWillShow:(NSNotification *)aNotification
{
    
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    int height = keyboardRect.size.height;

    [self.alertView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.bottom.mas_equalTo(self).offset(-height);
        make.leading.mas_equalTo(@(kAlertMargin));
        make.trailing.mas_equalTo(@(-kAlertMargin));
        make.height.lessThanOrEqualTo(@(KK_SCREEN_HEIGHT - 40));
    }];
}


- (void)keyboardWillHide:(NSNotification *)aNotification {
    
    [self.alertView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.centerY.mas_equalTo(self);
        make.leading.mas_equalTo(@(kAlertMargin));
        make.trailing.mas_equalTo(@(-kAlertMargin));
        make.height.lessThanOrEqualTo(@(KK_SCREEN_HEIGHT - 40));
    }];
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
    if (self.alertViewStyle != KKAlertViewStyleCustomContent) return;
    [self.contentView addSubview:subView];
    [subView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.contentView).offset(0);
        make.top.mas_equalTo(self.contentView).offset(0);
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

- (KKButton *)createButtonWithTitle:(NSString *)title {
    KKButton *button = [KKButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setTitleColor:[[UIColor blackColor] colorWithAlphaComponent:0.8] forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(buttonActoin:) forControlEvents:UIControlEventTouchUpInside];
    button.translatesAutoresizingMaskIntoConstraints = NO;
    return button;
}

- (UIView *)createSpaceLine {
    UIView *spaceLineView = [[UIView alloc] init];
    spaceLineView.backgroundColor = [UIColor lightGrayColor];
    spaceLineView.translatesAutoresizingMaskIntoConstraints = NO;
    return spaceLineView;
}

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

- (void)setTitleAlignment:(NSTextAlignment)titleAlignment {
    if (_titleAlignment != titleAlignment) {
        self.titleLabel.textAlignment = titleAlignment;
        [_titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.contentScrollView).offset(kAlertSubViewMargin);
            switch (titleAlignment) {
                case NSTextAlignmentLeft: {
                    make.leading.mas_equalTo(self.contentScrollView).offset(kAlertSubViewMargin);
                    make.width.equalTo(@(KK_SCREEN_WIDTH - kAlertSubViewMargin * 2 - kAlertMargin * 2));
                }
                    break;
                case NSTextAlignmentRight: {
                    make.trailing.mas_equalTo(self.contentScrollView).offset(-kAlertSubViewMargin);
                    make.width.equalTo(@(KK_SCREEN_WIDTH - kAlertSubViewMargin * 2 - kAlertMargin * 2));
                }
                    break;
                case NSTextAlignmentCenter: {
                    make.trailing.mas_equalTo(self.contentScrollView).offset(-kAlertSubViewMargin);
                    make.leading.mas_equalTo(self.contentScrollView).offset(kAlertSubViewMargin);
                }
                    break;
                    
                default:
                    break;
            }
        }];
    }
}

#pragma mark - Getter

- (void)hiden {
    [self removeFromSuperview];
}

- (UIView *)backgroundView {
    if (!_backgroundView) {
        _backgroundView = [[UIView alloc] init];
        _backgroundView.backgroundColor = [[UIColor clearColor] colorWithAlphaComponent:0.3];
        [self insertSubview:_backgroundView atIndex:0];
        UITapGestureRecognizer *tapgest = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiden)];
        [_backgroundView addGestureRecognizer:tapgest];
    }
    return _backgroundView;
}

- (UIView *)alertView {
    if (!_alertView) {
        _alertView = [[UIView alloc] initWithFrame:CGRectZero];
        _alertView.backgroundColor = [UIColor clearColor];
        _alertView.layer.masksToBounds = YES;
        _alertView.layer.cornerRadius = 10;
        _alertView.userInteractionEnabled = YES;
        [self addSubview:_alertView];
    }
    return _alertView;
}


- (UIScrollView *)contentScrollView {
    if (!_contentScrollView) {
        _contentScrollView = [[UIScrollView alloc] init];
        _contentScrollView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.98f];
        _contentScrollView.delegate = self;
        [self.alertView addSubview:_contentScrollView];
    }
    return _contentScrollView;
}

- (UIView *)contentScrollRootView {
    if (!_contentScrollRootView) {
        _contentScrollRootView = [[UIView alloc] init];
        _contentScrollRootView.backgroundColor = [UIColor clearColor];
        [self.contentScrollView addSubview:_contentScrollRootView];
        
        [_contentScrollRootView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(self.contentScrollView).offset(0);
            make.top.mas_equalTo(self.contentScrollView).offset(0);
            make.bottom.mas_equalTo(self.contentScrollView).offset(0);
            make.trailing.mas_equalTo(self.contentScrollView).offset(0);
            make.width.equalTo(@(KK_SCREEN_WIDTH - kAlertMargin * 2));
        }];
        
    }
    return _contentScrollRootView;
}

- (UIScrollView *)buttonScrollView {
    if (!_buttonScrollView) {
        _buttonScrollView = [[UIScrollView alloc] init];
        _buttonScrollView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.98f];
        _buttonScrollView.delegate = self;
        [self.alertView addSubview:_buttonScrollView];
    }
    return _buttonScrollView;
}

- (UIView *)buttonScrollRootView {
    if (!_buttonScrollRootView) {
        _buttonScrollRootView = [[UIView alloc] init];
        _buttonScrollRootView.backgroundColor = [UIColor clearColor];
        [self.buttonScrollView addSubview:_buttonScrollRootView];
        
        [_buttonScrollRootView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(self.buttonScrollView).offset(0);
            make.top.mas_equalTo(self.buttonScrollView).offset(0);
            make.bottom.mas_equalTo(self.buttonScrollView).offset(0);
            make.trailing.mas_equalTo(self.buttonScrollView).offset(0);
            make.width.equalTo(@(KK_SCREEN_WIDTH - kAlertMargin * 2));
        }];
    }
    return _buttonScrollRootView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.font = [UIFont boldSystemFontOfSize:17.0f];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.textAlignment = self.titleAlignment;
        _titleLabel.numberOfLines = 0;
        _titleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self.contentScrollRootView addSubview:_titleLabel];
        
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(self.contentScrollRootView).offset(kAlertSubViewMargin);
            make.trailing.mas_equalTo(self.contentScrollRootView).offset(-kAlertSubViewMargin);
            make.top.mas_equalTo(self.contentScrollRootView).offset(kAlertSubViewMargin);
        }];
        
    }
    return _titleLabel;
}

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] initWithFrame:CGRectZero];
        _contentView.backgroundColor = [UIColor clearColor];
        _contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self.contentScrollRootView addSubview:_contentView];
        
        [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(self.contentScrollRootView).offset(0);
            make.trailing.mas_equalTo(self.contentScrollRootView).offset(0);
            make.top.equalTo(self.titleLabel.mas_bottom).offset(kAlertSubViewMargin);
            make.bottom.mas_equalTo(self.contentScrollRootView).offset(0);
        }];
    }
    return _contentView;
}

- (UILabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _contentLabel.backgroundColor = [UIColor clearColor];
        _contentLabel.numberOfLines = 0;
        _contentLabel.textAlignment = NSTextAlignmentCenter;
        _contentLabel.font = [UIFont systemFontOfSize:13.0f];
        [self.contentView addSubview:_contentLabel];
        _contentLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(self.contentView).offset(kAlertSubViewMargin);
            make.trailing.mas_equalTo(self.contentView).offset(-kAlertSubViewMargin);
            make.top.mas_equalTo(self.contentView).offset(0);
            make.bottom.mas_equalTo(self.contentView).offset(-kAlertSubViewMargin);
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
        _textField.backgroundColor = [UIColor clearColor];
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
            make.bottom.mas_equalTo(self.contentView).offset(-kAlertSubViewMargin);
        }];
        
        [_textField mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(_textView).offset(5);
            make.top.mas_equalTo(_textView).offset(0);
            make.bottom.mas_equalTo(_textView).offset(0);
            make.width.equalTo(@(KK_SCREEN_WIDTH - kAlertMargin * 2 - kAlertSubViewMargin * 2 - ((_messageMaxSize != INT_MAX) ? 30 : 0)));
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

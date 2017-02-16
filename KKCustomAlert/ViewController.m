//
//  ViewController.m
//  KKCustomAlert
//
//  Created by sunkai on 2017/2/15.
//  Copyright © 2017年 Kook. All rights reserved.
//

#import "ViewController.h"
#import "KKAlertView+Block.h"
#import <Masonry/Masonry.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)test:(id)sender {
    [KKAlertView showWithTitle:@"test" block:^(NSString *message, NSInteger buttonIndex) {
        
    }];
    return;
    
    
//    UIView *customView = [[UIView alloc] init];
//    
//    UIView *view = [[UIView alloc] init];
//    view.backgroundColor = [UIColor redColor];
//    [customView addSubview:view];
//    [alert addContentView:customView];
//    [view mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.leading.mas_equalTo(customView).offset(0);
//        make.trailing.mas_equalTo(customView).offset(0);
//        make.height.equalTo(@20);
//        make.bottom.mas_equalTo(customView).offset(0);
//    }];
}


@end

//
//  ViewController.m
//  KKCustomAlert
//
//  Created by sunkai on 2017/2/15.
//  Copyright © 2017年 Kook. All rights reserved.
//

#import "ViewController.h"
#import "KKDefaultAlertWithBlock.h"
#import "KKCustomAlertWithBlock.h"
#import <Masonry/Masonry.h>
#import "KKAlertView.h"

@interface ViewController ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *scrollViewContentView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];


    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.scrollViewContentView;
}

- (IBAction)test:(id)sender {
    
    [KKDefaultAlertWithBlock showWithTitle:@"test" message:@"testmessage" block:^(KKAlertView *alertView, NSInteger buttonIndex) {
        
    }];
    
}

- (IBAction)custom:(id)sender {
    [KKCustomAlertWithBlock showWithTitle:@"test custom alertview" block:^(KKAlertView *alertView, NSInteger buttonIndex) {
        
    }];
}

@end

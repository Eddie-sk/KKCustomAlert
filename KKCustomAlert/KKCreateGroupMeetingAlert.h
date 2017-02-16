//
//  KKCreateGroupMeetingAlert.h
//  Kook
//
//  Created by sunkai on 2017/2/15.
//  Copyright © 2017年 Kook. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^KKCreateGroupMeetingAlertBlock)(NSUInteger buttonIndex);
@interface KKCreateGroupMeetingAlert : UIView

+ (void)showWithBlock:(KKCreateGroupMeetingAlertBlock)comp;

@end

//
//  ViewController.h
//  NotificationExample
//
//  Created by zhangxiaofeng on 16/11/24.
//  Copyright © 2016年 eLong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UserNotifications/UserNotifications.h>
#import <CoreLocation/CoreLocation.h>

@interface ViewController : UIViewController<UNUserNotificationCenterDelegate,CLLocationManagerDelegate >

@end


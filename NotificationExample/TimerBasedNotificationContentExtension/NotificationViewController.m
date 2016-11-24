//
//  NotificationViewController.m
//  TimerBasedNotificationContentExtension
//
//  Created by zhangxiaofeng on 16/11/24.
//  Copyright © 2016年 eLong. All rights reserved.
//

#import "NotificationViewController.h"
#import <UserNotifications/UserNotifications.h>
#import <UserNotificationsUI/UserNotificationsUI.h>

@interface NotificationViewController () <UNNotificationContentExtension>

@property IBOutlet UILabel *bottomLabel;
@property (weak, nonatomic) IBOutlet UIButton *topButton;

@property (weak, nonatomic) IBOutlet UILabel *middlelabel;
@end

@implementation NotificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any required interface initialization here.
}

- (void)didReceiveNotification:(UNNotification *)notification {
    
    self.middlelabel.text =@"Happy Shopping";
    self.bottomLabel.text= notification.request.content.body;
    [self.topButton setTitle:@"More than 20 favourite products are available" forState:UIControlStateNormal];
}

-(void)didReceiveNotificationResponse:(UNNotificationResponse *)response completionHandler:(void (^)(UNNotificationContentExtensionResponseOption))completion
{
    // user tapped on Checkout action from Timer Notification
    if([response.actionIdentifier isEqualToString:@"com.mcoe.notificationcategory.timerbased.yes"])
    {
        
        // User accepted to checkout new arrivals, App will be launched in this case
        completion(UNNotificationContentExtensionResponseOptionDismissAndForwardAction);
    }
    // user tapped on Decline Action from Timer Notification
    else if([response.actionIdentifier isEqualToString:@"com.mcoe.notificationcategory.timerbased.no"])
    {
        
        // user doesn't like the product, mark it as doesn't like, App will not get launched
        
        completion(UNNotificationContentExtensionResponseOptionDismiss);
    }
    else if([response.actionIdentifier isEqualToString:@"com.mcoe.notificationcategory.timerbased.dismiss"])
    {
       
        // dismiss the notification as user wants to check it out later
        completion(UNNotificationContentExtensionResponseOptionDismiss);
    }
}
@end

//
//  NotificationViewController.m
//  LocationNotificationContentExtension
//
//  Created by zhangxiaofeng on 16/11/24.
//  Copyright © 2016年 eLong. All rights reserved.
//

#import "NotificationViewController.h"
#import <UserNotifications/UserNotifications.h>
#import <UserNotificationsUI/UserNotificationsUI.h>

@interface NotificationViewController () <UNNotificationContentExtension>



@end

@implementation NotificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any required interface initialization here.
}

- (void)didReceiveNotification:(UNNotification *)notification {
   // self.bottomLabel.text = notification.request.content.body;
}



-(void)didReceiveNotificationResponse:(UNNotificationResponse *)response completionHandler:(void (^)(UNNotificationContentExtensionResponseOption))completion
{
    // User tapped on CheckIn action from Notification
    if([response.actionIdentifier isEqualToString:@"com.mcoe.notificationcategory.locationbased.checkedin"])
    {
        // update the record as checked IN
        
        completion(UNNotificationContentExtensionResponseOptionDismissAndForwardAction);
    }
        // User tapped on checkOut action from notification
    else if([response.actionIdentifier isEqualToString:@"com.mcoe.notificationcategory.locationbased.checkedout"])
    {


      //Update the record as Check Out
        completion(UNNotificationContentExtensionResponseOptionDismissAndForwardAction);
    }
   
    completion(UNNotificationContentExtensionResponseOptionDismiss);
}
@end

//
//  ViewController.m
//  NotificationExample
//
//  Created by zhangxiaofeng on 16/11/24.
//  Copyright © 2016年 eLong. All rights reserved.
//

#import "ViewController.h"
#import <UserNotifications/UserNotifications.h> 
#import <CoreLocation/CoreLocation.h>
@interface ViewController ()

@property(strong,nonatomic) UNUserNotificationCenter* notiCenter;
@property (weak, nonatomic) IBOutlet UILabel *lblLocation;
@property (weak, nonatomic) IBOutlet UILabel *lblTimer;

@property (strong,nonatomic)NSMutableSet *categoryActionSet;
@property (nonatomic,strong) CLLocationManager*   locationManager ;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    _categoryActionSet=[[NSMutableSet alloc] init];
    // Getting current notification center object and ask for notification authorization from user
    _notiCenter = [UNUserNotificationCenter currentNotificationCenter];
    _notiCenter.delegate=self;
    [_notiCenter  requestAuthorizationWithOptions:(UNAuthorizationOptionAlert + UNAuthorizationOptionSound) completionHandler:^(BOOL granted, NSError * _Nullable error) {
        //Enable or disable features based on authorization.
        if(granted)
        {
            [_notiCenter setDelegate:self];
                [self generateTimerBasedNotification];
                [self generateLocationBasedNotification];
                // _categoryActionSet has collected all the actions from different kind of notifications and adding it to notification Center
                [[self notiCenter] setNotificationCategories:_categoryActionSet];
        }
        
    }];

   // Read the notification setting, set by user
    [_notiCenter getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
        
        if(settings.soundSetting==UNNotificationSettingEnabled)
        {
            NSLog(@"Sound Notification is Enabled");
        }
        else
        {
            NSLog(@"Sound Notification is Disabled");
        }
        if(settings.alertSetting==UNNotificationSettingEnabled)
        {
            NSLog(@"Alert Notification is Enabled");
        }
        else
        {
            NSLog(@"Alert Notification is Disabled");
        }
        if(settings.badgeSetting==UNNotificationSettingEnabled)
        {
            NSLog(@"Badge is Enabled");
        }
        else
        {
            NSLog(@"Badge is Disabled");
        }
    }];
    
    // App should have user permission for getting alerted while on location updation
    _locationManager = [[CLLocationManager alloc] init];
    [_locationManager requestAlwaysAuthorization];

    

}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:NO];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}
-(void)generateTimerBasedNotification
{
    // UNMutableNotificationContent used to attach media content for local notification.This example attaches image to the notification
    
    UNMutableNotificationContent *notificationcontent = [[UNMutableNotificationContent alloc] init];
    notificationcontent.title = [NSString localizedUserNotificationStringForKey:@"New Arrivals" arguments:nil];
    notificationcontent.body = [NSString localizedUserNotificationStringForKey:@"New arrival of Your favourite products!"
                                                         arguments:nil];
    notificationcontent.sound = [UNNotificationSound defaultSound];
    // category identitifer should be unique and  should match with identitifer of its corresponding UNNotificationCategory
    notificationcontent.categoryIdentifier=@"com.mcoe.notificationcategory.timerbased";
    NSError *error=nil;
    // reading image from bundle and copying it to document directory.
    NSURL *fileFromBundle =[[NSBundle mainBundle] URLForResource:@"psc" withExtension:@"png"];
    // Destination URL
    NSURL *url = [[self applicationDocumentsDirectory]URLByAppendingPathComponent:@"psc.png"];
    NSError *error1;
    // copying from bundle to document directory
     [[NSFileManager defaultManager]copyItemAtURL:fileFromBundle toURL:url error:&error1];
    // creating attachment with image url
    UNNotificationAttachment *image_attachment=[UNNotificationAttachment attachmentWithIdentifier:@"com.mcoe.notificationcategory.timerbased" URL:url options:nil error:&error];
    notificationcontent.attachments=[NSArray arrayWithObject:image_attachment];
    notificationcontent.badge = @([[UIApplication sharedApplication] applicationIconBadgeNumber] + 1);

    
    // creating notification trigger object based on the content object, and notification will be triggered in 3 seconds after launching
    
    UNTimeIntervalNotificationTrigger *timerbasedtrigger = [UNTimeIntervalNotificationTrigger
                                                  triggerWithTimeInterval:3.f repeats:NO];
    
    // Adding custom actions
    
    UNNotificationAction *checkoutAction = [UNNotificationAction actionWithIdentifier:@"com.mcoe.notificationcategory.timerbased.yes"
                                                                              title:@"Check out"
                                                                            options:UNNotificationActionOptionForeground];
    UNNotificationAction *declineAction = [UNNotificationAction actionWithIdentifier:@"com.mcoe.notificationcategory.timerbased.no"
                                                                               title:@"Decline"
                                                                             options:UNNotificationActionOptionDestructive];
    UNNotificationAction *laterAction = [UNNotificationAction actionWithIdentifier:@"com.mcoe.notificationcategory.timerbased.dismiss"
                                                                              title:@"Later"
                                                                            options:UNNotificationActionOptionDestructive];
    NSArray *NotificationActions = @[ checkoutAction, declineAction, laterAction ];
    
    // categoryWithIdentifier should match with the value of UNNotificationExtensionCategory in info.plist of its corresponding content extension
    UNNotificationCategory *TimernotificationCategory=[UNNotificationCategory categoryWithIdentifier:@"com.mcoe.notificationcategory.timerbased" actions:NotificationActions intentIdentifiers:@[] options:UNNotificationCategoryOptionCustomDismissAction];
    
    
    
    [_categoryActionSet addObject:TimernotificationCategory];
   
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:@"com.mcoe.notificationcategory.timerbased"
                                                                          content:notificationcontent trigger:timerbasedtrigger];
    // adding timer based notification to notification Center
    [_notiCenter addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
        
        if (!error) {
            NSLog(@"added timer based NotificationRequest suceessfully!");
        }
    }];

    
}
-(void)generateLocationBasedNotification
{
    
    
    
    UNMutableNotificationContent *locationContent = [[UNMutableNotificationContent alloc] init];
    locationContent.title = [NSString localizedUserNotificationStringForKey:@"Welcome to Office" arguments:nil];
    locationContent.body = [NSString localizedUserNotificationStringForKey:@"You Entered or Exit the Office"
                                                         arguments:nil];
    locationContent.sound = [UNNotificationSound defaultSound];
    
    // category identitifer should be unique and  should match with identitifer of its corresponding UNNotificationCategory
    
    locationContent.categoryIdentifier=@"com.mcoe.notificationcategory.locationbased";
    NSError *error=nil;
    NSURL *fileFromBundle =[[NSBundle mainBundle] URLForResource:@"officeLocation" withExtension:@"png"];
    // Destination URL
    NSURL *url = [[self applicationDocumentsDirectory]URLByAppendingPathComponent:@"officeLocation.png"];
    NSError *error1;
    // copy it over
     [[NSFileManager defaultManager]copyItemAtURL:fileFromBundle toURL:url error:&error1];
    
    UNNotificationAttachment *attachment=[UNNotificationAttachment attachmentWithIdentifier:@"com.mcoe.notificationcategory.locationbased" URL:url options:nil error:&error];
    locationContent.attachments=[NSArray arrayWithObject:attachment];
    locationContent.badge = @([[UIApplication sharedApplication] applicationIconBadgeNumber] + 1);

    
        // Update latitude and longitude of your location while testing
        CLLocationCoordinate2D officeBay = CLLocationCoordinate2DMake(12.970540,80.251060);
        CLCircularRegion* officeRegion = [[CLCircularRegion alloc] initWithCenter:officeBay
                                                                     radius:40 identifier:@"My Office Bay"];
   
        officeRegion.notifyOnEntry = YES;
        officeRegion.notifyOnExit = YES;
        
        UNLocationNotificationTrigger* locationTrigger = [UNLocationNotificationTrigger
                                                  triggerWithRegion:officeRegion repeats:YES];
    
    
    UNNotificationAction *checkinAction = [UNNotificationAction actionWithIdentifier:@"com.mcoe.notificationcategory.locationbased.checkedin"
                                                                              title:@"Check In"
                                                                            options:UNNotificationActionOptionForeground];
    UNNotificationAction *checkoutAction = [UNNotificationAction actionWithIdentifier:@"com.mcoe.notificationcategory.locationbased.checkedout"
                                                                               title:@"Check Out"
                                                                             options:UNNotificationActionOptionDestructive];

    NSArray *notificationActions = @[ checkinAction, checkoutAction ];
    
    // categoryWithIdentifier should match with the value of UNNotificationExtensionCategory in info.plist of its corresponding content extension
    UNNotificationCategory *LocationNotificationCategory=[UNNotificationCategory categoryWithIdentifier:@"com.mcoe.notificationcategory.locationbased" actions:notificationActions intentIdentifiers:@[] options:UNNotificationCategoryOptionCustomDismissAction];

    [_categoryActionSet addObject:LocationNotificationCategory];
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:@"com.mcoe.notificationcategory.locationbased"
                                                                          content:locationContent trigger:locationTrigger];
    [_notiCenter addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
        if (!error) {
            NSLog(@"added location based notification successfully!");
        }
    }];

}
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler __IOS_AVAILABLE(10.0) __TVOS_AVAILABLE(10.0) __WATCHOS_AVAILABLE(3.0){
    completionHandler(UNNotificationPresentationOptionAlert);
    
        if([notification.request.identifier isEqualToString:@"com.mcoe.notificationcategory.timerbased"])
        {
            [_lblTimer setText:@"Fired Timer Notification"];
            [_lblTimer setTextColor:[UIColor redColor]];
        }
        if([notification.request.identifier isEqualToString:@"com.mcoe.notificationcategory.locationbased"])
        {
            [_lblLocation setText:@"Fired Location Notification"];
            [_lblLocation setTextColor:[UIColor redColor]];

        }
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)())completionHandler __IOS_AVAILABLE(10.0) __WATCHOS_AVAILABLE(3.0) __TVOS_PROHIBITED
{
    if([response.actionIdentifier isEqualToString:@"com.mcoe.notificationcategory.timerbased.yes"])
    {
        
        [_lblTimer setText:@"Timer Notification Fired: User wants to check out the product"];
         [_lblTimer setTextColor:[UIColor redColor]];
    }
    
    if([response.actionIdentifier isEqualToString:@"com.mcoe.notificationcategory.locationbased.checkedin"])
    {
        [_lblLocation setText:@"Location Notification Fired: Successfully Checked in"];
        [_lblLocation setTextColor:[UIColor redColor]];

        
    }
    else if([response.actionIdentifier isEqualToString:@"com.mcoe.notificationcategory.locationbased.checkedout"])
    {
        [_lblLocation setText:@"Location Notification Fired: Successfully Checked out"];
        [_lblLocation setTextColor:[UIColor redColor]];

    }
   
}

@end

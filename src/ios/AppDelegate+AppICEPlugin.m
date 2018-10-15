
#import "AppDelegate+AppICEPlugin.h"
#import "AppICEPlugin.h"
#import <objc/runtime.h>

#if defined(__IPHONE_10_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
@import UserNotifications;
#endif

#if defined(__IPHONE_10_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
@interface AppDelegate () <UNUserNotificationCenterDelegate>
@end
#endif

//#define kApplicationInBackgroundKey @"applicationInBackground"
//#define SYSTEM_VERSION_GRATERTHAN_OR_EQUALTO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

@implementation AppDelegate (AppICEPlugin)

+ (void)load {
//    Method original = class_getInstanceMethod(self, @selector(application:didFinishLaunchingWithOptions:));
//    Method swizzled = class_getInstanceMethod(self, @selector(application:swizzledDidFinishLaunchingWithOptions:));
//    method_exchangeImplementations(original, swizzled);
    
    NSLog(@"Appice+delegate loaded");
}

//- (void)setApplicationInBackground:(NSNumber *)applicationInBackground {
//    objc_setAssociatedObject(self, kApplicationInBackgroundKey, applicationInBackground, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//}
//
//- (NSNumber *)applicationInBackground {
//    return objc_getAssociatedObject(self, kApplicationInBackgroundKey);
//}
//
//- (BOOL)application:(UIApplication *)application swizzledDidFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
//    [self application:application swizzledDidFinishLaunchingWithOptions:launchOptions];
//
//    [self registerForRemoteNotification];
//
//    self.applicationInBackground = @(YES);
//
//    return YES;
//}
//
///**
// Notification Registration
// */
//- (void)registerForRemoteNotification {
//    if(SYSTEM_VERSION_GRATERTHAN_OR_EQUALTO(@"10.0")) {
//        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
//        center.delegate = self;
//        [center requestAuthorizationWithOptions:(UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionBadge) completionHandler:^(BOOL granted, NSError * _Nullable error){
//            if( !error ){
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    [[UIApplication sharedApplication] registerForRemoteNotifications];
//                });
//            }
//        }];
//    }
//    else {
//        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
//        [[UIApplication sharedApplication] registerForRemoteNotifications];
//    }
//}

#pragma mark - Register Remote Notification

- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken {
    
    NSString* token = [[[[deviceToken description]
                         stringByReplacingOccurrencesOfString:@"<" withString:@""]
                        stringByReplacingOccurrencesOfString:@">" withString:@""]
                       stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:AIRemoteNotificationDidRegister object:token];
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:AIRemoteNotificationRegisterError object:error];
}

#pragma mark - Handle Notification info

- (void) application:(UIApplication*)application didReceiveLocalNotification:(UILocalNotification*)notification {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:AIDidReceiveLocalNotification object:notification.userInfo];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [[NSNotificationCenter defaultCenter] postNotificationName:AIDidReceiveRemoteNotification object:userInfo];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {

    [[NSNotificationCenter defaultCenter] postNotificationName:AIDidReceiveRemoteFNotification object:userInfo];
    
    completionHandler(UIBackgroundFetchResultNewData);
}

#if defined(__IPHONE_10_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
- (void)userNotificationCenter:(UNUserNotificationCenter *)center
       willPresentNotification:(UNNotification *)notification
         withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {
   [[NSNotificationCenter defaultCenter] postNotificationName:AIDidReceiveRemoteNotification object:notification.request.content.userInfo];

	completionHandler(UNNotificationPresentationOptionAlert | UNNotificationPresentationOptionBadge | UNNotificationPresentationOptionSound);
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)())completionHandler{
    
    NSDictionary *userInfo = response.notification.request.content.userInfo;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:AIDidReceiveNotificationResponse object:userInfo];
    
    completionHandler();
}
#endif

#pragma mark - Handle Notification Action

- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forLocalNotification:(UILocalNotification *)notification completionHandler:(void(^)())completionHandler {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:AIHandleActionNotification object:identifier];
    
    if (completionHandler) {
        completionHandler();
    }
}

- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void (^)())completionHandler
{
    [[NSNotificationCenter defaultCenter] postNotificationName:AIHandleActionNotification object:identifier];
    
    if (completionHandler) {
        completionHandler();
    }
}

#pragma mark - OpenURL Functions

- (BOOL)application:(UIApplication*)application openURL:(NSURL*)url sourceApplication:(NSString*)sourceApplication annotation:(id)annotation {
    if (!url) {
        return NO;
    }
    [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:AIHandleOpenURLNotification object:url]];
    return YES;
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary *)options {
    if (!url) {
        return NO;
    }
    [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:AIHandleOpenURLNotification object:url]];
    return YES;
}

- (void)openURL:(NSURL*)url options:(NSDictionary<NSString *, id> *)options completionHandler:(void (^ __nullable)(BOOL success))completion {
    [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:AIHandleOpenURLNotification object:url]];
}

@end

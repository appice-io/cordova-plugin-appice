
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

static id appdelegate;

+ (void)load {
//    Method original = class_getInstanceMethod(self, @selector(application:didFinishLaunchingWithOptions:));
//    Method swizzled = class_getInstanceMethod(self, @selector(application:swizzledDidFinishLaunchingWithOptions:));
//    method_exchangeImplementations(original, swizzled);
    
    NSLog(@"Appice+delegate loaded");
}

+(id) delegate{
    return appdelegate;
}

- (id)init
{
    self = [super init];
    
    appdelegate = self;
    
    NSLog(@"Appice+delegate init");
    
    return self;
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
    @try {
        [[AppICEPlugin appice] handleToken:deviceToken];
    } @catch(NSException *e){}
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error {
    @try {
        [[AppICEPlugin appice] handleTokenError:error];
    } @catch (NSException *exception) {
    }
}

#pragma mark - Handle Notification info

- (void) application:(UIApplication*)application didReceiveLocalNotification:(UILocalNotification*)notification {
    
    @try {
        [[AppICEPlugin appice] onHandleLocalNotification:notification];
    } @catch (NSException *exception) {   
    }
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    @try {
        [[AppICEPlugin appice] onHandleRemoteUNotification:userInfo];
    } @catch (NSException *exception) {   
    }
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {

    @try {
        [[AppICEPlugin appice] onHandleRemoteUNotification:userInfo];
        
        completionHandler(UIBackgroundFetchResultNewData);
    } @catch (NSException *exception) {
        
    } @finally {
        
    }
}

#if defined(__IPHONE_10_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
- (void)userNotificationCenter:(UNUserNotificationCenter *)center
       willPresentNotification:(UNNotification *)notification
         withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {
    @try {
        [[AppICEPlugin appice] onHandleRemoteUNotification:notification.request.content.userInfo];
        
        completionHandler(UNNotificationPresentationOptionAlert | UNNotificationPresentationOptionBadge | UNNotificationPresentationOptionSound);
    } @catch (NSException *exception) {
        
    } @finally {
        
    }
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)())completionHandler{
    
    @try {
        NSDictionary *userInfo = response.notification.request.content.userInfo;
        
        [[AppICEPlugin appice] onHandleNotificationUResponse:userInfo];
        
        completionHandler();
    } @catch (NSException *exception) {
        
    } @finally {
        
    }
}
#endif

#pragma mark - Handle Notification Action

- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forLocalNotification:(UILocalNotification *)notification completionHandler:(void(^)())completionHandler {
    
    @try {
        [[AppICEPlugin appice] onHandleActionForIdentifier:identifier];
        
        if (completionHandler) {
            completionHandler();
        }
    } @catch (NSException *exception) {
        
    } @finally {
        
    }
}

- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void (^)())completionHandler
{
    @try {
        [[AppICEPlugin appice] onHandleActionForIdentifier:identifier];
        
        if (completionHandler) {
            completionHandler();
        }
    } @catch (NSException *exception) {
        
    } @finally {
        
    }
}

#pragma mark - OpenURL Functions

- (BOOL)application:(UIApplication*)application openURL:(NSURL*)url sourceApplication:(NSString*)sourceApplication annotation:(id)annotation {
    @try {
        if (!url) {
            return NO;
        }
        [[AppICEPlugin appice] onHandleOpenURLNotification:url];
    } @catch (NSException *exception) {
    }
    return YES;
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary *)options {
    @try {
        if (!url) {
            return NO;
        }
        [[AppICEPlugin appice] onHandleOpenURLNotification:url];
    
    } @catch (NSException *exception) {
    }
    return YES;
}

- (void)openURL:(NSURL*)url options:(NSDictionary<NSString *, id> *)options completionHandler:(void (^ __nullable)(BOOL success))completion {
    @try {
        [[AppICEPlugin appice] onHandleOpenURLNotification:url];
    } @catch (NSException *exception) {
    }
}

@end

//
//  AppICEPlugin.h
//  Copyright (C) 2015 AppICE
//
//  This code is provided under a comercial License.
//  A copy of this license has been distributed in a file called LICENSE
//  with this source code.
//
//

#import <Cordova/CDVPlugin.h>

static NSString* const AIDidReceiveLocalNotification = @"AIDidReceiveLocalNotification";
static NSString* const AIDidReceiveRemoteNotification = @"AIDidReceiveRemoteNotification";
static NSString* const AIDidReceiveRemoteFNotification = @"AIDidReceiveRemoteFNotification";
static NSString* const AIDidReceiveNotificationResponse = @"AIDidReceiveNotificationResponse";

static NSString* const AIRemoteNotificationDidRegister = @"AIRemoteNotificationDidRegister";
static NSString* const AIRemoteNotificationRegisterError = @"AIRemoteNotificationRegisterError";

static NSString* const AIHandleOpenURLNotification = @"AIHandleOpenURLNotification";

static NSString* const AIHandleActionNotification = @"AIHandleActionNotification";

@interface AppICEPlugin : CDVPlugin

@property (nonatomic, copy) NSString *notificationCallbackId;
@property (nonatomic, retain) NSMutableArray *notificationStack;

+ (AppICEPlugin*) appice;

- (void)onNotificationOpen:(CDVInvokedUrlCommand*)command;
- (void)validateIntegration:(CDVInvokedUrlCommand*)command;

-(void)handleToken:(NSData *)deviceToken;
-(void)handleTokenError:(NSError *)error;

-(void)onHandleLocalNotification:(UILocalNotification *)notif;
-(void)onHandleOpenURLNotification:(NSURL *)url;
-(void)onHandleActionForIdentifier:(NSString *)identifier;

-(void)initSdk:(CDVInvokedUrlCommand *)command;
-(void)startContext:(CDVInvokedUrlCommand *)command;
-(void)trackTouches:(CDVInvokedUrlCommand *)command;
-(void)trackSwipes:(CDVInvokedUrlCommand *)command;
-(void)trackScreens:(CDVInvokedUrlCommand *)command;
-(void)stopContext:(CDVInvokedUrlCommand *)command;
-(void)isSemusiSensing:(CDVInvokedUrlCommand *)command;
-(void)setAsTestDevice:(CDVInvokedUrlCommand *)command;
-(void)removeAsTestDevice:(CDVInvokedUrlCommand *)command;
-(void)getIsTestDevice:(CDVInvokedUrlCommand *)command;
-(void)openPlayServiceUpdate:(CDVInvokedUrlCommand *)command;
-(void)getSdkVersion:(CDVInvokedUrlCommand *)command;
-(void)getSdkIntVersion:(CDVInvokedUrlCommand *)command;
-(void)setDeviceId:(CDVInvokedUrlCommand *)command;
-(void)getDeviceId:(CDVInvokedUrlCommand *)command;
-(void)getAndroidId:(CDVInvokedUrlCommand *)command;
-(void)getAppKey:(CDVInvokedUrlCommand *)command;
-(void)getApiKey:(CDVInvokedUrlCommand *)command;
-(void)getAppId:(CDVInvokedUrlCommand *)command;
-(void)getCurrentContext:(CDVInvokedUrlCommand *)command;
-(void)setAlias:(CDVInvokedUrlCommand *)command;
-(void)getAlias:(CDVInvokedUrlCommand *)command;
-(void)setUser:(CDVInvokedUrlCommand *)command;
-(void)getUser:(CDVInvokedUrlCommand *)command;
-(void)setChildId:(CDVInvokedUrlCommand *)command;
-(void)getChildId:(CDVInvokedUrlCommand *)command;
-(void)setReferrer:(CDVInvokedUrlCommand *)command;
-(void)getReferrer:(CDVInvokedUrlCommand *)command;
-(void)setInstallReferrer:(CDVInvokedUrlCommand *)command;
-(void)getInstallReferrer:(CDVInvokedUrlCommand *)command;
-(void)setInstaller:(CDVInvokedUrlCommand *)command;
-(void)getInstaller:(CDVInvokedUrlCommand *)command;
-(void)getGCMSenderId:(CDVInvokedUrlCommand *)command;
-(void)setCustomVariable:(CDVInvokedUrlCommand *)command;
-(void)getCustomVariable:(CDVInvokedUrlCommand *)command;
-(void)removeCustomVariable:(CDVInvokedUrlCommand *)command;
-(void)tagEvent:(CDVInvokedUrlCommand *)command;
-(void)setSmallIcon:(CDVInvokedUrlCommand *)command;
-(void)setSessionTimeout:(CDVInvokedUrlCommand *)command;
-(void)getSessionTimeout:(CDVInvokedUrlCommand *)command;

-(void)onHandleRemoteUNotification:(NSDictionary *)userInfo;
-(void)onHandleNotificationUResponse:(NSDictionary *)userInfo;

@end


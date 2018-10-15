
#if defined(__IPHONE_10_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
@import UserNotifications;
#endif

#import "AppICEPlugin.h"

#import "appICE.h"
#import "appICEUserDetails.h"

#import "SBJson.h"
#import "ASIHTTPRequest.h"

#define SYSTEM_VERSION_GRATERTHAN_OR_EQUALTO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)


@implementation AppICEPlugin

static AppICEPlugin *appice;

static NSInteger const kNotificationStackSize = 10;
@synthesize notificationCallbackId;
@synthesize notificationStack;

+(void)load {
    
    // Listen for UIApplicationDidFinishLaunchingNotification to get a hold of launchOptions
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onDidFinishLaunchingNotification:) name:UIApplicationDidFinishLaunchingNotification object:nil];
    
    // Listen to re-broadcast events from Cordova's AppDelegate
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onDidFailToRegisterForRemoteNotificationsWithError:) name:AIRemoteNotificationRegisterError object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onHandleRegisterForRemoteNotification:) name:AIRemoteNotificationDidRegister object:nil];
}

+(void)onDidFinishLaunchingNotification:(NSNotification *)notification {
    // Init appice
    
}

+(void)onDidFailToRegisterForRemoteNotificationsWithError:(NSNotification *)notification {
    //Log Failure
    NSLog(@"Failed to get register for token, Error");
}

+(void)onHandleRegisterForRemoteNotification:(NSNotification *)deviceToken {
    NSLog(@"Apns token : %@", deviceToken.object);
    [appICE setTokenInPushNotification:deviceToken.object];
}

-(void)handleToken:(NSData *)deviceToken {
    NSLog(@"Apns token : %@", deviceToken);
    [appICE setTokenInPushNotification:deviceToken];
}

+(AppICEPlugin*) appice {
    return appice;
}

-(void)pluginInitialize {
    [super pluginInitialize];
    
    appice = self;
    
    // Setup keys
    NSString *appid = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"AppICEAppID"];
    NSString *appkey = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"AppICEAppKey"];
    NSString *apikey = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"AppICEApiKey"];
    [appICE setupKeys:appkey withapiKey:apikey withappId:appid otherSdkdeviceId:@""];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onHandleOpenURLNotification:) name: AIHandleOpenURLNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onHandleLocalNotification:) name:AIDidReceiveLocalNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onHandleRemoteNotification:) name:AIDidReceiveRemoteNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onHandleRemoteFNotification:) name:AIDidReceiveRemoteFNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onHandleNotificationResponse:) name:AIDidReceiveNotificationResponse object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onHandleActionForIdentifier:) name:AIHandleActionNotification object:nil];
}

-(void)onHandleLocalNotification:(NSNotification *)notif {
    UIApplicationState appState = UIApplicationStateActive;
    UIApplication *application = [UIApplication sharedApplication];
    if ([application respondsToSelector:@selector(applicationState)])
        appState = application.applicationState;
    
    UILocalNotification *notification = (UILocalNotification *)notif.object;
    
    if (appState == UIApplicationStateActive)
    {
        NSLog(@"stateActive");
    }
    else
    {
        NSDictionary* userInfo = [notification userInfo];
//        NSLog(@"UserInfo = %@", userInfo);
        
        NSString* campid = [[notification userInfo] objectForKey:@"campid"];
//        NSLog(@"campid = %@", campid);
        
        NSInteger numberOfBadges = [UIApplication sharedApplication].applicationIconBadgeNumber;
        numberOfBadges -=1;
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:numberOfBadges];
        [[appICE sharedInstance] openuUrlOnPushClick:campid];
    }
    
    if (application.applicationState==UIApplicationStateActive)
    {
        UILocalNotification * notif = (UILocalNotification*) notification;
        notif.applicationIconBadgeNumber = [[UIApplication sharedApplication] applicationIconBadgeNumber] + 1;
        [appICE receiveLocalNotification:notification];
    }
}

-(void)onHandleRemoteNotification:(NSNotification *)notification {
    [self onHandleRemoteFNotification:notification];
}

-(void)onHandleRemoteFNotification:(NSNotification *)notif {
    [self onHandleRemoteUNotification:notif.userInfo];
}

-(void)onHandleRemoteUNotification:(NSDictionary *)userInfo {
    //NSDictionary *userInfo = notif.object;
//    NSLog(@"Push Notification Information : %@",userInfo);
    UIApplication *application = [UIApplication sharedApplication];
    if(application.applicationState == UIApplicationStateInactive) {
        
//        NSLog(@"Inactive - the user has tapped in the notification when app was closed or in background");
        [[appICE sharedInstance] handleclickonpush:userInfo];
        
        [self sendCallback:userInfo];
    }
    else if (application.applicationState == UIApplicationStateBackground) {
        
//        NSLog(@"application Background - notification has arrived when app was in background");
        NSString* contentAvailable = [NSString stringWithFormat:@"%@", [[userInfo valueForKey:@"aps"] valueForKey:@"content-available"]];
        
        if([contentAvailable isEqualToString:@"1"]) {
            // do tasks
            
            [[NSUserDefaults standardUserDefaults] setObject:@"NOLOCAL" forKey:@"NOLOCAL"];
            [appICE receivePushNotification:userInfo];
            
//            NSLog(@"content-available is equal to 1");
        }
    }
    else {
//        NSLog(@"application Active - notication has arrived while app was opened");
        //Show an in-app banner
        //do tasks
        [[NSUserDefaults standardUserDefaults] setObject:@"NOLOCAL" forKey:@"NOLOCAL"];
        
        if ([[[UIDevice currentDevice] systemVersion] floatValue] <= 10.0) {
            UILocalNotification *localNotification = [[UILocalNotification alloc] init];
            localNotification.userInfo = userInfo;
            NSDictionary *datadict=[userInfo objectForKey:@"data"];
            NSString *msg =  [datadict objectForKey:@"nd"];
            localNotification.soundName = UILocalNotificationDefaultSoundName;
            localNotification.alertBody =  msg;
            localNotification.fireDate = [NSDate date];
            localNotification.userInfo = userInfo;
            [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
        }
        
        [appICE receivePushNotification:userInfo];
    }
}

-(void)onHandleNotificationResponse:(NSNotification *)notif {
    NSDictionary *userInfo = notif.object;
    [[appICE sharedInstance] handleclickonpush:userInfo];
    [self sendCallback:userInfo];
}

-(void)onHandleNotificationUResponse:(NSDictionary *)userInfo {
     NSLog(@"appice - uresponse : %@",userInfo);
    [[appICE sharedInstance] handleclickonpush:userInfo];
    [self sendCallback:userInfo];
}

-(void)sendCallback:(NSDictionary *)userInfo {
    if (userInfo != NULL&& [userInfo objectForKey:@"data"] != NULL) {
        NSDictionary *data = [userInfo objectForKey:@"data"];
        if (data != NULL && [data objectForKey:@"et"] != NULL) {
            NSString *et = [data objectForKey:@"et"];
            if (et != NULL && [et caseInsensitiveCompare:@"dl"] == NSOrderedSame) {
                NSMutableDictionary *dpDict = [[NSMutableDictionary alloc] init];
                @try {
                    NSString *url = [data objectForKey:@"eurl"];
                    if (url != NULL && url.length > 0) {
                        NSURL *uri = [NSURL URLWithString:url];
                        if (uri != NULL) {
                            dpDict = [self getUrlParameters:url];
                            [dpDict setObject:@"true" forKey:@"tap"];
                            [dpDict setObject:uri.host forKey:@"host"];
                            [dpDict setObject:uri.path forKey:@"path"];
                        }
                    }
                } @catch(NSException *e) {}
                
                @try {
                    id cdata = [data objectForKey:@"cdata"];
                    if (cdata != NULL && [cdata isKindOfClass:[NSString class]]) {
                        NSString *udata = (NSString*) cdata;
                        if ([udata hasPrefix:@"http://"] || [udata hasPrefix:@"https://"]) {
                            // cdata contains length text inside url - fetch and process it
                            NSURL *url = [NSURL URLWithString:[udata stringByAddingPercentEscapesUsingEncoding:
                                                               NSASCIIStringEncoding]];
                            __block ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
                            [request setRequestMethod:@"GET"];
                            [request startSynchronous];
                            NSError *error = [request error];
                            if (!error) {
                                NSString *response = [request responseString];
                                if (response.length > 0 && [response isKindOfClass:[NSNull class]] == NO) {
                                    SBJsonParser *parser = [[SBJsonParser alloc] init];
                                    NSDictionary *jsonObject = [parser objectWithString:response error:nil];
                                    [self fillDicData:jsonObject within:dpDict];
                                }
                            }
                        }
                    }
                    else if (cdata != NULL && [cdata isKindOfClass:[NSDictionary class]]) {
                        // cdata contains object process encoded data and store in dictionary to be passed to cordova
                        NSDictionary *jsonObject = (NSDictionary*) cdata;
                        [self fillDicData:jsonObject within:dpDict];
                    }
                } @catch(NSException *e) {
                    NSLog(@"Exception : %@", [e callStackSymbols]);
                }
                 NSLog(@"Appice - sendallback : %@", dpDict);
                if (dpDict != NULL) {
                    [self sendNotification:dpDict];
                }
            }
        }
    }
}

-(void) fillDicData:(NSDictionary*)dict within:(NSMutableDictionary*)mutable {
    if (dict != NULL) {
        for (id key in dict) {
            id value = [dict objectForKey:key];
            if (value != NULL && [value isKindOfClass:[NSString class]]){
                NSString *svalue = (NSString*) value;
                svalue = [svalue stringByRemovingPercentEncoding];
                [mutable setObject:svalue forKey:key];
            }
            else
                [mutable setObject:value forKey:key];
        }
    }
}

-(NSMutableDictionary *)getUrlParameters:(NSString *)url{
    NSArray *justParamsArr = [url componentsSeparatedByString:@"?"];
    url = [justParamsArr lastObject];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    for (NSString *param in [url componentsSeparatedByString:@"&"]) {
        NSArray *elts = [param componentsSeparatedByString:@"="];
        if([elts count] < 2) continue;
        
        id value = [elts lastObject];
        if (value != NULL && [value isKindOfClass:[NSString class]]){
            NSString *svalue = (NSString*) value;
            svalue = [svalue stringByRemovingPercentEncoding];
            [params setObject:svalue forKey:[elts firstObject]];
        }
        else
            [params setObject:[elts lastObject] forKey:[elts firstObject]];
    }
    return params;
}

-(void)onHandleOpenURLNotification:(NSNotification *)notif {
    
}

-(void)onHandleActionForIdentifier:(NSNotification *)notif {
    NSString *identifier = notif.object;
    if ([identifier isEqualToString:@"ACTION_ONE"]) {
        [[appICE sharedInstance] handleactionfirstforPUSH];
    }
    else if ([identifier isEqualToString:@"ACTION_TWO"]) {
        [[appICE sharedInstance] handleactionsecondforPUSH];
    }
    else if ([identifier isEqualToString:@"ACTION_THREE"]) {
        [[appICE sharedInstance] handleactionthirdforPUSH];
    }
}

#pragma mark - Cordova Methods

/**
 Notification Registration
 */
- (void)registerForRemoteNotification {
    if(SYSTEM_VERSION_GRATERTHAN_OR_EQUALTO(@"10.0")) {
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        center.delegate = self;
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionBadge) completionHandler:^(BOOL granted, NSError * _Nullable error){
            if( !error ){
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[UIApplication sharedApplication] registerForRemoteNotifications];
                });
            }
        }];
    }
    else {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
}

-(void)startContext:(CDVInvokedUrlCommand *)command {
    [self.commandDelegate runInBackground:^{
        @try {
            [self registerForRemoteNotification];
            
            [[appICE sharedInstance] startContext];
            
            CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
            [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        } @catch(NSException *e) {
            CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
            [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        }
    }];
}

-(void)stopContext:(CDVInvokedUrlCommand *)command {
    [self.commandDelegate runInBackground:^{
        @try {
            
        } @catch(NSException *e) {}
    }];
}

-(void)isSemusiSensing:(CDVInvokedUrlCommand *)command {
    [self.commandDelegate runInBackground:^{
        @try {
            
        } @catch(NSException *e) {}
    }];
}

-(void)setAsTestDevice:(CDVInvokedUrlCommand *)command {
    [self.commandDelegate runInBackground:^{
        @try {
            
        } @catch(NSException *e) {}
    }];
}

-(void)removeAsTestDevice:(CDVInvokedUrlCommand *)command {
    [self.commandDelegate runInBackground:^{
        @try {
            
        } @catch(NSException *e) {}
    }];
}

-(void)getIsTestDevice:(CDVInvokedUrlCommand *)command {
    [self.commandDelegate runInBackground:^{
        @try {
            
        } @catch(NSException *e) {}
    }];
}

-(void)openPlayServiceUpdate:(CDVInvokedUrlCommand *)command {
    [self.commandDelegate runInBackground:^{
        @try {
            
        } @catch(NSException *e) {}
    }];
}

-(void)getSdkVersion:(CDVInvokedUrlCommand *)command {
    [self.commandDelegate runInBackground:^{
        @try {
            NSString *value = [[appICE sharedInstance] getSdkVersion];
            
            CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:value];
            [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
            
        } @catch(NSException *e) {}
    }];
}

-(void)getSdkIntVersion:(CDVInvokedUrlCommand *)command {
    [self.commandDelegate runInBackground:^{
        @try {
            
        } @catch(NSException *e) {}
    }];
}

-(void)setDeviceId:(CDVInvokedUrlCommand *)command {
    [self.commandDelegate runInBackground:^{
        @try {
            
        } @catch(NSException *e) {}
    }];
}

-(void)getDeviceId:(CDVInvokedUrlCommand *)command {
    [self.commandDelegate runInBackground:^{
        @try {
            NSString *value = [[NSUserDefaults standardUserDefaults] objectForKey:@"appiceudid"];
            
            CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:value];
            [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        } @catch(NSException *e) {
            CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
            [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        }
    }];
}

-(void)getAndroidId:(CDVInvokedUrlCommand *)command {
    [self.commandDelegate runInBackground:^{
        @try {
            
        } @catch(NSException *e) {}
    }];
}

-(void)getAppKey:(CDVInvokedUrlCommand *)command {
    [self.commandDelegate runInBackground:^{
        @try {
            
        } @catch(NSException *e) {}
    }];
}

-(void)getApiKey:(CDVInvokedUrlCommand *)command {
    [self.commandDelegate runInBackground:^{
        @try {
            
        } @catch(NSException *e) {}
    }];
}

-(void)getAppId:(CDVInvokedUrlCommand *)command {
    [self.commandDelegate runInBackground:^{
        @try {
            
        } @catch(NSException *e) {}
    }];
}

-(void)getCurrentContext:(CDVInvokedUrlCommand *)command {
    [self.commandDelegate runInBackground:^{
        @try {
            
        } @catch(NSException *e) {}
    }];
}

-(void)setAlias:(CDVInvokedUrlCommand *)command {
    [self.commandDelegate runInBackground:^{
        @try {
            NSObject *eventObj = [command argumentAtIndex:0];
            NSString *key = [eventObj valueForKey:@"alias"];
            if (key != nil && [key isKindOfClass:[NSString class]]) {
                [[appICE sharedInstance] setAlias:key];
                
                CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
                [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
            }
        } @catch(NSException *e) {
            CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
            [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        }
    }];
}

-(void)getAlias:(CDVInvokedUrlCommand *)command {
    [self.commandDelegate runInBackground:^{
        @try {
            NSString *value = [[appICE sharedInstance] getChildId:@"_alias"];
            
            CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:value];
            [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        } @catch(NSException *e) {
            CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
            [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        }
    }];
}

-(void)setUser:(CDVInvokedUrlCommand *)command {
    [self.commandDelegate runInBackground:^{
        @try {
            NSObject *eventObj = [command argumentAtIndex:0];
            NSString *name = [eventObj valueForKey:@"name"];
            NSString *phone = [eventObj valueForKey:@"phone"];
            NSString *email = [eventObj valueForKey:@"email"];
            
            appICEUserDetails *details = [appICEUserDetails sharedUserDetails];
            [details setName:name];
            [details setPhone:phone];
            [details setEmail:email];
            [[appICE sharedInstance] setUser:details];
            
            CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
            [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
            
        } @catch(NSException *e) {
            CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
            [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        }
    }];
}

-(void)getUser:(CDVInvokedUrlCommand *)command {
    [self.commandDelegate runInBackground:^{
        @try {
            
        } @catch(NSException *e) {}
    }];
}

-(void)setChildId:(CDVInvokedUrlCommand *)command {
    [self.commandDelegate runInBackground:^{
        @try {
            NSObject *eventObj = [command argumentAtIndex:0];
            NSString *key = [eventObj valueForKey:@"childID"];
            if (key != nil && [key isKindOfClass:[NSString class]]) {
                [[appICE sharedInstance] setChildId:key];
                
                CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
                [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
            }
        } @catch(NSException *e) {
            CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
            [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        }
    }];
}

-(void)getChildId:(CDVInvokedUrlCommand *)command {
    [self.commandDelegate runInBackground:^{
        @try {
            NSString *value = [[appICE sharedInstance] getChildId:@"_childId"];
            
            CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:value];
            [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        } @catch(NSException *e) {
            CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
            [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        }
    }];
}

-(void)setReferrer:(CDVInvokedUrlCommand *)command {
    [self.commandDelegate runInBackground:^{
        @try {
            
        } @catch(NSException *e) {}
    }];
}

-(void)getReferrer:(CDVInvokedUrlCommand *)command {
    [self.commandDelegate runInBackground:^{
        @try {
            
        } @catch(NSException *e) {}
    }];
}

-(void)setInstallReferrer:(CDVInvokedUrlCommand *)command {
    [self.commandDelegate runInBackground:^{
        @try {
            
        } @catch(NSException *e) {}
    }];
}

-(void)getInstallReferrer:(CDVInvokedUrlCommand *)command {
    [self.commandDelegate runInBackground:^{
        @try {
            
        } @catch(NSException *e) {}
    }];
}

-(void)setInstaller:(CDVInvokedUrlCommand *)command {
    [self.commandDelegate runInBackground:^{
        @try {
            
        } @catch(NSException *e) {}
    }];
}

-(void)getInstaller:(CDVInvokedUrlCommand *)command {
    [self.commandDelegate runInBackground:^{
        @try {
            
        } @catch(NSException *e) {}
    }];
}

-(void)getGCMSenderId:(CDVInvokedUrlCommand *)command {
    [self.commandDelegate runInBackground:^{
        @try {
            
        } @catch(NSException *e) {}
    }];
}

-(void)getDeviceToken:(CDVInvokedUrlCommand *)command {
    [self.commandDelegate runInBackground:^{
        @try {
            NSString *value = [[NSUserDefaults standardUserDefaults] objectForKey:@"DeviveToken"];
            
            CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:value];
            [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        } @catch(NSException *e) {
            CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
            [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        }
    }];
}

-(void)setCustomVariable:(CDVInvokedUrlCommand *)command {
    [self.commandDelegate runInBackground:^{
        @try{
            NSObject *eventObj = [command argumentAtIndex:0];
            NSString *key = [eventObj valueForKey:@"key"];
            id val = [eventObj valueForKey:@"value"];
            if (key != nil && [key isKindOfClass:[NSString class]]) {
                if (val != nil && [val isKindOfClass:[NSString class]]) {
                    [[appICE sharedInstance] setCustomVariable:key withStringValue:(NSString*)val];
                }
                else if (val != nil && [val isKindOfClass:[NSNumber class]]) {
                    NSNumber *valNum = (NSNumber*) val;
                    switch(CFNumberGetType((CFNumberRef)valNum))
                    {
                        case kCFNumberIntType:
                            [[appICE sharedInstance] setCustomVariable:key withIntvalue:[valNum intValue]];
                            break;
                        case kCFNumberDoubleType:
                            [[appICE sharedInstance] setCustomVariable:key withBoolValue:[valNum doubleValue]];
                            break;
                        case kCFNumberLongType:
                            [[appICE sharedInstance] setCustomVariable:key withLongValue:[valNum longValue]];
                            break;
                        default:
                            break;
                    }
                }
            }
            CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
            [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        } @catch(NSException *error) {
            CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
            [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        }
    }];
}

-(void)getCustomVariable:(CDVInvokedUrlCommand *)command {
    [self.commandDelegate runInBackground:^{
        @try {
            NSObject *eventObj = [command argumentAtIndex:0];
            NSString *key = [eventObj valueForKey:@"key"];
            if (key != nil && [key isKindOfClass:[NSString class]]) {
                NSString *value = [[appICE sharedInstance] getCustomVariable:key];
                
                CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:value];
                [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
            }
        } @catch(NSException *e) {
            CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
            [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        }
    }];
}

-(void)removeCustomVariable:(CDVInvokedUrlCommand *)command {
    [self.commandDelegate runInBackground:^{
        @try {
            NSObject *eventObj = [command argumentAtIndex:0];
            NSString *key = [eventObj valueForKey:@"key"];
            if (key != nil && [key isKindOfClass:[NSString class]]) {
                [[appICE sharedInstance] removeCustomVariable:key];
                
                CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
                [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
            }
        } @catch(NSException *e) {
            CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
            [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        }
    }];
}

-(void)tagEvent:(CDVInvokedUrlCommand *)command {
    [self.commandDelegate runInBackground:^{
        @try {
            NSObject *eventObj = [command argumentAtIndex:0];
            NSString *eventName = [eventObj valueForKey:@"key"];
            NSDictionary *eventProps = [eventObj valueForKey:@"data"];
            if (eventName != nil && [eventName isKindOfClass:[NSString class]] && eventProps != nil && [eventProps isKindOfClass:[NSDictionary class]]) {
                [[appICE sharedInstance] recordEvent:eventName segmentation:eventProps count:1];
            }
            CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
            [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        } @catch(NSException *e) {
            CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
            [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        }
    }];
}

-(void)setSmallIcon:(CDVInvokedUrlCommand *)command {
    [self.commandDelegate runInBackground:^{
        @try {
            
        } @catch(NSException *e) {}
    }];
}

-(void)setSessionTimeout:(CDVInvokedUrlCommand *)command {
    [self.commandDelegate runInBackground:^{
        @try {
            NSObject *eventObj = [command argumentAtIndex:0];
            NSNumber *value = [eventObj valueForKey:@"timeout"];
            [[appICE sharedInstance] setSessionTimeout:value.intValue];
            
            CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
            [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        } @catch(NSException *e) {}
    }];
}

-(void)getSessionTimeout:(CDVInvokedUrlCommand *)command {
    [self.commandDelegate runInBackground:^{
        @try {
            int value = [[appICE sharedInstance] getSessionTimeout];

            CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsInt:value];
            [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        } @catch(NSException *e) {}
    }];
}

- (void)onNotificationOpen:(CDVInvokedUrlCommand *)command {
    self.notificationCallbackId = command.callbackId;
    
    NSLog(@"Appice setcallback a1");
    
    if (self.notificationStack != nil && [self.notificationStack count]) {
        NSLog(@"Appice setcallback a2");
        for (NSDictionary *userInfo in self.notificationStack) {
            NSLog(@"Appice setcallback a3  %@");
            [self sendNotification:userInfo];
        }
        [self.notificationStack removeAllObjects];
    }
}

- (void)sendNotification:(NSDictionary *)userInfo {
    NSLog(@"Appice send-notifcallback a1");
    if (self.notificationCallbackId != nil) {
        NSLog(@"Appice send-notifcallback a2");
        CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:userInfo];
        [pluginResult setKeepCallbackAsBool:YES];
        NSLog(@"Appice send-notifcallback a3");
        [self.commandDelegate sendPluginResult:pluginResult callbackId:self.notificationCallbackId];
        NSLog(@"Appice send-notifcallback a4");
    } else {
        NSLog(@"Appice send-notifcallback a5");
        if (!self.notificationStack) {
            NSLog(@"Appice send-notifcallback a6");
            self.notificationStack = [[NSMutableArray alloc] init];
        }
        NSLog(@"Appice send-notifcallback a7");
        // stack notifications until a callback has been registered
        [self.notificationStack addObject:userInfo];
        
        if ([self.notificationStack count] >= kNotificationStackSize) {
            [self.notificationStack removeLastObject];
        }
    }
}

@end


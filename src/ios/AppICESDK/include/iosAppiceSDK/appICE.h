
// appICE.h
//
// This code is provided under the MIT License.
//
// Please visit www.semusi.com for more information.

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@class appICEEventQueue;
@class appICEUserDetails;
@class appICEConnectionQueue;

@interface appICE : NSObject<CLLocationManagerDelegate,UIAlertViewDelegate,NSURLConnectionDelegate>

+ (instancetype)sharedInstance;
@property (strong, nonatomic) UIWindow *window;

// INITILIZE THE APPICE
-(void)startContext;

// APP CRASH EVENT
-(void) appcrashevent:(NSString*) CrashEXception;

// SET APPICE KEYS (APP ID , APP KEY , API KEY), IF YOU WANT TO USE ANY OTHER ANALYTICS SDK SIMULTANEOUSLY THEN PLEASE KEEP EMPTY IN DEVOCE ID
+(void) setupKeys:(NSString *)appKey withapiKey:(NSString *)apiKey withappId:(NSString *)appId otherSdkdeviceId:(NSString*)deviceId;


-(void)getAppAndUserData:(NSString*)profilestatus competingapisource:(NSString*)competingstatus campaignapisource:(NSString*)campaignstatus;

+ (NSMutableDictionary *)NewDeviceandAppmetrics;



-(void) CampaignClicked:(NSString *) KeyandCampaignID;

-(void) CampaignReceived:(NSString *) KeyandCampaignID;

-(void) CampaignViewed:(NSString *) KeyandCampaignID;

-(void) CampaignDeleted:(NSString *) KeyandCampaignID;

// LOCAL AND PUSH SUPPORT METHOD
+(void) setTokenInPushNotification:(NSData*) AppPushToken;
+(void) receivePushNotification:(NSDictionary*) Pushdict;
-(void) openuUrlOnPushClick:(NSString*) localcampaid;
+(void) receiveLocalNotification:(UILocalNotification*) localNOTI;

// EVENT TRACKING
- (void)recordEvent:(NSString *)key count:(int)count;

// EVENT TRACKING WITH SEGMENTATION
- (void)recordEvent:(NSString *)key segmentation:(NSDictionary *)segmentation count:(int)count;

// SET AND GET CHILD ID
-(void) setChildId:(NSString*)value;

-(NSString*)getChildId:(NSString*) key;

// SET ALIAS FUNCTION
-(void) setAlias:(NSString*)value;

// PUSH CLICK METHOD
-(void) handleactionfirstforPUSH;

-(void) handleactionsecondforPUSH;

-(void) handleactionthirdforPUSH;

-(void) handleclickonpush:(NSDictionary*) push_dict;

// SET CUSTOM VARIABLE
-(void) setCustomVariable:(NSString*) key withStringValue:(NSString*)value;

-(void) setCustomVariable:(NSString*) key withBoolValue:(BOOL)value;


-(void) setCustomVariable:(NSString*)key withLongValue:(int64_t) value;

-(void) setCustomVariable:(NSString*) key withIntvalue:(int32_t) value;

// GET CUSTOM VARIABLE
-(NSString*)getCustomVariable:(NSString*) key;

// REMOVE CUSTOM VARIABLE
-(void)removeCustomVariable:(NSString*) key;

// GET SDK VERSION
-(NSString*) getSdkVersion;


// GET TIME OUT OF BACKGROUND TIMER
-(int) getSessionTimeout;

// SET TIME OUT OF BACKGROUND TIMER
-(void) setSessionTimeout:(int) Timeout;

// Set User Detail

-(void) setUser:(appICEUserDetails*) userdetail;

//Get User Detail

-(appICEUserDetails*)getUser;





@end





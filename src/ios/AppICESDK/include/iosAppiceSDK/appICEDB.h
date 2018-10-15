// appICEDB.h
//
// This code is provided under the MIT License.
//
// Please visit www.semusi.com for more information.


#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "INAppViewController.h"
#import "HAlfINAppViewController.h"
#import "RatingViewController.h"
#import "SurveyViewController.h"
#import "APPChildViewController.h"
#import "HAlfHeaderINAppViewController.h"
#import "HAlfFooterNOTINAppViewController.h"
@interface appICEDB : NSObject<UIApplicationDelegate>

+(instancetype)sharedInstance;
@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) INAppViewController *viewController;
@property (strong, nonatomic) HAlfINAppViewController *hAlfINAppViewController;
@property (strong, nonatomic) RatingViewController *ratingViewController;
@property (strong, nonatomic) SurveyViewController *surveyViewController;
@property (strong, nonatomic) HAlfHeaderINAppViewController *hAlfHeaderINAppViewController;
@property (strong, nonatomic) HAlfFooterNOTINAppViewController *hAlfFooterNOTINAppViewController;
@property (strong, nonatomic) APPChildViewController *aPPChildViewController;

- (void)startViewController:(UIViewController *)callerViewController;
-(void)createEvent:(NSString*) eventKey count:(double)count sum:(double)sum segmentation:(NSDictionary*)segmentation timestamp:(NSTimeInterval)timestamp;
-(void)addToQueue:(NSString*)postData;
-(void)deleteEvent:(NSManagedObject*)eventObj;
-(void)removeFromQueue:(NSManagedObject*)postDataObj;
-(NSArray*) getEvents;
-(NSArray*) getQueue;
-(NSUInteger)getEventCount;
-(NSUInteger)getQueueCount;
- (void)saveContext;
//-(void) campaignviewed:(NSString*)viewnoti;
- (NSManagedObjectContext *)managedObjectContext;
-(void) saveactivecampaignintodb:(NSMutableArray*) campaigndict;
-(void) savecampaignmetrics:(NSMutableArray*) campaigndict;
-(void) Actioncampaignclicked:(NSString*)campidnoti;
-(void) Actioncampaignclickedvalue:(NSString*)campidnoti;
-(void) Actioncampaignclickedvalueforsecondbutton:(NSString*)campidnoti;
-(int) showcurrentcount:(NSString*) idofcamp;
-(void) comparisionWithDB;
-(void)saveActiveEventState:(NSDictionary*)eventsinfo;
-(void)saveActiveEventStateProcess;
-(void) deleteventsaftershow:(NSString*) cam_id;

@end

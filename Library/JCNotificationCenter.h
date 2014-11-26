#import <Foundation/Foundation.h>
#import "JCNotificationBanner.h"

@class JCNotificationBannerPresenter;

@interface JCNotificationCenter : NSObject

@property (nonatomic) JCNotificationBannerPresenter* presenter;

+ (JCNotificationCenter*) sharedCenter;

/** Adds notification to queue with given parameters. */
+ (void) enqueueNotificationWithTitle:(NSString*)title
                              message:(NSString*)message
                           tapHandler:(JCNotificationBannerTapHandlingBlock)tapHandler;

+ (void) enqueueNotificationWithImage:(UIImage*)image
								title:(NSString*)title
							  message:(NSString*)message
						   tapHandler:(JCNotificationBannerTapHandlingBlock)tapHandler;

+ (void) enqueueNotificationWithOptions:(NSDictionary *)options
                               message:(NSString*)_message
                            tapHandler:(JCNotificationBannerTapHandlingBlock)tapHandler ;

+ (void) clearQueueNumber:(NSNumber*)queue;
+ (void) clearQueue;

- (void) enqueueNotificationWithTitle:(NSString*)title
                              message:(NSString*)message
                           tapHandler:(JCNotificationBannerTapHandlingBlock)tapHandler;

- (void) enqueueNotification:(JCNotificationBanner*)notification;

@end

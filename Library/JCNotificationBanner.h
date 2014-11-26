#import <Foundation/Foundation.h>


typedef void (^JCNotificationBannerTapHandlingBlock)();

NSString *const JCNotificationAttributeImage;
NSString *const JCNotificationAttributeTitle;
NSString *const JCNotificationAttributeType;
NSString *const JCNotificationAttributeQueueNumber;
NSString *const JCNotificationAttributeTimeout;

@interface JCNotificationBanner : NSObject

@property (nonatomic) UIImage* image;
@property (nonatomic) NSString* title;
@property (nonatomic) NSString* message;
@property (nonatomic) NSString* type;
@property (nonatomic, assign) NSInteger queueNumber;
@property (nonatomic, assign) NSTimeInterval timeout;
@property (nonatomic, copy) JCNotificationBannerTapHandlingBlock tapHandler;

- (JCNotificationBanner*) initWithTitle:(NSString*)title
                                message:(NSString*)message
                             tapHandler:(JCNotificationBannerTapHandlingBlock)tapHandler;

- (JCNotificationBanner*) initWithImage:(UIImage*)image
								  title:(NSString*)title
								message:(NSString*)message
							 tapHandler:(JCNotificationBannerTapHandlingBlock)tapHandler;

- (JCNotificationBanner*) initWithTitle:(NSString*)title
								message:(NSString*)message
								  image:(UIImage*)_image
								timeout:(NSTimeInterval)timeout
							 tapHandler:(JCNotificationBannerTapHandlingBlock)tapHandler;

- (JCNotificationBanner*) initWithOptions:(NSDictionary *)options
                                                 message:(NSString*)_message
                                             tapHandler:(JCNotificationBannerTapHandlingBlock)tapHandler;

@end

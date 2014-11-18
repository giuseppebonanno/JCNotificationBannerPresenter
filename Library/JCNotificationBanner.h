#import <Foundation/Foundation.h>

typedef void (^JCNotificationBannerTapHandlingBlock)();

@interface JCNotificationBanner : NSObject

@property (nonatomic) UIImage* image;
@property (nonatomic) NSString* title;
@property (nonatomic) NSString* message;
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

@end

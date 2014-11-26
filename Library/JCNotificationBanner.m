#import "JCNotificationBanner.h"

@implementation JCNotificationBanner

@synthesize image;
@synthesize title;
@synthesize message;
@synthesize type;
@synthesize queueNumber;
@synthesize timeout;
@synthesize tapHandler;

NSString *const JCNotificationAttributeImage=@"JCNotificationAttributeImage";
NSString *const JCNotificationAttributeTitle=@"JCNotificationAttributeTitle";
NSString *const JCNotificationAttributeType=@"JCNotificationAttributeType";
NSString *const JCNotificationAttributeQueueNumber=@"JCNotificationAttributeQueueNumber";
NSString *const JCNotificationAttributeTimeout=@"JCNotificationAttributeTimeout";

- (JCNotificationBanner*) initWithTitle:(NSString*)_title
                                message:(NSString*)_message
                             tapHandler:(JCNotificationBannerTapHandlingBlock)_tapHandler {
  
  return [self initWithTitle:_title message:_message image:image timeout:5.0 tapHandler:_tapHandler];
}

- (JCNotificationBanner*) initWithImage:(UIImage*)_image
								title:(NSString*)_title
								message:(NSString*)_message
							 tapHandler:(JCNotificationBannerTapHandlingBlock)_tapHandler {
	
	return [self initWithTitle:_title message:_message image:_image timeout:5.0 tapHandler:_tapHandler];
}

- (JCNotificationBanner*) initWithOptions:(NSDictionary *)options
                                            message:(NSString*)_message
                                             tapHandler:(JCNotificationBannerTapHandlingBlock)_tapHandler{
    
    self = [super init];
    if (self) {
        self.title = [options objectForKey:JCNotificationAttributeTitle] ? [options objectForKey:JCNotificationAttributeTitle] : nil;
        self.message = _message;
        self.image = [options objectForKey:JCNotificationAttributeImage] ? [options objectForKey:JCNotificationAttributeImage] : nil;
        self.type = [options objectForKey:JCNotificationAttributeType] ? [options objectForKey:JCNotificationAttributeType] : nil;
        self.queueNumber = [options objectForKey:JCNotificationAttributeQueueNumber] ? [[options objectForKey:JCNotificationAttributeQueueNumber] intValue] : 0;
        self.timeout = [options objectForKey:JCNotificationAttributeTimeout] ? [[options objectForKey:JCNotificationAttributeTimeout]doubleValue] : 5.0;
        self.tapHandler = _tapHandler;
    }
    return self;

}

- (JCNotificationBanner*) initWithTitle:(NSString*)_title
                                message:(NSString*)_message
								  image:(UIImage*)_image
                                timeout:(NSTimeInterval)_timeout
                             tapHandler:(JCNotificationBannerTapHandlingBlock)_tapHandler {
  
  self = [super init];
  if (self) {
    self.title = _title;
    self.message = _message;
	self.image = _image;
    self.timeout = _timeout;
    self.tapHandler = _tapHandler;
  }
  return self;
}

@end

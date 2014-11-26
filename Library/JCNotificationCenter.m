#import "JCNotificationCenter.h"
#import "JCNotificationBannerPresenter.h"
#import "JCNotificationBannerPresenterIOSStyle.h"
#import "JCNotificationBannerPresenterIOS7Style.h"
#import "JCNotificationBannerWindow.h"
#import "JCNotificationBannerPresenter_Private.h"

@interface JCNotificationCenter () {
@private
  NSMutableArray* enqueuedNotifications;
  NSLock* isPresentingMutex;
  NSObject* notificationQueueMutex;
  JCNotificationBannerPresenter* _currentPresenter;
  JCNotificationBannerPresenter* _nextPresenter;
}
@end

@implementation JCNotificationCenter

- (JCNotificationCenter*) init {
  self = [super init];
  if (self) {
    enqueuedNotifications = [NSMutableArray new];
    isPresentingMutex = [NSLock new];
    notificationQueueMutex = [NSObject new];
    self.presenter = [[[self class] presenterClass] new];
  }
  return self;
}

+ (JCNotificationCenter*) sharedCenter {
  static JCNotificationCenter* sharedCenter = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    sharedCenter = [[self class] new];
  });
  return sharedCenter;
}

+ (Class) presenterClass {
	return [JCNotificationBannerPresenterIOS7Style class];
//  return [JCNotificationBannerPresenterIOSStyle class];
}

/** Adds notification with iOS banner Style to queue with given parameters. */
+ (void) enqueueNotificationWithTitle:(NSString*)title
                              message:(NSString*)message
                           tapHandler:(JCNotificationBannerTapHandlingBlock)tapHandler {
  JCNotificationBanner* notification = [[JCNotificationBanner alloc] initWithTitle:title
                                                                           message:message
                                                                        tapHandler:tapHandler];
  
  [[self sharedCenter] enqueueNotification:notification];
}

+ (void) enqueueNotificationWithImage:(UIImage*)image
								title:(NSString*)title
							  message:(NSString*)message
						   tapHandler:(JCNotificationBannerTapHandlingBlock)tapHandler {
	
	JCNotificationBanner* notification = [[JCNotificationBanner alloc]initWithImage:image
																			   title:title
																			 message:message
																		  tapHandler:tapHandler];
	
	[[self sharedCenter] enqueueNotification:notification];
}

+ (void) enqueueNotificationWithOptions:(NSDictionary*)options
                            message:(NSString*)message
                           tapHandler:(JCNotificationBannerTapHandlingBlock)tapHandler {
    
    JCNotificationBanner* notification = [[JCNotificationBanner alloc] initWithOptions:options
                                                                                             message:(NSString*)message
                                                                                          tapHandler:tapHandler];
    
    [[self sharedCenter] enqueueNotification:notification];
}


+ (void) clearQueueNumber:(NSNumber *)queue {
    
    [[self sharedCenter] cleanEnqueueNotification:queue];
    
    return ;
}
+ (void) clearQueue {
    
    [[self sharedCenter] cleanEnqueueNotification:nil];
    
    return ;
}

- (void) enqueueNotificationWithTitle:(NSString*)title
                              message:(NSString*)message
                           tapHandler:(JCNotificationBannerTapHandlingBlock)tapHandler {
    JCNotificationBanner* notification = [[JCNotificationBanner alloc]
                                          initWithTitle:title
                                          message:message
                                          tapHandler:tapHandler];
  [self enqueueNotification:notification];
}

- (void) enqueueNotification:(JCNotificationBanner*)notification {
  @synchronized(notificationQueueMutex) {
    [enqueuedNotifications addObject:notification];
  }
  [self beginPresentingNotifications];
}

- (JCNotificationBanner*) dequeueNotification {
  JCNotificationBanner* notification;
  @synchronized(notificationQueueMutex) {
    if ([enqueuedNotifications count] > 0) {
      notification = [enqueuedNotifications objectAtIndex:0];
      [enqueuedNotifications removeObjectAtIndex:0];
    }
  }
  return notification;
}


- (void) cleanEnqueueNotification:(NSNumber*)queue {
    
    //NSLog(@"queueNumber: %d",[queue integerValue]);
	   for (int i=0; i < enqueuedNotifications.count; i++)
       {
           JCNotificationBanner* currentNotification=[enqueuedNotifications objectAtIndex:i];
           if ( currentNotification.queueNumber  == [queue integerValue])
           {
               //NSLog(@"rinuovo la coda numero: %d",currentNotification.queueNumber);
               [enqueuedNotifications removeObjectAtIndex:i];
           }
       }
           
	
	if (!queue && [enqueuedNotifications count] > 0) {
		[enqueuedNotifications removeAllObjects];
	}
	return ;
}



- (void) beginPresentingNotifications {
  dispatch_async(dispatch_get_main_queue(), ^{
    if ([isPresentingMutex tryLock]) {
      // Check to see if the nextPresenter has changed *during* a group
      // of notifications.
      if (_currentPresenter != _nextPresenter) {
        // Finish up with the original one.
        [_currentPresenter didFinishPresentingNotifications];
        _currentPresenter = nil;
      }

      if (!_currentPresenter) {
        _currentPresenter = _nextPresenter;
        [_currentPresenter willBeginPresentingNotifications];
      }
      JCNotificationBanner* nextNotification = [self dequeueNotification];
      if (nextNotification) {
        [_currentPresenter presentNotification:nextNotification
                                      finished:^{
                                        [self donePresentingNotification:nextNotification];
                                      }];
      } else {
        [_currentPresenter didFinishPresentingNotifications];
        _currentPresenter = nil;
        [isPresentingMutex unlock];
      }
    } else {
      // Notification presentation already in progress; do nothing.
    }
  });
}

- (void) donePresentingNotification:(JCNotificationBanner*)notification {
  // Process any notifications enqueued during this one's presentation.
  [isPresentingMutex unlock];
  [self beginPresentingNotifications];
}

- (void) setPresenter:(JCNotificationBannerPresenter*)presenter {
  _nextPresenter = presenter;
}

- (JCNotificationBannerPresenter*) presenter {
  return _nextPresenter;
}

@end

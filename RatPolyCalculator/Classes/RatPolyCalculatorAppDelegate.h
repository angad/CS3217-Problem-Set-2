#import <UIKit/UIKit.h>

@class RatPolyCalculatorViewController;

@interface RatPolyCalculatorAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    RatPolyCalculatorViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet RatPolyCalculatorViewController *viewController;

@end


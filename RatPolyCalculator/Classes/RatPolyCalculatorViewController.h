#import <UIKit/UIKit.h>

@interface RatPolyCalculatorViewController : UIViewController {
	IBOutlet UILabel *resultDisplay;
	IBOutlet UITextField *polyText1;
	IBOutlet UITextField *polyText2;
	NSString *str;
}

@property (nonatomic, retain) IBOutlet UILabel *resultDisplay;
@property (nonatomic, retain) IBOutlet UITextField *polyText1;
@property (nonatomic, retain) IBOutlet UITextField *polyText2;

-(IBAction)buttonPress:(UIButton*)sender;

@end
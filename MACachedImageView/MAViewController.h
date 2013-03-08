
#import <UIKit/UIKit.h>
#import "MACachedImageView.h"

@interface MAViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITextField *txtURL;
@property (strong, nonatomic) IBOutlet MACachedImageView *cachedImageView;

- (IBAction)onLoad:(id)sender;
- (IBAction)onLoadForced:(id)sender;
- (IBAction)onLoadLocal:(id)sender;
- (IBAction)onTogglePlaceholder:(id)sender;

@end

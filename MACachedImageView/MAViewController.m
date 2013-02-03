
#import "MAViewController.h"

@interface MAViewController ()

@end

@implementation MAViewController

- (IBAction)onLoad:(id)sender {
    NSString *rawURL = self.txtURL.text;
    rawURL = @"http://images2.fanpop.com/images/photos/7200000/Candy-candy-7296348-2274-1647.jpg";
    if(rawURL.length > 0) {
        NSURL *url = [NSURL URLWithString:rawURL];        
        [self.cachedImageView loadCachedImageFromURL:url];
    }
}
@end

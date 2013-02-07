
#import "MAViewController.h"

@interface MAViewController ()

@end

@implementation MAViewController

-(void)viewDidLoad {
    //self.cachedImageView.placeholderImage = [UIImage imageNamed:@"placeholder.png"];
}

- (IBAction)onLoad:(id)sender {
    NSString *rawURL = self.txtURL.text;
    if(rawURL.length > 0) {
        NSURL *url = [NSURL URLWithString:rawURL];
        [self.cachedImageView loadImageFromURL:url];
    }
}

- (IBAction)onLoadForced:(id)sender {
    NSString *rawURL = self.txtURL.text;
    if(rawURL.length > 0) {
        NSURL *url = [NSURL URLWithString:rawURL];
        [self.cachedImageView loadImageFromURL:url forceRefreshingCache:YES];
    }
}
@end

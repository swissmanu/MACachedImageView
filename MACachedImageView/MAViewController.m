
#import "MAViewController.h"

@interface MAViewController ()

@end

@implementation MAViewController

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

- (IBAction)onTogglePlaceholder:(id)sender {
    UISwitch *switcher = (UISwitch*)sender;
    
    if(switcher.on) {
        self.cachedImageView.placeholderImage = [UIImage imageNamed:@"placeholder.png"];
    } else {
        self.cachedImageView.placeholderImage = nil;
    }
}
@end

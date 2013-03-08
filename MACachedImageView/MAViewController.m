
#import "MAViewController.h"

@interface MAViewController ()

@end

@implementation MAViewController

- (IBAction)onLoad:(id)sender {
    NSString *rawURL = self.txtURL.text;
    if(rawURL.length > 0) {
        NSURL *url = [NSURL URLWithString:rawURL];
        [self.cachedImageView displayImageFromURL:url];
    }
}

- (IBAction)onLoadForced:(id)sender {
    NSString *rawURL = self.txtURL.text;
    if(rawURL.length > 0) {
        NSURL *url = [NSURL URLWithString:rawURL];
        [self.cachedImageView displayImageFromURL:url forceRefreshingCache:YES];
    }
}

- (IBAction)onLoadLocal:(id)sender {
    // Image source: http://www.sailingchartersaltspring.com/index.php/sailing-courses/sailing_to_the_sunrise/
    UIImage *localImage = [UIImage imageNamed:@"sailing.jpg"];
    [self.cachedImageView displayImage:localImage];
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

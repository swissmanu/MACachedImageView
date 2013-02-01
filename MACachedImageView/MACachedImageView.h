
#import <UIKit/UIKit.h>
#import <AFNetworking.h>
#import <MACircleProgressIndicator.h>

@interface MACachedImageView : UIView

@property (nonatomic, retain) UIColor *progressIndicatorColor UI_APPEARANCE_SELECTOR;
@property (nonatomic) CGFloat progressIndicatorStrokeWidth UI_APPEARANCE_SELECTOR;
@property (nonatomic) CGFloat progressIndicatorStrokeWidhtRatio UI_APPEARANCE_SELECTOR;


-(void)loadCachedImageFromURL:(NSURL*)url;
@end


#import <UIKit/UIKit.h>
#import <AFNetworking.h>
#import <MACircleProgressIndicator.h>

@interface MACachedImageView : UIImageView

/** If no image is loaded, this placeholder image gets displayed. */
@property (nonatomic, retain) UIImage *placeholderImage UI_APPEARANCE_SELECTOR;

/** The color for the progress indicator during image downloads. */
@property (nonatomic, retain) UIColor *progressIndicatorColor UI_APPEARANCE_SELECTOR;

/** Set the stroke width of the MACircleProgressIndicator explicitly. progressIndicatorStrokeWidthRatio will be ignored. */
@property (nonatomic) CGFloat progressIndicatorStrokeWidth UI_APPEARANCE_SELECTOR;

/** Set a ratio between the MACircleProgressIndicators size and the stroke width. progressIndicatorStrokeWidth will be ignored. */
@property (nonatomic) CGFloat progressIndicatorStrokeWidthRatio UI_APPEARANCE_SELECTOR;

/** UIViewContentMode used while displaying an image. */
@property (nonatomic) UIViewContentMode imageContentMode UI_APPEARANCE_SELECTOR;

/** UIViewContentMode used for displaying the placeholder image. */
@property (nonatomic) UIViewContentMode placeholderContentMode UI_APPEARANCE_SELECTOR;


/** Display an image from the given url. If the image was requested to display before and is avialable in the cache, it gets loaded from there. If not the image gets downloaded while showing a progress indicator. */
-(void)displayImageFromURL:(NSURL*)url;

/** Display an image from the given url. If the image was requested to display before and is avialable in the cache, it gets loaded from there. If not the image gets downloaded while showing a progress indicator. You can bypass the caching mechanism by passing YES for the forceRefreshingCache parameter. The cache gets refreshed then without checking it before. */
-(void)displayImageFromURL:(NSURL*)url forceRefreshingCache:(BOOL)force;

/** Display any UIImage without using any caching mechanisms. Handy if you want to display some images from your resource bundle */
-(void)displayImage:(UIImage*)image;

@end

#import "MACachedImageView.h"
#import "NSString+MD5.h"

#define kCachedImageViewDefaultProgressIndicatorSize 35.0

@interface MACachedImageView () {
    UIImageView *_imageView;
    MACircleProgressIndicator *_progressIndicator;
}
-(void)setup;
@end


@implementation MACachedImageView

@dynamic progressIndicatorColor;
@dynamic progressIndicatorStrokeWidth;
@dynamic progressIndicatorStrokeWidhtRatio;

-(id)init {
    self = [super init];
    if(self) {
        [self setup];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if(self) {
        [self setup];
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        [self setup];
    }
    return self;
}

-(void)setup {
    _imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    _progressIndicator = [[MACircleProgressIndicator alloc] initWithFrame:CGRectZero];
    _imageView.hidden = YES;
    _progressIndicator.color = [UIColor whiteColor];
    _progressIndicator.hidden = YES;
    
    [self addSubview:_imageView];
    [self addSubview:_progressIndicator];
    
    self.backgroundColor = [UIColor darkGrayColor];
}


#pragma mark - Appearance Properties

-(void)setProgressIndicatorColor:(UIColor *)progressIndicatorColor {
    _progressIndicator.color = progressIndicatorColor;
}

-(UIColor *)progressIndicatorColor {
    return _progressIndicator.color;
}

-(void)setProgressIndicatorStrokeWidth:(CGFloat)progressIndicatorStrokeWidth {
    _progressIndicator.strokeWidth = progressIndicatorStrokeWidth;
}

-(CGFloat)progressIndicatorStrokeWidth {
    return _progressIndicator.strokeWidth;
}

-(void)setProgressIndicatorStrokeWidhtRatio:(CGFloat)progressIndicatorStrokeWidhtRatio {
    _progressIndicator.strokeWidthRatio = progressIndicatorStrokeWidhtRatio;
}

-(CGFloat)progressIndicatorStrokeWidhtRatio {
    return _progressIndicator.strokeWidthRatio;
}


#pragma mark - Image Display

-(void)loadImageFromURL:(NSURL*) url {
    [self loadImageFromURL:url forceRefreshingCache:NO];
}

-(void)loadImageFromURL:(NSURL*) url forceRefreshingCache:(BOOL)force {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachePath = [paths objectAtIndex:0];
    cachePath = [cachePath stringByAppendingPathComponent:@"macachedimageview"];
    BOOL isDir = NO;
    NSError *error;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath:cachePath isDirectory:&isDir] && isDir == NO) {
        [fileManager createDirectoryAtPath:cachePath withIntermediateDirectories:NO attributes:nil error:&error];
    }
    
    NSString *filename = [[url absoluteString] md5];
    NSString *filePath = [cachePath stringByAppendingPathComponent:filename];
    
    if(force || ![fileManager fileExistsAtPath:filePath]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            _progressIndicator.value = 0;
            _imageView.hidden = YES;
            _progressIndicator.hidden = NO;
            
            NSMutableURLRequest* req = [NSMutableURLRequest requestWithURL:url];
            
            AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:req];
            operation.outputStream = [NSOutputStream outputStreamToFileAtPath:filePath append:NO];
            [operation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
                float progress = (float)totalBytesRead / (float)totalBytesExpectedToRead;
                _progressIndicator.value = progress;
            }];
            
            [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSLog(@"SUCCCESSFULL IMG RETRIEVE to %@!", filePath);
                _imageView.image = [UIImage imageWithContentsOfFile:filePath];
                _progressIndicator.hidden = YES;
                _imageView.hidden = NO;
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"ERROR");
            }];
            
            [operation start];
        });
    } else {
        _imageView.image = [UIImage imageWithContentsOfFile:filePath];
        _imageView.hidden = NO;
    }
}


#pragma mark - Layout
    
-(void)layoutSubviews {
    CGRect frame = self.frame;
    
    _imageView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
    _progressIndicator.frame = CGRectMake(
        (frame.size.width-kCachedImageViewDefaultProgressIndicatorSize)/2,
        (frame.size.height-kCachedImageViewDefaultProgressIndicatorSize)/2,
        kCachedImageViewDefaultProgressIndicatorSize,
        kCachedImageViewDefaultProgressIndicatorSize
    );
}

@end

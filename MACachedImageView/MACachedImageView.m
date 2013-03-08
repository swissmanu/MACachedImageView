
#import "MACachedImageView.h"
#import <CommonCrypto/CommonDigest.h>

#define kCachedImageViewDefaultProgressIndicatorSize 35.0
#define kSubfolderImageCache @"macachedimageview"

#pragma mark - Private MD5 NSString extension

@interface NSString (MD5)
- (NSString *) md5;
@end


#pragma mark - Private Interface Extensions

@interface MACachedImageView () {
    MACircleProgressIndicator *_progressIndicator;
    BOOL _displayingImage;
}

/** Setup the MACachedImageView */
-(void)setup;

/** Returns the path to the caching directoy. If the directory does not exist already, it gets created. */
-(NSString*)cacheDirectoryPath;

/** Checks if a specific file with the given path exists. */
-(BOOL)fileExists:(NSString*)path;

/** Downloads an image from the given url to the passed destinationPath. If a MACircleProgressIndicator is passed for progressIndicator, this progress indicator gets updated with the progress of the download process. After finishing the download, callback is executed. If an error occoured, the parameter "filePath" of callback will be nil. */
-(void)downloadImageFromURL:(NSURL*)url
                 toFilePath:(NSString*)destinationPath
          progressIndicator:(MACircleProgressIndicator*)progressIndicator
                   callback:(void(^)(NSString* filePath))callback;

/** Hides the currently displayed image. If a placeholder image was defined, that one gets displayed. */
-(void)hideImage;

/** Displays the given image using the passed UIViewContentMode. */
-(void)displayImage:(UIImage*)image withContentMode:(UIViewContentMode)contentMode;
@end


#pragma mark - MACachedView Implementation

@implementation MACachedImageView

@synthesize placeholderImage = _placeholderImage;
@dynamic progressIndicatorColor;
@dynamic progressIndicatorStrokeWidth;
@dynamic progressIndicatorStrokeWidthRatio;
@synthesize imageContentMode = _imageContentMode;
@synthesize placeholderContentMode = _placeholderContentMode;

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
    _progressIndicator = [[MACircleProgressIndicator alloc] initWithFrame:CGRectZero];
    
    _progressIndicator.color = [UIColor whiteColor];
    _progressIndicator.hidden = YES;
    self.backgroundColor = [UIColor darkGrayColor];
    self.imageContentMode = UIViewContentModeScaleAspectFill;
    self.placeholderContentMode = UIViewContentModeCenter;
    
    [self addSubview:_progressIndicator];
    
    [self hideImage];
}


#pragma mark - Appearance Properties

-(void)setPlaceholderImage:(UIImage *)placeholderImage {
    _placeholderImage = placeholderImage;
    
    if(!_displayingImage) {
        // Ensure the new placeholder image is properly displayed.
        [self hideImage];
    }
}

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

-(CGFloat)progressIndicatorStrokeWidthRatio {
    return _progressIndicator.strokeWidthRatio;
}

-(void)setImageContentMode:(UIViewContentMode)imageContentMode {
    _imageContentMode = imageContentMode;
    
    if(_displayingImage) {
        self.contentMode = imageContentMode;
    }
}

-(void)setPlaceholderContentMode:(UIViewContentMode)placeholderContentMode {
    _placeholderContentMode = placeholderContentMode;
    
    if(!_displayingImage && _placeholderImage != nil) {
        self.contentMode = placeholderContentMode;
    }
}


#pragma mark - Image Display

-(void)displayImageFromURL:(NSURL*)url {
    [self displayImageFromURL:url forceRefreshingCache:NO];
}

-(void)displayImageFromURL:(NSURL*)url forceRefreshingCache:(BOOL)force {
    NSString *cacheDirectory = [self cacheDirectoryPath];
    NSString *cachedFilename = [[url absoluteString] md5];
    NSString *cachedFilePath = [cacheDirectory stringByAppendingPathComponent:cachedFilename];
    
    if(force || ![self fileExists:cachedFilePath]) {
        [self hideImage];
        _progressIndicator.value = 0;
        _progressIndicator.hidden = NO;
        
        [self downloadImageFromURL:url toFilePath:cachedFilePath progressIndicator:_progressIndicator callback:^(NSString *filePath) {
            _progressIndicator.hidden = YES;
            
            if(filePath != nil) {
                UIImage *cachedImage = [UIImage imageWithContentsOfFile:filePath];
                [self displayImage:cachedImage withContentMode:self.imageContentMode];
            }
        }];
    } else {
        UIImage *cachedImage = [UIImage imageWithContentsOfFile:cachedFilePath];
        [self displayImage:cachedImage withContentMode:self.imageContentMode];
    }
}

-(void)displayImage:(UIImage *)image {
    [self displayImage:image withContentMode:self.imageContentMode];
}

-(void)downloadImageFromURL:(NSURL*)url
                 toFilePath:(NSString*)destinationPath
          progressIndicator:(MACircleProgressIndicator*)progressIndicator
                   callback:(void(^)(NSString* filePath))callback {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSMutableURLRequest* req = [NSMutableURLRequest requestWithURL:url];
        
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:req];
        operation.outputStream = [NSOutputStream outputStreamToFileAtPath:destinationPath append:NO];
        [operation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
            float progress = (float)totalBytesRead / (float)totalBytesExpectedToRead;
            if(progressIndicator) progressIndicator.value = progress;
        }];
        
        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            if(callback) callback(destinationPath);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if(callback) callback(nil);
        }];
        
        [operation start];
    });
}

-(NSString*)cacheDirectoryPath {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachePath = [paths objectAtIndex:0];
    NSError *error;
    BOOL isDir = NO;
    
    cachePath = [cachePath stringByAppendingPathComponent:kSubfolderImageCache];
    
    if (![fileManager fileExistsAtPath:cachePath isDirectory:&isDir] && isDir == NO) {
        [fileManager createDirectoryAtPath:cachePath withIntermediateDirectories:NO attributes:nil error:&error];
    }
    
    return cachePath;
}

-(BOOL)fileExists:(NSString*)path {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    return [fileManager fileExistsAtPath:path isDirectory:NO];
}

-(void)hideImage {
    if(_placeholderImage) {
        [self displayImage:_placeholderImage withContentMode:self.placeholderContentMode];
    } else {
        self.image = nil;
    }
    _displayingImage = NO;
}

-(void)displayImage:(UIImage*)image withContentMode:(UIViewContentMode)contentMode {
    _displayingImage = YES;
    self.contentMode = contentMode;
    self.image = image;
}

#pragma mark - Layout
    
-(void)layoutSubviews {
    CGRect frame = self.frame;
    
    _progressIndicator.frame = CGRectMake(
        (frame.size.width-kCachedImageViewDefaultProgressIndicatorSize)/2,
        (frame.size.height-kCachedImageViewDefaultProgressIndicatorSize)/2,
        kCachedImageViewDefaultProgressIndicatorSize,
        kCachedImageViewDefaultProgressIndicatorSize
    );
}

@end


#pragma mark - MD5 NSString Extension Implementation

@implementation NSString (MD5)

- (NSString *) md5 {
    const char *cStr = [self UTF8String];
    unsigned char result[16];
    CC_MD5( cStr, strlen(cStr), result );
    
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

@end

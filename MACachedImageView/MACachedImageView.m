
#import "MACachedImageView.h"
#import "NSString+MD5.h"

#define kCachedImageViewDefaultProgressIndicatorSize 35.0
#define kSubfolderImageCache @"macachedimageview"

@interface MACachedImageView () {
    UIImageView *_imageView;
    MACircleProgressIndicator *_progressIndicator;
}

-(void)setup;

-(NSString*)cacheDirectoryPath;
-(BOOL)fileExists:(NSString*)path;
-(void)downloadImageFromURL:(NSURL*)url
                 toFilePath:(NSString*)destinationPath
          progressIndicator:(MACircleProgressIndicator*)progressIndicator
                   callback:(void(^)(NSString* filePath))callback;
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
    NSString *cacheDirectory = [self cacheDirectoryPath];
    NSString *cachedFilename = [[url absoluteString] md5];
    NSString *cachedFilePath = [cacheDirectory stringByAppendingPathComponent:cachedFilename];
    
    if(force || ![self fileExists:cachedFilePath]) {
        _imageView.hidden = YES;
        _progressIndicator.value = 0;
        _progressIndicator.hidden = NO;
        
        [self downloadImageFromURL:url toFilePath:cachedFilePath progressIndicator:_progressIndicator callback:^(NSString *filePath) {
            _imageView.image = [UIImage imageWithContentsOfFile:filePath];
            _progressIndicator.hidden = YES;
            _imageView.hidden = NO;
        }];
    } else {
        _imageView.image = [UIImage imageWithContentsOfFile:cachedFilePath];
        _imageView.hidden = NO;
    }
}

-(void)downloadImageFromURL:(NSURL*)url toFilePath:(NSString*)destinationPath progressIndicator:(MACircleProgressIndicator*)progressIndicator callback:(void(^)(NSString* filePath))callback {
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

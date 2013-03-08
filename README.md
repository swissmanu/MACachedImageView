# MACachedImageView
## Overview
`MACachedImageView` is a `UIImageView` for displaying images on demand from the web. It's Spiced up with a caching functionality and a fancy load progress indicator. Developed with iOS 6 in mind, but probably working with older iOS releases.

![Screenshot](https://raw.github.com/swissmanu/MACachedImageView/master/screenshot.png)

## Installation
### CocoaPods
The easiest way to install `MACachedImageView` is using [CocoaPods](http://cocoapods.org/). Add the following dependency to your `Podfile` and run the `pod install` command via command line:

	pod 'MACachedImageView', '~> 1.1.0'

### Manual
If you'd like to install without CocoaPods, clone this repository and copy the following files from the `MACachedImageView/` subfolder into your project:

* `MACachedImageView.h`
* `MACachedImageView.m`

Further you have to add two dependent libraries manually to your project:

* [AFNetworking](https://github.com/AFNetworking/AFNetworking)
* [MACircleProgressIndicator](https://github.com/swissmanu/MACircleProgressIndicator)

## Usage
```objective-c
MACachedImageView *cachedImageView = [MACachedImageView alloc] initWithFrame:CGRectMake(0,0,100,100)];
NSURL *url = [NSURL URLWithString:@"http://my.fancy.images.com/image.jpg"];

// Show an image by using the cache, if already available:
[cachedImageView displayImageFromURL:url];

// Show an image and force to refresh the cache:
[cachedImageView displayImageFromURL:url forceRefreshingCache:YES];

// Show a "local" UIImage:
UIImage *image = [UIImage imageNamed:@"image.jpg"];
[cachedImageView displayImage:image];

```

## Customization
The view is customizable using direct property assignments or the appearance object:

```objective-c
MACachedImageView *appearance = [MACachedImageView appearance];

// Showing an image if no image is loaded yet or during loading an image:
appearance.placeholderImage = [UIImage imageNamed:@"..."];

// Use the placeholderImageContentMode property to decide how the placeholder
// image should be placed when shown.
appearance.placeholderImageContentMode = UIViewContentModeCenter;

// When displaying a loaded image, this content mode is used to show it properly.
appearance.imageContentMode = UIViewContentModeScaleAspectFill;

// The color of the download progress indicator.
appearance.progressIndicatorColor = [UIColor whiteColor];

// Set the stroke width of the MACircleProgressIndicator explicitly.
// progressIndicatorStrokeWidthRatio will be ignored.
//appearance.progressIndicatorStrokeWidth = 1.0;

// Set a ratio between the MACircleProgressIndicators size and the stroke width.
// progressIndicatorStrokeWidth will be ignored.
//appearance.progressIndicatorStrokeWidthRatio = 0.15; // default ratio, just for information :)
```

## Demonstration App
Clone this repository and run `pod install` on the command line to fetch all dependencies. Open the resulting workspace file. `Run` the the regarding build schema to start the demo app in the iPhone or iPad simulator.
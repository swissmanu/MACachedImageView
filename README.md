# MACachedImageView
## Overview
`MACachedImageView` is a UIView for displaying images on demand from the web. It's Spiced up with a caching functionality and a fancy load progress indicator. Developed with iOS 6 in mind, but probably working with older iOS releases.

![Screenshot](https://raw.github.com/swissmanu/MACachedImageView/master/screenshot.png)

## Installation
### CocoaPods
The easiest way to install `MACachedImageView` is using [CocoaPods](http://cocoapods.org/). Add the following dependency to your `Podfile` and run the `pod install` command via command line:

	pod 'MACachedImageView', '~> 1.0.0'

### Manual
If you'd like to install without CocoaPods, clone this repository and copy the following files from the `MACachedImageView/` subfolder into your project:

* `MACachedImageView.h`
* `MACachedImageView.m`
* `NSString+MD5.h`
* `NSString+MD5.m`

Further you have to add two dependent libraries manually to your project:

* [AFNetworking](https://github.com/AFNetworking/AFNetworking)
* [MACircleProgressIndicator](https://github.com/swissmanu/MACircleProgressIndicator)

## Usage
// TODO

## Customization
The view is customizable using direct property assignments or the appearance object:

```objective-c
MACachedImageView *appearance = [MACachedImageView appearance];

// TODO
```

## Demonstration App
Clone this repository and run `pod install` on the command line to fetch all dependencies. Open the resulting workspace file. `Run` the the regarding build schema to start the demo app in the iPhone or iPad simulator.
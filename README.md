# MACachedImageView
## Overview
`MACachedImageView` is a UIView for displaying images on demand from the web. It's Spiced up with a caching functionality and a fancy load progress indicator. Developed with iOS 6 in mind, but probably working with older iOS releases.

![Screenshot](https://raw.github.com/swissmanu/MACachedImageView/master/screenshot.png)

## Installation
The easiest way to install `MACachedImageView` is using [CocoaPods](http://cocoapods.org/). Add the following dependency to your `Podfile` and run the `pod install` command via command line:

	pod 'MACachedImageView', '~> 1.0.0'

If you'd like to install without CocoaPods, clone this repository and extract `MACachedImageView.h` and `MACachedImageView.m` from the `MACachedImageView/` subfolder and copy them into your project.

## Usage
// TODO

## Customization & Demo
The view is customizable using direct property assignments or the appearance object:

```objective-c
MACachedImageView *appearance = [MACachedImageView appearance];

// TODO
```

Clone the repository and you'll have a running demonstration app ready on your machine: Open `MACachedImageView.xcodeproj` with Xcode and run the App in the iPhone or iPad simulator.
# CircleSlider

[![CI Status](http://img.shields.io/travis/shushutochako/CircleSlider.svg?style=flat)](https://travis-ci.org/shushutochako/CircleSlider)
[![Version](https://img.shields.io/cocoapods/v/CircleSlider.svg?style=flat)](http://cocoapods.org/pods/CircleSlider)
[![License](https://img.shields.io/cocoapods/l/CircleSlider.svg?style=flat)](http://cocoapods.org/pods/CircleSlider)
[![Platform](https://img.shields.io/cocoapods/p/CircleSlider.svg?style=flat)](http://cocoapods.org/pods/CircleSlider)

## Description and [appetize.io`s DEMO](https://appetize.io/app/mf8uu1ktc0r83tz4v2kzzumygm)
![](https://github.com/shushutochako/CircleSlider/blob/master/ScreenShots/Screenshot.gif)

## Usage

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements
- iOS 8.0+
- Xcode 7

## Installation

### CocoaPods(iOS 8+)
CircleSlider is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
use_frameworks!
pod "CircleSlider"
```

### Manual Installation
The class file required for CircleSlider is located in the Classes folder in the root of this repository as listed below:
```
CircleSlider.swift
TrackLayer.swift
Math.swift
```

## Usage
To run the example project, clone the repo, and run pod install from the Example directory first.

### Simple
```
self.circleSlider = CircleSlider(frame: self.sliderArea.bounds, options: nil)
self.circleSlider?.addTarget(self, action: Selector("valueChange:"), forControlEvents: .ValueChanged)
self.sliderArea.addSubview(self.circleSlider)
```

### Custom
```
let options = [
.BarColor(UIColor(red: 198/255, green: 244/255, blue: 23/255, alpha: 0.2)),
.ThumbColor(UIColor(red: 141/255, green: 185/255, blue: 204/255, alpha: 1)),
.TrackingColor(UIColor(red: 78/255, green: 136/255, blue: 185/255, alpha: 1)),
.BarWidth(20),
.StartAngle(-45),
.MaxValue(150),
.MinValue(20)
]
self.circleSlider = CircleSlider(frame: self.sliderArea.bounds, options: options)
self.circleSlider?.addTarget(self, action: Selector("valueChange:"), forControlEvents: .ValueChanged)
self.sliderArea.addSubview(self.circleSlider)

```

### Change options after instantiation
```
self.circleSlider.changeOptions([.BarWidth(45)])
```

## Customization
- ``case StartAngle(Double)``
- ``case BarColor(UIColor)``
- ``case TrackingColor(UIColor)``
- ``case ThumbColor(UIColor)``
- ``case BarWidth(CGFloat)``
- ``case ThumbWidth(CGFloat)``
- ``case MaxValue(Float)``
- ``case MinValue(Float)``
- ``case SliderEnabled(Bool) ``
    - If you want to use as a progress, it should be this to false

## Author
shushutochako, shushutochako22@gmail.com

## License
CircleSlider is available under the MIT license. See the LICENSE file for more info.

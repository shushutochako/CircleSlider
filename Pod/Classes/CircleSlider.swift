//
//  CircleSlider.swift
//  CircleSlider
//
//  Created by shushutochako on 11/17/15.
//  Copyright © 2015 shushutochako. All rights reserved.
//

public enum CircleSliderOption {
  case StartAngle(Double)
  case BarColor(UIColor)
  case TrackingColor(UIColor)
  case ThumbColor(UIColor)
  case BarWidth(CGFloat)
  case ThumbWidth(CGFloat)
  case MaxValue(Float)
  case MinValue(Float)
  case SliderEnabled(Bool)
}

public class CircleSlider: UIControl {
  private var latestDegree: Double = 0
  private var _value: Float = 0
  public var value: Float {
    get {
      return self._value
    }
    set {
      self._value = newValue
      self.sendActionsForControlEvents(.ValueChanged)
      let degree = Math.degreeFromValue(self.startAngle, value: self.value, maxValue: self.maxValue, minValue: self.minValue)
      self.layout(degree)
    }
  }
  private var trackLayer: TrackLayer! {
    didSet {
      self.layer.addSublayer(self.trackLayer)
    }
  }
  private var thumbView: UIView! {
    didSet {
      if self.sliderEnabled {
        self.thumbView.backgroundColor = self.thumbColor
        self.thumbView.center = self.thumbCenter(self.startAngle)
        self.thumbView.layer.cornerRadius = self.thumbView!.bounds.size.width * 0.5
        self.addSubview(self.thumbView)
      } else {
        self.thumbView.hidden = true
      }
    }
  }
  // Options
  private var startAngle: Double = -90
  private var barColor           = UIColor.lightGrayColor()
  private var trackingColor      = UIColor.blueColor()
  private var thumbColor         = UIColor.blackColor()
  private var barWidth: CGFloat  = 20
  private var maxValue: Float    = 100
  private var minValue: Float    = 0
  private var sliderEnabled      = true
  private var _thumbWidth: CGFloat?
  private var thumbWidth: CGFloat {
    get {
      if let retValue = self._thumbWidth {
        return retValue
      }
      return self.barWidth * 1.5
    }
    set {
      self._thumbWidth = newValue
    }
  }
  
  override public func awakeFromNib() {
    super.awakeFromNib()
    self.backgroundColor = UIColor.clearColor()
  }
  
  public init(frame: CGRect, options: [CircleSliderOption]?) {
    super.init(frame: frame)
    if let options = options {
      self.build(options)
    }
  }

  required public init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
  }
  
  override public func layoutSublayersOfLayer(layer: CALayer) {
    if self.trackLayer == nil {
      self.trackLayer = TrackLayer(bounds: self.bounds, setting: self.createLayerSetting())
    }
    if self.thumbView == nil {
      self.thumbView = UIView(frame: CGRect(x: 0, y: 0, width: self.thumbWidth, height: self.thumbWidth))
    }
  }

  override public func hitTest(point: CGPoint, withEvent event: UIEvent?) -> UIView? {
    let rect = self.trackLayer.hollowRect
    let hollowPath = UIBezierPath(roundedRect: rect, cornerRadius: self.trackLayer.hollowRadius)
    if !(CGRectContainsPoint(self.bounds, point) || hollowPath.containsPoint(point)) ||
       !(CGRectContainsPoint(self.thumbView.frame, point)) {
      return nil
    }
    return self
  }
  
  override public func continueTrackingWithTouch(touch: UITouch, withEvent event: UIEvent?) -> Bool {
    let degree = Math.pointPairToBearingDegrees(self.center, endPoint: touch.locationInView(self))
    self.latestDegree = degree
    self.layout(degree)
    let value = Float(Math.adjustValue(self.startAngle, degree: degree, maxValue: self.maxValue, minValue: self.minValue))
    self.value = value
    return true
  }
  
  public func changeOptions(options: [CircleSliderOption]) {
    self.build(options)
    self.redraw()
  }
  
  private func redraw() {
    self.trackLayer.removeFromSuperlayer()
    self.trackLayer = TrackLayer(bounds: self.bounds, setting: self.createLayerSetting())
    self.thumbView.removeFromSuperview()
    self.thumbView = UIView(frame: CGRect(x: 0, y: 0, width: self.thumbWidth, height: self.thumbWidth))
    self.layout(self.latestDegree)
  }
    
  private func build(options: [CircleSliderOption]) {
    for option in options {
      switch option {
      case let .StartAngle(value):
        self.startAngle = value
        self.latestDegree = self.startAngle
      case let .BarColor(value):
        self.barColor = value
      case let .TrackingColor(value):
        self.trackingColor = value
      case let .ThumbColor(value):
        self.thumbColor = value
      case let .BarWidth(value):
        self.barWidth = value
      case let .ThumbWidth(value):
        self.thumbWidth = value
      case let .MaxValue(value):
        self.maxValue = value
      case let .MinValue(value):
        self.minValue = value
        self._value = self.minValue
      case let .SliderEnabled(value):
        self.sliderEnabled = value
      }
    }
    // Adjust because value not rise up to the maxValue
    self.maxValue++
  }
  
  private func layout(degree: Double) {
    if let trackLayer = self.trackLayer, thumbView = self.thumbView {
      trackLayer.degree = degree
      thumbView.center = self.thumbCenter(degree)
      trackLayer.setNeedsDisplay()
    }
  }
  
  private func createLayerSetting() -> TrackLayer.Setting {
    var setting = TrackLayer.Setting()
    setting.startAngle    = self.startAngle
    setting.barColor      = self.barColor
    setting.trackingColor = self.trackingColor
    setting.barWidth      = self.barWidth
    return setting
  }
  
  private func thumbCenter(degree: Double) -> CGPoint {
    let radius = (self.bounds.width * 0.5) - (self.barWidth * 0.5)
    return Math.pointFromAngle(self.frame, angle: degree, radius: Double(radius))
  }
}

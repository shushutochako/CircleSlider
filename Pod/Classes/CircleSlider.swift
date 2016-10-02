//
//  CircleSlider.swift
//  CircleSlider
//
//  Created by shushutochako on 11/17/15.
//  Copyright © 2015 shushutochako. All rights reserved.
//

public enum CircleSliderOption {
  case startAngle(Double)
  case barColor(UIColor)
  case trackingColor(UIColor)
  case thumbColor(UIColor)
  case thumbImage(UIImage)
  case barWidth(CGFloat)
  case thumbWidth(CGFloat)
  case maxValue(Float)
  case minValue(Float)
  case sliderEnabled(Bool)
  case viewInset(CGFloat)
  case minMaxSwitchTreshold(Float)
}

open class CircleSlider: UIControl {
  fileprivate let minThumbTouchAreaWidth:CGFloat = 44
  fileprivate var latestDegree: Double = 0
  fileprivate var _value: Float = 0
  open var value: Float {
    get {
      return self._value
    }
    set {
      var value = newValue
      let significantChange = (self.maxValue - self.minValue) * (1.0 - self.minMaxSwitchTreshold)
      let isSignificantChangeOccured = fabs(newValue - self._value) > significantChange
        
      if (isSignificantChangeOccured) {
        if (self._value < newValue) {
          value = self.minValue
        } else {
          value = self.maxValue
        }
      } else {
        value = newValue
      }
        
      self._value = value
      self.sendActions(for: .valueChanged)
      var degree = Math.degreeFromValue(self.startAngle, value: self.value, maxValue: self.maxValue, minValue: self.minValue)
        
      // fix rendering issue near max value
      // substract 1/100 of one degree from the current degree to fix a very little overflow
      // which otherwise cause to display a layer as it is on a min value
      if (self._value == self.maxValue) {
         degree = degree - degree / (360 * 100)
      }
        
      self.layout(degree)
    }
  }
  fileprivate var trackLayer: TrackLayer! {
    didSet {
      self.layer.addSublayer(self.trackLayer)
    }
  }
  fileprivate var thumbView: UIView! {
    didSet {
      if self.sliderEnabled {
        self.thumbView.backgroundColor = self.thumbColor
        self.thumbView.center = self.thumbCenter(self.startAngle)
        self.thumbView.layer.cornerRadius = self.thumbView!.bounds.size.width * 0.5
        self.addSubview(self.thumbView)
        if let thumbImage = self.thumbImage {
          let thumbImageView = UIImageView(frame: self.thumbView.bounds)
          thumbImageView.image = thumbImage
          self.thumbView.addSubview(thumbImageView)
          self.thumbView.backgroundColor = UIColor.clear
        }
      } else {
        self.thumbView.isHidden = true
      }
    }
  }
  // Options
  fileprivate var startAngle: Double         = -90
  fileprivate var barColor                   = UIColor.lightGray
  fileprivate var trackingColor              = UIColor.blue
  fileprivate var thumbColor                 = UIColor.black
  fileprivate var barWidth: CGFloat          = 20
  fileprivate var maxValue: Float            = 101
  fileprivate var minValue: Float            = 0
  fileprivate var sliderEnabled              = true
  fileprivate var viewInset:CGFloat          = 20
  fileprivate var minMaxSwitchTreshold:Float = 0.0 // from 0.0 to 1.0
  fileprivate var thumbImage: UIImage?
  fileprivate var _thumbWidth: CGFloat?
  fileprivate var thumbWidth: CGFloat {
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
  
  override open func awakeFromNib() {
    super.awakeFromNib()
    self.backgroundColor = UIColor.clear
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
  
  
  override open func layoutSublayers(of layer: CALayer) {
    if self.trackLayer == nil {
      self.trackLayer = TrackLayer(bounds: self.bounds.insetBy(dx: viewInset, dy: viewInset), setting: self.createLayerSetting())
    }
    if self.thumbView == nil {
      self.thumbView = UIView(frame: CGRect(x: 0, y: 0, width: self.thumbWidth, height: self.thumbWidth))
    }
  }

  override open func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
    if !self.sliderEnabled {
      return nil
    }
    let rect = self.trackLayer.hollowRect
    let hollowPath = UIBezierPath(roundedRect: rect, cornerRadius: self.trackLayer.hollowRadius)
    if !(self.bounds.contains(point) || hollowPath.contains(point)) ||
       !(self.thumbView.frame.contains(point)) {
      return nil
    }
    return self
  }
  
  override open func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
    let degree = Math.pointPairToBearingDegrees(self.center, endPoint: touch.location(in: self))
    self.latestDegree = degree
    self.layout(degree)
    let value = Float(Math.adjustValue(self.startAngle, degree: degree, maxValue: self.maxValue, minValue: self.minValue))
    self.value = value
    return true
  }
  
  open func changeOptions(_ options: [CircleSliderOption]) {
    self.build(options)
    self.redraw()
  }
  
  fileprivate func redraw() {
    
    if (self.trackLayer != nil) {
      self.trackLayer.removeFromSuperlayer()
    }
    self.trackLayer = TrackLayer(bounds: self.bounds.insetBy(dx: viewInset, dy: viewInset), setting: self.createLayerSetting())
    if (self.thumbView != nil) {
      self.thumbView.removeFromSuperview()
    }
    self.thumbView = UIView(frame: CGRect(x: 0, y: 0, width: self.thumbWidth, height: self.thumbWidth))
    self.layout(self.latestDegree)
  }
    
  fileprivate func build(_ options: [CircleSliderOption]) {
    for option in options {
      switch option {
      case let .startAngle(value):
        self.startAngle = value
        self.latestDegree = self.startAngle
      case let .barColor(value):
        self.barColor = value
      case let .trackingColor(value):
        self.trackingColor = value
      case let .thumbColor(value):
        self.thumbColor = value
      case let .barWidth(value):
        self.barWidth = value
      case let .thumbWidth(value):
        self.thumbWidth = value
      case let .maxValue(value):
        self.maxValue = value
        // Adjust because value not rise up to the maxValue
        self.maxValue += 1
      case let .minValue(value):
        self.minValue = value
        self._value = self.minValue
      case let .sliderEnabled(value):
        self.sliderEnabled = value
      case let .viewInset(value):
        self.viewInset = value
      case let .minMaxSwitchTreshold(value):
        self.minMaxSwitchTreshold = value
      case let .thumbImage(value):
        self.thumbImage = value
      }
    }
  }
  
  fileprivate func layout(_ degree: Double) {
    if let trackLayer = self.trackLayer, let thumbView = self.thumbView {
      trackLayer.degree = degree
      thumbView.center = self.thumbCenter(degree)
      trackLayer.setNeedsDisplay()
    }
  }
  
  fileprivate func createLayerSetting() -> TrackLayer.Setting {
    var setting = TrackLayer.Setting()
    setting.startAngle    = self.startAngle
    setting.barColor      = self.barColor
    setting.trackingColor = self.trackingColor
    setting.barWidth      = self.barWidth
    return setting
  }
  
  fileprivate func thumbCenter(_ degree: Double) -> CGPoint {
    let radius = (self.bounds.insetBy(dx: viewInset, dy: viewInset).width * 0.5) - (self.barWidth * 0.5)
    return Math.pointFromAngle(self.frame, angle: degree, radius: Double(radius))
  }
}

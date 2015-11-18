//
//  TrackLayer.swift
//  Pods
//
//  Created by shushutochako on 11/17/15.
//  Copyright © 2015 shushutochako. All rights reserved.
//

import UIKit

internal class TrackLayer: CAShapeLayer {
  struct Setting {
    var startAngle = Double()
    var barWidth = CGFloat()
    var barColor = UIColor()
    var trackingColor = UIColor()
  }
  internal var setting = Setting!()
  internal var degree: Double = 0
  internal var hollowRadius: CGFloat {
    return (self.bounds.width * 0.5) - self.setting.barWidth
  }
  internal var currentCenter: CGPoint {
    return CGPoint(x: CGRectGetMidX(self.bounds), y: CGRectGetMidY(self.bounds))
  }
  internal var hollowRect: CGRect {
    return CGRect(
      x: self.currentCenter.x - self.hollowRadius,
      y: self.currentCenter.y - self.hollowRadius,
      width: self.hollowRadius * 2.0,
      height: self.hollowRadius * 2.0)
  }
  internal init(bounds: CGRect, setting: Setting) {
    super.init()
    self.bounds = bounds
    self.setting = setting
    self.cornerRadius = self.bounds.size.width * 0.5
    self.position = self.currentCenter
    self.backgroundColor = self.setting.barColor.CGColor
    self.mask()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override internal func drawInContext(ctx: CGContext) {
    self.drawTrack(ctx)
  }
  
  private func mask() {
    let maskLayer = CAShapeLayer()
    maskLayer.bounds = self.bounds
    let ovalRect = self.hollowRect
    let path =  UIBezierPath(ovalInRect: ovalRect)
    path.appendPath(UIBezierPath(rect: maskLayer.bounds))
    maskLayer.path = path.CGPath
    maskLayer.position = self.currentCenter
    maskLayer.fillRule = kCAFillRuleEvenOdd
    self.mask = maskLayer
  }
  
  private func drawTrack(ctx: CGContext) {
    let adjustDegree = Math.adjustDegree(self.setting.startAngle, degree: self.degree)
    let centerX = self.currentCenter.x
    let centerY = self.currentCenter.y
    let radius = min(centerX, centerY)
    CGContextSetFillColorWithColor(ctx, self.setting.trackingColor.CGColor)
    CGContextBeginPath(ctx)
    CGContextMoveToPoint(ctx, centerX, centerY)
    CGContextAddArc(ctx, centerX, centerY, radius,
      CGFloat(Math.degreesToRadians(self.setting.startAngle - M_PI * 0.5)),
      CGFloat(Math.degreesToRadians(adjustDegree - M_PI * 0.5)), 0)
    CGContextClosePath(ctx);
    CGContextFillPath(ctx);
  }
}

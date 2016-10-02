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
  internal var setting = Setting()
  internal var degree: Double = 0
  internal var hollowRadius: CGFloat {
    return (self.bounds.width * 0.5) - self.setting.barWidth
  }
  internal var currentCenter: CGPoint {
    return CGPoint(x: self.bounds.midX, y: self.bounds.midY)
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
    self.masksToBounds = true
    self.position = self.currentCenter
    self.backgroundColor = self.setting.barColor.cgColor
    self.mask()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override internal func draw(in ctx: CGContext) {
    self.drawTrack(ctx: ctx)
  }
  
  private func mask() {
    let maskLayer = CAShapeLayer()
    maskLayer.bounds = self.bounds
    let ovalRect = self.hollowRect
    let path =  UIBezierPath(ovalIn: ovalRect)
    path.append(UIBezierPath(rect: maskLayer.bounds))
    maskLayer.path = path.cgPath
    maskLayer.position = self.currentCenter
    maskLayer.fillRule = kCAFillRuleEvenOdd
    self.mask = maskLayer
  }
  
  private func drawTrack(ctx: CGContext) {
    let adjustDegree = Math.adjustDegree(self.setting.startAngle, degree: self.degree)
    let centerX = self.currentCenter.x
    let centerY = self.currentCenter.y
    let radius = min(centerX, centerY)
    ctx.setFillColor(self.setting.trackingColor.cgColor)
    ctx.beginPath()
    ctx.move(to: CGPoint(x: centerX, y: centerY))
    ctx.addArc(center: CGPoint(x: centerX, y: centerY),
               radius: radius,
               startAngle: CGFloat(Math.degreesToRadians(self.setting.startAngle)),
               endAngle: CGFloat(Math.degreesToRadians(adjustDegree)),
               clockwise: false)
    ctx.closePath();
    ctx.fillPath();
  }
}

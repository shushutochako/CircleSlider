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
        cornerRadius = self.bounds.size.width * 0.5
        masksToBounds = true
        position = currentCenter
        backgroundColor = self.setting.barColor.cgColor
        mask()
    }
    
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    internal override func draw(in ctx: CGContext) {
        drawTrack(ctx: ctx)
    }
    
    private func mask() {
        let maskLayer = CAShapeLayer()
        maskLayer.bounds = bounds
        let ovalRect = hollowRect
        let path = UIBezierPath(ovalIn: ovalRect)
        path.append(UIBezierPath(rect: maskLayer.bounds))
        maskLayer.path = path.cgPath
        maskLayer.position = currentCenter
        maskLayer.fillRule = kCAFillRuleEvenOdd
        mask = maskLayer
    }
    
    private func drawTrack(ctx: CGContext) {
        let adjustDegree = Math.adjustDegree(setting.startAngle, degree: self.degree)
        let centerX = currentCenter.x
        let centerY = currentCenter.y
        let radius = min(centerX, centerY)
        ctx.setFillColor(setting.trackingColor.cgColor)
        ctx.beginPath()
        ctx.move(to: CGPoint(x: centerX, y: centerY))
        ctx.addArc(center: CGPoint(x: centerX, y: centerY),
                   radius: radius,
                   startAngle: CGFloat(Math.degreesToRadians(setting.startAngle)),
                   endAngle: CGFloat(Math.degreesToRadians(adjustDegree)),
                   clockwise: false)
        ctx.closePath()
        ctx.fillPath()
    }
}

//
//  ViewController.swift
//  CircleSlider
//
//  Created by shushutochako on 11/17/2015.
//  Copyright (c) 2015 shushutochako. All rights reserved.
//

import UIKit
import CircleSlider

class ViewController: UIViewController {
  @IBOutlet weak var sliderArea: UIView!
  @IBOutlet weak var progressArea: UIView!
  
  private var circleSlider: CircleSlider! {
    didSet {
      self.circleSlider.tag = 0
    }
  }
  private var circleProgress: CircleSlider! {
    didSet {
      self.circleProgress.tag = 1
    }
  }
  private var valueLabel: UILabel!
  private var progressLabel: UILabel!
  private var timer: NSTimer?
  private var progressValue: Float = 0
  private var sliderOptions: [CircleSliderOption] {
    return [
      .BarColor(UIColor(red: 198/255, green: 244/255, blue: 23/255, alpha: 0.2)),
      .ThumbColor(UIColor(red: 141/255, green: 185/255, blue: 204/255, alpha: 1)),
      .TrackingColor(UIColor(red: 78/255, green: 136/255, blue: 185/255, alpha: 1)),
      .BarWidth(20),
      .StartAngle(-45),
      .MaxValue(150),
      .MinValue(20)
    ]
  }
  private var progressOptions: [CircleSliderOption] {
    return [
      .BarColor(UIColor(red: 255/255, green: 190/255, blue: 190/255, alpha: 0.3)),
      .TrackingColor(UIColor(red: 159/255, green: 0/255, blue: 0/255, alpha: 1)),
      .BarWidth(30),
      .SliderEnabled(false)
    ]
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.buildCircleSlider()
    self.buildCircleProgress()
  }
  
  private func buildCircleSlider() {
    self.circleSlider = CircleSlider(frame: self.sliderArea.bounds, options: self.sliderOptions)
    self.circleSlider?.addTarget(self, action: Selector("valueChange:"), forControlEvents: .ValueChanged)
    self.sliderArea.addSubview(self.circleSlider!)
    self.valueLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
    self.valueLabel.textAlignment = .Center
    self.valueLabel.center = CGPoint(x: CGRectGetWidth(self.circleSlider.bounds) * 0.5, y: CGRectGetHeight(self.circleSlider.bounds) * 0.5)
    self.circleSlider.addSubview(self.valueLabel)
  }
  
  private func buildCircleProgress() {
    self.circleProgress = CircleSlider(frame: self.sliderArea.bounds, options: self.progressOptions)
    self.circleProgress?.addTarget(self, action: Selector("valueChange:"), forControlEvents: .ValueChanged)
    self.progressArea.addSubview(self.circleProgress!)
    self.progressLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
    self.progressLabel.textAlignment = .Center
    self.progressLabel.center = CGPoint(x: CGRectGetWidth(self.circleProgress.bounds) * 0.5, y: CGRectGetHeight(self.circleProgress.bounds) * 0.5)
    self.circleProgress.addSubview(self.progressLabel)
  }
  
  func valueChange(sender: CircleSlider) {
    switch sender.tag {
    case 0:
      self.valueLabel.text = "\(Int(sender.value))"
    case 1:
      self.progressLabel.text = "\(Int(sender.value))%"
    default:
      break
    }
  }
  
  @IBAction func tapProgress(sender: AnyObject) {
    if self.timer == nil {
      self.progressValue = 0
      self.timer = NSTimer.scheduledTimerWithTimeInterval(0.02, target: self, selector: Selector("fire:"), userInfo: nil, repeats: true)
    }
  }
  
  func fire(timer: NSTimer) {
    self.progressValue += 0.5
    if self.progressValue > 100 {
      self.timer?.invalidate()
      self.timer = nil
      self.progressValue = 0
    }
    self.circleProgress.value = self.progressValue
  }
}


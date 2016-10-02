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
  private var timer: Timer?
  private var progressValue: Float = 0
  private var sliderOptions: [CircleSliderOption] {
    return [
      CircleSliderOption.barColor(UIColor(red: 198/255, green: 244/255, blue: 23/255, alpha: 0.2)),
      CircleSliderOption.thumbColor(UIColor(red: 141/255, green: 185/255, blue: 204/255, alpha: 1)),
      CircleSliderOption.trackingColor(UIColor(red: 78/255, green: 136/255, blue: 185/255, alpha: 1)),
      CircleSliderOption.barWidth(20),
      CircleSliderOption.startAngle(-45),
      CircleSliderOption.maxValue(150),
      CircleSliderOption.minValue(20),
      CircleSliderOption.thumbImage(UIImage(named: "thumb_image")!)
    ]
  }
  private var progressOptions: [CircleSliderOption] {
    return [
      .barColor(UIColor(red: 255/255, green: 190/255, blue: 190/255, alpha: 0.3)),
      .trackingColor(UIColor(red: 159/255, green: 0/255, blue: 0/255, alpha: 1)),
      .barWidth(30),
      .sliderEnabled(false)
    ]
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.buildCircleSlider()
    self.buildCircleProgress()
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    self.circleSlider.frame = self.sliderArea.bounds
    self.circleProgress.frame = self.progressArea.bounds
  }
  
  private func buildCircleSlider() {
    self.circleSlider = CircleSlider(frame: self.sliderArea.bounds, options: self.sliderOptions)
    self.circleSlider?.addTarget(self, action: #selector(valueChange(sender:)), for: .valueChanged)
    self.sliderArea.addSubview(self.circleSlider!)
    self.valueLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
    self.valueLabel.textAlignment = .center
    self.valueLabel.center = CGPoint(x: self.circleSlider.bounds.width * 0.5, y: self.circleSlider.bounds.height * 0.5)
    self.circleSlider.addSubview(self.valueLabel)
  }
  
  private func buildCircleProgress() {
    self.circleProgress = CircleSlider(frame: self.progressArea.bounds, options: self.progressOptions)
    self.circleProgress?.addTarget(self, action: #selector(valueChange(sender:)), for: .valueChanged)
    self.progressArea.addSubview(self.circleProgress!)
    self.progressLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
    self.progressLabel.textAlignment = .center
    self.progressLabel.center = CGPoint(x: self.circleProgress.bounds.width * 0.5, y: self.circleProgress.bounds.height * 0.5)
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
  
  @IBAction func tapProgress(_ sender: AnyObject) {
    if self.timer == nil {
      self.progressValue = 0
      self.timer = Timer.scheduledTimer(timeInterval: 0.02, target: self, selector: #selector(fire(timer:)), userInfo: nil, repeats: true)
    }
  }
  
  func fire(timer: Timer) {
    self.progressValue += 0.5
    if self.progressValue > 100 {
      self.timer?.invalidate()
      self.timer = nil
      self.progressValue = 0
    }
    self.circleProgress.value = self.progressValue
  }
  
  @IBAction func trackingColorChanged(_ sender: AnyObject) {
    let redValue = CGFloat((sender as! UISlider).value)/255
    let newColor = UIColor(red: redValue, green: 136/255, blue: 185/255, alpha: 1)
    self.circleSlider.changeOptions([.trackingColor(newColor)])
  }
  
  @IBAction func barWidthChanged(_ sender: AnyObject) {
    self.circleSlider.changeOptions([.barWidth(CGFloat((sender as! UISlider).value))])
  }
  
  @IBAction func thumbWidthChanged(_ sender: AnyObject) {
    self.circleSlider.changeOptions([.thumbWidth(CGFloat((sender as! UISlider).value))])
  }
    
  @IBAction func viewInsetChanged(_ sender: AnyObject) {
    self.circleSlider.changeOptions([.viewInset(CGFloat((sender as! UISlider).value))])
  }
}


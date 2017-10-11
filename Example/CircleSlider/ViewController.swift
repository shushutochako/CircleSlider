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
  
  private var circleSlider: CircleSlider! {
    didSet {
      self.circleSlider.tag = 0
    }
  }
  private var valueLabel: UILabel!
  private var timer: Timer?
  private var progressValue: Float = 0
    private var minValue: Float = 20
    private var maxValue: Float = 150
  private var sliderOptions: [CircleSliderOption] {
    return [
      CircleSliderOption.barColor(UIColor(red: 127/255, green: 244/255, blue: 23/255, alpha: 1)),
      CircleSliderOption.thumbColor(UIColor(red: 127/255, green: 185/255, blue: 204/255, alpha: 1)),
      CircleSliderOption.trackingColor(UIColor(red: 78/255, green: 136/255, blue: 185/255, alpha: 1)),
      CircleSliderOption.barWidth(20),
      CircleSliderOption.startAngle(0),
      CircleSliderOption.maxValue(self.maxValue),
      CircleSliderOption.minValue(self.minValue),
      CircleSliderOption.thumbImage(UIImage(named: "thumb_image_1")!)
    ]
  }
  private var progressOptions: [CircleSliderOption] {
    return [
      .barColor(UIColor(red: 255/255, green: 190/255, blue: 190/255, alpha: 1)),
      .trackingColor(UIColor(red: 159/255, green: 0/255, blue: 0/255, alpha: 1)),
      .barWidth(30),
      .sliderEnabled(false)
    ]
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.buildCircleSlider()
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    
    self.circleSlider.frame = self.sliderArea.bounds
    self.valueLabel.center = CGPoint(x: self.circleSlider.bounds.width * 0.5, y: self.circleSlider.bounds.height * 0.5)
    self.circleSlider.value = 50
  }
  
  private func buildCircleSlider() {
    self.circleSlider = CircleSlider(frame: self.sliderArea.bounds, options: self.sliderOptions)
    self.circleSlider?.addTarget(self, action: #selector(valueChange(sender:)), for: .valueChanged)
    self.sliderArea.addSubview(self.circleSlider!)
    self.valueLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
    self.valueLabel.textAlignment = .center
    self.circleSlider.addSubview(self.valueLabel)
  }
    
    @objc func valueChange(sender: CircleSlider) {
    switch sender.tag {
    case 0:
      self.valueLabel.text = "\(Int(sender.value))"
    default:
      break
    }
  }
  
  @IBAction func tapProgress(_ sender: AnyObject) {
    if self.timer == nil {
      self.progressValue = self.minValue
      self.timer = Timer.scheduledTimer(timeInterval: 0.02, target: self, selector: #selector(fire(timer:)), userInfo: nil, repeats: true)
    }
  }
  
    @objc func fire(timer: Timer) {
    self.progressValue += 0.5
    if self.progressValue > self.maxValue {
      self.timer?.invalidate()
      self.timer = nil
      self.progressValue = self.minValue
    }
    self.circleSlider.value = self.progressValue
  }
    
    @IBAction func enableSwitchChanged(_ sender: Any) {
        let lastValue = self.circleSlider.value
        self.circleSlider.changeOptions([.sliderEnabled((sender as! UISwitch).isOn)])
        self.circleSlider.value = lastValue
    }
  
  @IBAction func trackingColorChanged(_ sender: AnyObject) {
    let redValue = CGFloat((sender as! UISlider).value)/255
    let newColor = UIColor(red: redValue, green: 136/255, blue: 185/255, alpha: 1)
    let lastValue = self.circleSlider.value
    self.circleSlider.changeOptions([.trackingColor(newColor)])
    self.circleSlider.value = lastValue
  }
  
    @IBAction func barColorChanged(_ sender: Any) {
    let redValue = CGFloat((sender as! UISlider).value)/255
    let newColor = UIColor(red: redValue, green: 244/255, blue: 23/255, alpha: 1)
    let lastValue = self.circleSlider.value
    self.circleSlider.changeOptions([.barColor(newColor)])
    self.circleSlider.value = lastValue
    }
    
    @IBAction func thumbColorChanged(_ sender: Any) {
        let redValue = CGFloat((sender as! UISlider).value)/255
        let newColor = UIColor(red: redValue, green: 185/255, blue: 204/255, alpha: 1)
        let lastValue = self.circleSlider.value
        self.circleSlider.changeOptions([.thumbColor(newColor)])
        self.circleSlider.value = lastValue
    }
    
  @IBAction func barWidthChanged(_ sender: AnyObject) {
    let lastValue = self.circleSlider.value
    self.circleSlider.changeOptions([.barWidth(CGFloat((sender as! UISlider).value))])
    self.circleSlider.value = lastValue
  }
  
  @IBAction func thumbWidthChanged(_ sender: AnyObject) {
    let lastValue = self.circleSlider.value
    self.circleSlider.changeOptions([.thumbWidth(CGFloat((sender as! UISlider).value))])
    self.circleSlider.value = lastValue
  }
    
  @IBAction func viewInsetChanged(_ sender: AnyObject) {
    let lastValue = self.circleSlider.value
    self.circleSlider.changeOptions([.viewInset(CGFloat((sender as! UISlider).value))])
    self.circleSlider.value = lastValue
  }
    
    @IBAction func startAngle(_ sender: Any) {
        let lastValue = self.circleSlider.value
        self.circleSlider.changeOptions([.startAngle(Double((sender as! UISlider).value))])
        self.circleSlider.value = lastValue
    }

    
    @IBAction func thumbImage1BtnTapped(_ sender: Any) {
        let lastValue = self.circleSlider.value
        self.circleSlider.changeOptions([.thumbImage(UIImage(named:"thumb_image_1")!)])
        self.circleSlider.value = lastValue
    }
    
    @IBAction func thumbImage2BtnTapped(_ sender: Any) {
        let lastValue = self.circleSlider.value
        self.circleSlider.changeOptions([.thumbImage(UIImage(named:"thumb_image_2")!)])
        self.circleSlider.value = lastValue
    }
    
    @IBAction func thumbImage3BtnTapped(_ sender: Any) {
        let lastValue = self.circleSlider.value
        self.circleSlider.changeOptions([.thumbImage(UIImage(named:"thumb_image_3")!)])
        self.circleSlider.value = lastValue
    }
    
    @IBAction func thumbNoImageBtnTapped(_ sender: Any) {
        let lastValue = self.circleSlider.value
        self.circleSlider.changeOptions([.thumbImage(nil)])
        self.circleSlider.value = lastValue
    }
    
}


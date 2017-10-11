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
            CircleSliderOption.barColor(UIColor(red: 127 / 255, green: 244 / 255, blue: 23 / 255, alpha: 1)),
            CircleSliderOption.thumbColor(UIColor(red: 127 / 255, green: 185 / 255, blue: 204 / 255, alpha: 1)),
            CircleSliderOption.trackingColor(UIColor(red: 78 / 255, green: 136 / 255, blue: 185 / 255, alpha: 1)),
            CircleSliderOption.barWidth(20),
            CircleSliderOption.startAngle(0),
            CircleSliderOption.maxValue(self.maxValue),
            CircleSliderOption.minValue(self.minValue),
            CircleSliderOption.thumbImage(UIImage(named: "thumb_image_1")!)
        ]
    }
    private var progressOptions: [CircleSliderOption] {
        return [
            .barColor(UIColor(red: 255 / 255, green: 190 / 255, blue: 190 / 255, alpha: 1)),
            .trackingColor(UIColor(red: 159 / 255, green: 0 / 255, blue: 0 / 255, alpha: 1)),
            .barWidth(30),
            .sliderEnabled(false)
        ]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buildCircleSlider()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        circleSlider.frame = sliderArea.bounds
        valueLabel.center = CGPoint(x: circleSlider.bounds.width * 0.5, y: circleSlider.bounds.height * 0.5)
        circleSlider.value = 50
    }
    
    private func buildCircleSlider() {
        circleSlider = CircleSlider(frame: sliderArea.bounds, options: sliderOptions)
        circleSlider?.addTarget(self, action: #selector(valueChange(sender:)), for: .valueChanged)
        sliderArea.addSubview(circleSlider!)
        valueLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        valueLabel.textAlignment = .center
        circleSlider.addSubview(valueLabel)
    }
    
    @objc func valueChange(sender: CircleSlider) {
        switch sender.tag {
        case 0:
            valueLabel.text = "\(Int(sender.value))"
        default:
            break
        }
    }
    
    @IBAction func tapProgress(_: AnyObject) {
        if timer == nil {
            progressValue = minValue
            timer = Timer.scheduledTimer(timeInterval: 0.02, target: self, selector: #selector(fire(timer:)), userInfo: nil, repeats: true)
        }
    }
    
    @objc func fire(timer _: Timer) {
        progressValue += 0.5
        if progressValue > maxValue {
            timer?.invalidate()
            timer = nil
            progressValue = minValue
        }
        circleSlider.value = progressValue
    }
    
    @IBAction func enableSwitchChanged(_ sender: Any) {
        let lastValue = circleSlider.value
        circleSlider.changeOptions([.sliderEnabled((sender as! UISwitch).isOn)])
        circleSlider.value = lastValue
    }
    
    @IBAction func trackingColorChanged(_ sender: AnyObject) {
        let redValue = CGFloat((sender as! UISlider).value) / 255
        let newColor = UIColor(red: redValue, green: 136 / 255, blue: 185 / 255, alpha: 1)
        let lastValue = circleSlider.value
        circleSlider.changeOptions([.trackingColor(newColor)])
        circleSlider.value = lastValue
    }
    
    @IBAction func barColorChanged(_ sender: Any) {
        let redValue = CGFloat((sender as! UISlider).value) / 255
        let newColor = UIColor(red: redValue, green: 244 / 255, blue: 23 / 255, alpha: 1)
        let lastValue = circleSlider.value
        circleSlider.changeOptions([.barColor(newColor)])
        circleSlider.value = lastValue
    }
    
    @IBAction func thumbColorChanged(_ sender: Any) {
        let redValue = CGFloat((sender as! UISlider).value) / 255
        let newColor = UIColor(red: redValue, green: 185 / 255, blue: 204 / 255, alpha: 1)
        let lastValue = circleSlider.value
        circleSlider.changeOptions([.thumbColor(newColor)])
        circleSlider.value = lastValue
    }
    
    @IBAction func barWidthChanged(_ sender: AnyObject) {
        let lastValue = circleSlider.value
        circleSlider.changeOptions([.barWidth(CGFloat((sender as! UISlider).value))])
        circleSlider.value = lastValue
    }
    
    @IBAction func thumbWidthChanged(_ sender: AnyObject) {
        let lastValue = circleSlider.value
        circleSlider.changeOptions([.thumbWidth(CGFloat((sender as! UISlider).value))])
        circleSlider.value = lastValue
    }
    
    @IBAction func viewInsetChanged(_ sender: AnyObject) {
        let lastValue = circleSlider.value
        circleSlider.changeOptions([.viewInset(CGFloat((sender as! UISlider).value))])
        circleSlider.value = lastValue
    }
    
    @IBAction func startAngle(_ sender: Any) {
        let lastValue = circleSlider.value
        circleSlider.changeOptions([.startAngle(Double((sender as! UISlider).value))])
        circleSlider.value = lastValue
    }
    
    @IBAction func thumbImage1BtnTapped(_: Any) {
        let lastValue = circleSlider.value
        circleSlider.changeOptions([.thumbImage(UIImage(named: "thumb_image_1")!)])
        circleSlider.value = lastValue
    }
    
    @IBAction func thumbImage2BtnTapped(_: Any) {
        let lastValue = circleSlider.value
        circleSlider.changeOptions([.thumbImage(UIImage(named: "thumb_image_2")!)])
        circleSlider.value = lastValue
    }
    
    @IBAction func thumbImage3BtnTapped(_: Any) {
        let lastValue = circleSlider.value
        circleSlider.changeOptions([.thumbImage(UIImage(named: "thumb_image_3")!)])
        circleSlider.value = lastValue
    }
    
    @IBAction func thumbNoImageBtnTapped(_: Any) {
        let lastValue = circleSlider.value
        circleSlider.changeOptions([.thumbImage(nil)])
        circleSlider.value = lastValue
    }
    
}

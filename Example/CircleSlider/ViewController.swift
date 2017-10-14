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
    @IBOutlet weak var tapProgressButton: UIButton!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var delegateLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    
    private var circleSlider: CircleSlider!
    private var timer: Timer?
    private var minValue: Float = 20
    private var maxValue: Float = 100
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
    }
    
    private func buildCircleSlider() {
        circleSlider = CircleSlider(frame: sliderArea.bounds, options: sliderOptions)
        circleSlider?.addTarget(self, action: #selector(valueChange(sender:)), for: .valueChanged)
        sliderArea.addSubview(circleSlider!)
        circleSlider.delegate = self
    }
    
    @objc func valueChange(sender: CircleSlider) {
        valueLabel.text = "\(Int(sender.value))"
        changeButtonImage(circleSlider.status)
    }
    
    @IBAction func tapProgress(_: AnyObject) {
        
        switch circleSlider.status {
            
        case CircleSliderStatus.noChangeMinValue:
            timer = Timer.scheduledTimer(timeInterval: 0.02, target: self, selector: #selector(fire(timer:)), userInfo: nil, repeats: true)
            
        case CircleSliderStatus.reachedMaxValue:
            tapProgressButton.setImage(UIImage(named: "button_start"), for: UIControlState.normal)
            circleSlider.value = minValue
            timer = Timer.scheduledTimer(timeInterval: 0.02, target: self, selector: #selector(fire(timer:)), userInfo: nil, repeats: true)
            
        case CircleSliderStatus.inProgressChangeValue:
            if (timer?.isValid)! {
                tapProgressButton.setImage(UIImage(named: "button_start"), for: UIControlState.normal)
                timer?.invalidate()
            } else {
                tapProgressButton.setImage(UIImage(named: "button_stop"), for: UIControlState.normal)
                timer = Timer.scheduledTimer(timeInterval: 0.02, target: self, selector: #selector(fire(timer:)), userInfo: nil, repeats: true)
            }
        }
    }
    
    @objc func fire(timer _: Timer) {
        circleSlider.value += 0.5
        changeButtonImage(circleSlider.status)
    }
    
    private func changeButtonImage(_ status: CircleSliderStatus) {
        switch status {
        case CircleSliderStatus.noChangeMinValue:
            tapProgressButton.setImage(UIImage(named: "button_start"), for: UIControlState.normal)
            statusLabel.text = "noChangeMinValue"
            
        case CircleSliderStatus.inProgressChangeValue:
            tapProgressButton.setImage(UIImage(named: "button_stop"), for: UIControlState.normal)
            statusLabel.text = "inProgressChangeValue"
            
        case CircleSliderStatus.reachedMaxValue:
            tapProgressButton.setImage(UIImage(named: "button_end"), for: UIControlState.normal)
            statusLabel.text = "reachedMaxValue"
            timer?.invalidate()
            timer = nil
        }
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
    
    @IBAction func thumbPositionChanged(_ sender: Any) {
        let lastValue = circleSlider.value
        circleSlider.changeOptions([.thumbPosition(Float((sender as! UISlider).value))])
        circleSlider.value = lastValue
    }
}

extension ViewController: CircleSliderDelegate {
    func didStartChangeValue() {
        delegateLabel.text = "didStartChangeValue"
    }
    
    func didReachedMaxValue() {
        delegateLabel.text = "didReachedMaxValue"
    }
    
}

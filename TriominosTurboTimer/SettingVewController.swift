//
//  SettingVewController.swift
//  TriominosTurboTimer
//
//  Created by Minh on 25.11.15.
//  Copyright © 2015 NAT. All rights reserved.
//

import UIKit

class SettingViewController : UIViewController, UITextFieldDelegate {
    @IBOutlet weak var timerTextField: UITextField!
    @IBOutlet weak var ticktackSwitch: UISwitch!
    @IBOutlet weak var dingSwitch: UISwitch!
    @IBOutlet weak var vibrateSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        timerTextField.delegate = self
        if (timerDuration > 0) {
            timerTextField.text = String(stringInterpolationSegment: timerDuration)
        } else {
            timerTextField.text = String(stringInterpolationSegment: defaultTimerDuration)
        }
        
        ticktackSwitch.on = tickTackSoundOn
        dingSwitch.on = dingSoundOn
        vibrateSwitch.on = vibrateOn
    }
    
    override func viewDidDisappear(animated: Bool) {
        SettingViewController.saveSetting()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func tickTackSettingChanged(sender: UISwitch) {
        tickTackSoundOn = sender.on
    }
    
    @IBAction func dingSettingChanged(sender: UISwitch) {
        dingSoundOn = sender.on
    }
    
    @IBAction func vibrateSettingChanged(sender: UISwitch) {
        vibrateOn = sender.on
    }
    
    @IBAction func timerSettingChanged(sender: UITextField) {
        if ((sender.text) != nil && Int(sender.text!) != nil) {
            let inputTimer = Int(sender.text!)!
                if (inputTimer > 0) {
                    timerDuration = inputTimer
                }
        } else {
            sender.text = String(stringInterpolationSegment: defaultTimerDuration)
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        timerTextField.resignFirstResponder()
        return true;
    }
    
    class func saveSetting() {
        let defaults = NSUserDefaults.standardUserDefaults()
        
        defaults.setInteger(timerDuration, forKey: settingKeys.duration)
        defaults.setBool(tickTackSoundOn, forKey: settingKeys.ticktack)
        defaults.setBool(dingSoundOn, forKey: settingKeys.ding)
        defaults.setBool(vibrateOn, forKey: settingKeys.vibrate)
        
        defaults.synchronize()
    }
}

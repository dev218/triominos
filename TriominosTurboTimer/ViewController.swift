//
//  ViewController.swift
//  TriominosTurboTimer
//
//  Created by Minh on 25.11.15.
//  Copyright © 2015 NAT. All rights reserved.
//

import UIKit
import AudioToolbox
import AVFoundation

var timerDuration = 0
var tickTackSoundOn = true
var dingSoundOn = true
var vibrateOn = true
let defaultTimerDuration = 16

enum settingKeys {
    static let duration = "duration"
    static let ticktack = "ticktack"
    static let ding = "ding"
    static let vibrate = "vibrate"
}

class ViewController: UIViewController {
    @IBOutlet weak var timerButton: UIButton!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var settingLabel: UILabel!
    
    
    var timer: NSTimer?
    var currentTimeLeft: Int = 0
    var audioPlayer: AVAudioPlayer?
    var sandClockRunningImages: [UIImage] = []
    var sandClockTurningImages: [UIImage] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        loadSetting()
        timerLabel.text = ""
        settingTimer()
//        initAnimation()
        initAnimationImages()
    }
    
    override func viewDidAppear(animated: Bool) {
        settingTimer()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onClick(sender: UIButton) {
        timerLabel.text = String(stringInterpolationSegment: timerDuration)
//        if (currentTimeLeft==0) {
//            // turn the sand clock upside down
//            timerButton.imageView!.stopAnimating()
//            timerButton.imageView!.image = sandClockTurningImages[10]
//            timerButton.imageView!.animationImages = sandClockTurningImages
//            timerButton.imageView!.animationDuration = 0.6
//            timerButton.imageView!.startAnimating()
//        }
            currentTimeLeft = timerDuration
            if (timer != nil) {
                timer?.invalidate()
            }
            timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "updateLabel", userInfo: nil, repeats: true)
            if (audioPlayer != nil) {
                audioPlayer?.stop()
            }
            if (tickTackSoundOn) {
                playSound("clock-ticking-2", numberOfLoops: -1)
            }
            animateSandClock(timerDuration)
        
    }
    
    func settingTimer() {
        if (timerDuration == 0) {
            timerDuration = defaultTimerDuration
        }
        settingLabel.text = String(stringInterpolationSegment: timerDuration) + "s"

    }
    
    func updateLabel() {
        currentTimeLeft--
        timerLabel.text = String(stringInterpolationSegment: currentTimeLeft)
        if (currentTimeLeft <= 0) {
            if (vibrateOn) {
                AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))                
            }
            timer?.invalidate()
            if (audioPlayer != nil) {
                audioPlayer?.stop()
            }
            if (dingSoundOn) {
                playSound("ding", numberOfLoops: 0)
            }
        }
    }
    
    func playSound(soundName: String, numberOfLoops: Int)
    {
        let sound = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource(soundName, ofType: "wav")!)
        do{
            audioPlayer = try AVAudioPlayer(contentsOfURL:sound)
            audioPlayer!.numberOfLoops = numberOfLoops
            audioPlayer!.prepareToPlay()
            audioPlayer!.play()
        }catch {
            print("Error getting the audio file")
        }
    }
    
    func loadSetting() {
        let defaults = NSUserDefaults.standardUserDefaults()
        
        if (!defaults.boolForKey("HasLaunchedOnce")) {
            defaults.setBool(true, forKey: "HasLaunchedOnce")
            NSUserDefaults.standardUserDefaults().synchronize()
            
            timerDuration = defaultTimerDuration
            tickTackSoundOn = true
            dingSoundOn = true
            vibrateOn = false
        } else {
            timerDuration = defaults.integerForKey(settingKeys.duration)
//            if (timerDuration == 0) {
//                timerDuration = defaultTimerDuration
//            }
            tickTackSoundOn = defaults.boolForKey(settingKeys.ticktack)
            dingSoundOn = defaults.boolForKey(settingKeys.ding)
            vibrateOn = defaults.boolForKey(settingKeys.vibrate)
        }
        
        
    }
    
    func animateSandClock(duration: Int) {
        timerButton.imageView!.stopAnimating()
        timerButton.imageView!.animationImages = sandClockRunningImages
        timerButton.imageView!.animationDuration = Double(duration)
        timerButton.imageView!.startAnimating()
    }
    
    func initAnimation() {
        var images: [UIImage] = []
        for i in 1...7 {
            images.append(UIImage(named: "sc\(i)")!)
        }
        timerButton.imageView!.animationImages = images
        timerButton.imageView!.animationRepeatCount = 1
    }
    
    func initAnimationImages() {
        for i in 1...7 {
            sandClockRunningImages.append(UIImage(named: "sc\(i)")!)
        }
//        for i in 1...11 {
//            sandClockTurningImages.append(UIImage(named: "scr\(i)")!)
//        }
        timerButton.imageView!.animationRepeatCount = 1
    }
    
}


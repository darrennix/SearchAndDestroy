import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    var startTime = NSTimeInterval()
    var timer = NSTimer()
    var countdownTime: Double = 0.0

    var startTimeDetonator = NSTimeInterval()
    var timerDetonator = NSTimer()
    var countdownTimeDetonator: Double = 0.0

    var appState = "armable" // armable, arming, disarming, detonating

    let synthesizer = AVSpeechSynthesizer()
    var countdownPlayer = AVAudioPlayer()


    @IBOutlet weak var displayTimeLabel: UILabel!
    @IBOutlet weak var displayTimeDetonatorLabel: UILabel!
    @IBOutlet weak var armButton: UIButton!
    @IBOutlet weak var disarmButton: UIButton!
    
    @IBAction func armTouchDown(sender: AnyObject) {
        appState = "arming"
        startCountdown(Settings.secondsToArm)
        
        let utterance = AVSpeechUtterance(string: "\(Settings.locationName) arming")
        utterance.rate = AVSpeechUtteranceMinimumSpeechRate; // some Configs :-)
        synthesizer.speakUtterance(utterance)
    }
    @IBAction func armTouchUpInside(sender: AnyObject) {
        if timer.valid {
            // Timer is still running
            timer.invalidate()
            displayTimeLabel.text = "--:--"
        }
    }
    
    @IBAction func disarmTouchDown(sender: AnyObject) {
        appState = "disarming"
        startCountdown(Settings.secondsToDisarm)
        
        let utterance = AVSpeechUtterance(string: "\(Settings.locationName) disarming")
        utterance.rate = AVSpeechUtteranceMinimumSpeechRate; // some Configs :-)
        synthesizer.speakUtterance(utterance)

    }
    @IBAction func disarmTouchUpInside(sender: AnyObject) {
        if timer.valid {
            // Timer is still running
            timer.invalidate()
            displayTimeLabel.text = "--:--"
        }
    }
    func arm() {
        appState = "detonating"
        disarmButton.hidden = false
        armButton.hidden = true
        displayTimeLabel.text = "--:--"

        countdownTimeDetonator = Double(Settings.secondsToDetonate)
        let aSelector : Selector = "updateTimeDetonator"
        timerDetonator = NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: aSelector, userInfo: nil, repeats: true)
        startTimeDetonator = NSDate.timeIntervalSinceReferenceDate()
        
        let utterance = AVSpeechUtterance(string: "\(Settings.locationName) armed.")
        let synthesizer = AVSpeechSynthesizer()
        utterance.rate = AVSpeechUtteranceMinimumSpeechRate; // some Configs :-)
        synthesizer.speakUtterance(utterance)

    }
    
    func disarm() {
        displayTimeLabel.text = "--:--"
        displayTimeDetonatorLabel.text = "--:--"

        appState = "initializing"
        timerDetonator.invalidate()
        disarmButton.hidden = true
        armButton.hidden = false
        
        let utterance = AVSpeechUtterance(string: "\(Settings.locationName) disarmed. ")
        utterance.rate = AVSpeechUtteranceMinimumSpeechRate; // some Configs :-)
        synthesizer.speakUtterance(utterance)

        countdownPlayer.pause()
        countdownPlayer.currentTime = 0;
    }
    
    func detonate() {
        displayTimeLabel.text = "Boom"
        disarmButton.hidden = true
        armButton.hidden = true

//        let utterance = AVSpeechUtterance(string: "\(Settings.locationName) has detonated.  Game Over. ")
//        utterance.rate = AVSpeechUtteranceMinimumSpeechRate; // some Configs :-)
//        synthesizer.speakUtterance(utterance)
        
    }
    
    func startCountdown(seconds: Int) {
        countdownTime = Double(seconds)
        let aSelector : Selector = "updateTime"
        timer = NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: aSelector, userInfo: nil, repeats: true)
        startTime = NSDate.timeIntervalSinceReferenceDate()
    }

    func updateTime() {
        var elapsedTime: NSTimeInterval = NSDate.timeIntervalSinceReferenceDate() - startTime

        if (elapsedTime >= countdownTime) {
            timer.invalidate()
            if appState == "arming" {
                arm()
            } else if appState == "disarming" {
                disarm()
            } else if appState == "detonating" {
                detonate()
            }
        } else {
            var timeRemaining: NSTimeInterval = countdownTime - elapsedTime
            
            //calculate the seconds in elapsed time.
            let seconds = UInt8(timeRemaining)
            timeRemaining -= NSTimeInterval(seconds)
            
            //find out the fraction of milliseconds to be displayed.
            let fraction = UInt8(timeRemaining * 100)
            
            //add the leading zero for minutes, seconds and millseconds and store them as string constants
            let strSeconds = seconds > 9 ? String(seconds):"0" + String(seconds)
            let strFraction = fraction > 9 ? String(fraction):"0" + String(fraction)
            
            //concatenate seconds and milliseconds as assign it to the UILabel
            displayTimeLabel.text = "\(strSeconds):\(strFraction)"
        }
    }

    func updateTimeDetonator() {
        var elapsedTime: NSTimeInterval = NSDate.timeIntervalSinceReferenceDate() - startTimeDetonator
        if (elapsedTime >= countdownTimeDetonator) {
            timerDetonator.invalidate()
            detonate()
        } else {
            var timeRemaining: NSTimeInterval = countdownTimeDetonator - elapsedTime
            
            //calculate the seconds in elapsed time.
            let seconds = UInt8(timeRemaining)
            timeRemaining -= NSTimeInterval(seconds)
            
            //find out the fraction of milliseconds to be displayed.
            let fraction = UInt8(timeRemaining * 100)
            
            //add the leading zero for minutes, seconds and millseconds and store them as string constants
            let strSeconds = seconds > 9 ? String(seconds):"0" + String(seconds)
            let strFraction = fraction > 9 ? String(fraction):"0" + String(fraction)
            
            //concatenate seconds and milliseconds as assign it to the UILabel
            displayTimeDetonatorLabel.text = "\(strSeconds):\(strFraction)"
        
        
            // Clip takes 28 seconds to play explosion
            if (seconds < 28 && countdownPlayer.playing == false) {
                countdownPlayer.play()
            }
        }
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        displayTimeLabel.text = "--:--"
        displayTimeDetonatorLabel.text = "--:--"
        disarmButton.hidden = true
        
        let path = NSBundle.mainBundle().pathForResource("20-sec-countdown", ofType:"mp3")
        let fileURL = NSURL(fileURLWithPath: path!)
        countdownPlayer = AVAudioPlayer(contentsOfURL: fileURL, error: nil)
        countdownPlayer.prepareToPlay()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


import UIKit

class ViewController: UIViewController {
    
    var startTime = NSTimeInterval()
    var timer = NSTimer()
    var countdownTime: Double = 0.0
    var appState = "armable" // armable, arming, disarming, detonating
    
    @IBOutlet weak var displayTimeLabel: UILabel!
    @IBOutlet weak var armButton: UIButton!
    @IBOutlet weak var disarmButton: UIButton!
    
    @IBAction func armTouchDown(sender: AnyObject) {
        appState = "arming"
        startCountdown(Settings.secondsToArm)
    }
    @IBAction func armTouchUpInside(sender: AnyObject) {
        if timer.valid {
            // Timer is still running
            timer.invalidate()
            displayTimeLabel.text = "Fail"
        }
    }
    
    @IBAction func disarmTouchDown(sender: AnyObject) {
        appState = "disarming"
        startCountdown(Settings.secondsToDisarm)
    }
    @IBAction func disarmTouchUpInside(sender: AnyObject) {
        if timer.valid {
            // Timer is still running
            timer.invalidate()
            displayTimeLabel.text = "Fail"
        }
    }
    func arm() {
        appState = "detonating"
        startCountdown(Settings.secondsToDetonate)
        disarmButton.hidden = false
        armButton.hidden = true
    }
    
    func disarm() {
        appState = "initializing"
        disarmButton.hidden = true
        armButton.hidden = false
    }
    
    func detonate() {
        displayTimeLabel.text = "Boom"
        disarmButton.hidden = true
        armButton.hidden = true
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

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        displayTimeLabel.text = "--:--"
        disarmButton.hidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


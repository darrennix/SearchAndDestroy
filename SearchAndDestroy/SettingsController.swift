import UIKit

class SettingsController: UIViewController {
    
    
    @IBOutlet weak var secondsToArm: UITextField!
    @IBOutlet weak var secondsToDisarm: UITextField!
    @IBOutlet weak var secondsToDetonate: UITextField!
    @IBOutlet weak var locationName: UITextField!
    
    @IBAction func saveSettings(sender: AnyObject) {
        let secondsToArmInt:Int? = secondsToArm.text.toInt()
        let secondsToDisarmInt:Int? = secondsToDisarm.text.toInt()
        let secondsToDetonateInt:Int? = secondsToDetonate.text.toInt()
        
        if secondsToArmInt != nil {
            Settings.secondsToArm = secondsToArmInt!
        }
        if secondsToDisarmInt != nil {
            Settings.secondsToDisarm = secondsToDisarmInt!
        }
        if secondsToDetonateInt != nil {
            Settings.secondsToDetonate = secondsToDetonateInt!
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        secondsToArm.text = String(Settings.secondsToArm)
        secondsToDisarm.text = String(Settings.secondsToDisarm)
        secondsToDetonate.text = String(Settings.secondsToDetonate)
        locationName.text = Settings.locationName
 
//        super.viewDidLoad()
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: "handleSingleTap:")
        tapRecognizer.numberOfTapsRequired = 1
        self.view.addGestureRecognizer(tapRecognizer)
    }

    func handleSingleTap(recognizer: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }


    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}


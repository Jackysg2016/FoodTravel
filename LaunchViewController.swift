//
//  LaunchViewController.swift
//  FoodTravel
//
//  Created by angelorlover on 16/4/7.
//  Copyright © 2016年 angelorlover. All rights reserved.
//

import UIKit

class LaunchViewController: UIViewController {
    
    @IBOutlet var imageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        splash()
        
//        NSTimer.scheduledTimerWithTimeInterval(0.0, target: self, selector: #selector(LaunchViewController.splash), userInfo: nil, repeats: false)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func splash() {
        self.imageView.alpha = 0.0
        self.imageView.layer.transform = CATransform3DScale(CATransform3DIdentity, 2.0, 2.0, 1.0)
        UIView.animateWithDuration(1.5, delay: 0.0, options: .BeginFromCurrentState, animations: {
            self.imageView.alpha = 1.0
            self.imageView.layer.transform = CATransform3DIdentity
            }, completion: { (Bool) -> Void in
                self.performSegueWithIdentifier("showHome", sender: nil)
        })
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

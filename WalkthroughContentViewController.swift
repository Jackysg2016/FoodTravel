//
//  WalkthroughContentViewController.swift
//  FoodPin
//
//  Created by angelorlover on 16/3/16.
//  Copyright © 2016年 angelorlover. All rights reserved.
//

import UIKit

class WalkthroughContentViewController: UIViewController {
    
    @IBOutlet var headingLabel:UILabel!
    @IBOutlet var contentLabel:UILabel!
    @IBOutlet var contentImageView:UIImageView!
    @IBOutlet var pageControl: UIPageControl!
    @IBOutlet var forwardButton:UIButton!
    
    var index = 0
    var heading = ""
    var imageFile = ""
    var content = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        headingLabel.text = heading
        contentLabel.text = content
        contentImageView.image = UIImage(named: imageFile)
        pageControl.currentPage = index
        
        if case 0...1 = index {
            forwardButton.setTitle("下页", forState: .Normal)
        } else if case 2 = index {
            forwardButton.setTitle("进入应用", forState: .Normal)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func nextButtonTapped(sender: UIButton) {
        
        switch index {
        
        case 0...1:
                let pageViewController = parentViewController as! WalkthroughPageViewController
                pageViewController.forward(index)
            
        case 2:
            if let homeViewController = storyboard?.instantiateViewControllerWithIdentifier("Home") as? UITabBarController {
                presentViewController(homeViewController, animated: false, completion: nil)
            }
        default: break
            
        }
        
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

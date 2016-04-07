//
//  ReviewViewController.swift
//  FoodPin
//
//  Created by angelorlover on 16/3/11.
//  Copyright © 2016年 angelorlover. All rights reserved.
//

import UIKit

class ReviewViewController: UIViewController {
    
    var rating: String?
    
    @IBOutlet var backgroundImageView: UIImageView!
    @IBOutlet var dislikeButton: UIButton!
    @IBOutlet var goodButton: UIButton!
    @IBOutlet var greatButton: UIButton!
    @IBAction func chooseRating(sender: UIButton) {
        switch (sender.tag) {
            case 100: rating = "dislike"
            case 200: rating = "good"
            case 300: rating = "great"
            default: break
        }
        performSegueWithIdentifier("unwindToDetailView", sender: sender)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //毛玻璃效果
        let blurEffect = UIBlurEffect(style: .Dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        backgroundImageView.addSubview(blurEffectView)
        
        //设置动画效果
        let scale = CGAffineTransformMakeScale(0.0, 0.0)
        let translate = CGAffineTransformMakeTranslation(0, 400)
        dislikeButton.transform = CGAffineTransformConcat(scale, translate)
        goodButton.transform = CGAffineTransformConcat(scale, translate)
        greatButton.transform = CGAffineTransformConcat(scale, translate)
        
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {

        UIView.animateWithDuration(0.5, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.2, options: [], animations: {
            self.dislikeButton.transform = CGAffineTransformIdentity
            }, completion: nil)
        UIView.animateWithDuration(0.5, delay: 0.2, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.2, options: [], animations: {
            self.goodButton.transform = CGAffineTransformIdentity
            }, completion: nil)
        UIView.animateWithDuration(0.5, delay: 0.4, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.2, options: [], animations: {
            self.greatButton.transform = CGAffineTransformIdentity
            }, completion: nil)


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

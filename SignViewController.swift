//
//  SignViewController.swift
//  FoodPin
//
//  Created by angelorlover on 16/3/22.
//  Copyright © 2016年 angelorlover. All rights reserved.
//

import UIKit
import AVOSCloud

class SignViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var userTextField : UITextField!
    @IBOutlet var passwordTextField : UITextField!
    @IBOutlet var loginButton : UIButton!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var userView: UIView!
    private var account : Account?
    var blurEffectiveView: UIVisualEffectView?

    override func viewDidLoad() {
        super.viewDidLoad()
        userTextField.delegate = self
        passwordTextField.delegate = self
        passwordTextField.secureTextEntry = true
        
        //增加毛玻璃特效
        blurEffectiveView = UIVisualEffectView(effect: UIBlurEffect(style: .Dark))
        blurEffectiveView?.frame = imageView.bounds
        imageView.addSubview(blurEffectiveView!)
        
//        NSTimer.scheduledTimerWithTimeInterval(6.0, target: self, selector: #selector(LaunchViewController.splash), userInfo: nil, repeats: true)
        
        // Do any additional setup after loading the view.
        
//        //监听textfield状态,添加观察者和发送通知顺序不能颠倒
//        NSNotificationCenter.defaultCenter().postNotificationName(UITextFieldTextDidBeginEditingNotification, object: userTextField)
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: "moveView:", name: UITextFieldTextDidBeginEditingNotification, object: userTextField)
    }
    
    func splash() {
        self.imageView.layer.transform = CATransform3DScale(CATransform3DIdentity, 2.0, 2.0, 1.0)
        UIView.animateWithDuration(3.0, animations: {
            self.imageView.layer.transform = CATransform3DIdentity
        })
    }
    
    //屏幕方向改变时同步改变毛玻璃特效frame
    override func traitCollectionDidChange(previousTraitCollection: UITraitCollection?) {
        blurEffectiveView?.frame = view.bounds
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //切换textField
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if (textField == userTextField) {
            passwordTextField.becomeFirstResponder()
        } else {
            passwordTextField.resignFirstResponder()
        }
        return true
    }
    
    //textField动画效果
    func textFieldDidBeginEditing(textField: UITextField) {
        userTextField.returnKeyType = .Next
        passwordTextField.returnKeyType = .Join
//        UIView.animateWithDuration(0.2, animations: { self.userView.transform = CGAffineTransformMakeTranslation(0, -50) }, completion: nil)
        UIView.animateWithDuration(0.2, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.5, options: .TransitionNone, animations: {
                self.userView.transform = CGAffineTransformMakeTranslation(0, -50)
            }, completion: nil)
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
//        UIView.animateWithDuration(0.2, animations: { self.userView.transform = CGAffineTransformMakeTranslation(0, 0) }, completion: nil)
        UIView.animateWithDuration(0.2, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.5, options: .TransitionNone, animations: {
            self.userView.transform = CGAffineTransformMakeTranslation(0, 0)
            }, completion: nil)
    }
    
    //点击键盘以外区域撤销键盘
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        userTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }
    
    //激活textfield时上移
//    func moveView(sender: NSNotification) {
//        userView.transform = CGAffineTransformMakeTranslation(0, 0)
//        UIView.animateWithDuration(0.2, delay: 0.0, usingSpringWithDamping: 0.15, initialSpringVelocity: 0.5, options: .CurveEaseInOut, animations: {
////            userView.transform = CGAffineTransformIdentity
//            self.userView.transform = CGAffineTransformMakeTranslation(0, -80)
//            }, completion: nil)
//    }
//    
//    deinit {
//        NSNotificationCenter.defaultCenter().removeObserver(self)
//    }
    
    @IBAction func login(sender: UIButton) {
        
        let query = AVQuery(className: "Account")
        query.whereKey("username", equalTo: userTextField.text)
        print("获取账户信息")
        query.getFirstObjectInBackgroundWithBlock({ (account,error) -> Void in
            if let error = error {
                print("Error: \(error) \(error.userInfo)")
            }
            if let temp = account {
                print("获取成功")
                let account = Account(avObject: temp)
                //如果登陆成功
                if account.password == self.passwordTextField.text {
                    print("匹配成功")
                    let defaults = NSUserDefaults.standardUserDefaults()
                    defaults.setValue(self.userTextField.text, forKey: "username")
                    defaults.setBool(true, forKey: "isLogin")
                    self.dismissViewControllerAnimated(true, completion: nil)
                } else {
//                    let alertController = UIAlertController(title: "用户名或者密码错误，请重新输入", message: "", preferredStyle: .Alert)
//                    let action = UIAlertAction(title: "确定", style: .Cancel, handler: nil)
//                    alertController.addAction(action)
//                    let popover = alertController.popoverPresentationController
//                    popover?.sourceView = self.view
//                    popover?.sourceRect = sender.frame
//                    self.presentViewController(alertController, animated: true, completion: nil)
                    
                    //晃动效果
                    self.view.transform = CGAffineTransformMakeTranslation(25, 0)
                    UIView.animateWithDuration(0.5, delay: 0.0, usingSpringWithDamping: 0.15, initialSpringVelocity: 0.5, options: .TransitionFlipFromLeft, animations: {
                        self.view.transform = CGAffineTransformIdentity
                        }, completion: nil)
                }
            } else {
                let alertController = UIAlertController(title: "用户名不存在，请重新输入", message: "", preferredStyle: .Alert)
                let action = UIAlertAction(title: "确定", style: .Cancel, handler: nil)
                alertController.addAction(action)
                let popover = alertController.popoverPresentationController
                popover?.sourceView = self.view
                popover?.sourceRect = sender.frame
                self.presentViewController(alertController, animated: true, completion: nil)
            }

        })
    }
    
    @IBAction func close() {
//        dismissViewControllerAnimated(true, completion: nil)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewControllerWithIdentifier("Home") as! TabViewController
        presentViewController(controller, animated: false, completion: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
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

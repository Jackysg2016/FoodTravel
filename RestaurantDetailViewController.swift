//
//  RestaurantDetailViewController.swift
//  FoodPin
//
//  Created by angelorlover on 16/3/9.
//  Copyright © 2016年 angelorlover. All rights reserved.
//

import UIKit
import CoreData
import Social
import AVOSCloud

class RestaurantDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var ratingLabel: String?
    
    @IBOutlet var restaurantImageView: UIImageView!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var ratingButton: UIButton!
    
    var restaurant: Restaurant!


    override func viewDidLoad() {
        super.viewDidLoad()
        restaurantImageView.image = UIImage(data: restaurant.image!)
        tableView.backgroundColor = UIColor(red: 135/255, green: 206/255, blue: 235/255, alpha: 1)
        tableView.tableFooterView = UIView(frame: CGRectZero)
        tableView.separatorColor = UIColor(red: 135/255, green: 206/255, blue: 235/255, alpha: 1)
        title = restaurant.name
        tableView.estimatedRowHeight = 40.0
        tableView.rowHeight = UITableViewAutomaticDimension
        if let rating = restaurant.rating where rating != "" {
            ratingButton.setImage(UIImage(named: rating), forState: UIControlState.Normal)
        }

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnSwipe = true
        navigationController?.setNavigationBarHidden(false, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Delegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
    }
    
    //MARK: - DataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! RestaurantDetailTableViewCell
        cell.backgroundColor = UIColor.clearColor()
        cell.fieldLabel.textColor = UIColor.grayColor()
        cell.valueLabel.textColor = UIColor.grayColor()
        
        //configure the cell
        switch indexPath.row {
        case 0:
            cell.fieldLabel.text = NSLocalizedString("Name", comment: "Name Field")
            cell.valueLabel.text = restaurant.name
        case 1:
            cell.fieldLabel.text = NSLocalizedString("Type", comment: "Type Field")
            cell.valueLabel.text = restaurant.type
        case 2:
            cell.fieldLabel.text = NSLocalizedString("Location", comment: "Location/Address Field")
            cell.valueLabel.text = restaurant.location
        case 3:
            cell.fieldLabel.text = NSLocalizedString("Been here", comment: "Have you been here Field")
            if let isVisited = restaurant.isVisited?.boolValue {
                cell.valueLabel.text = isVisited ? NSLocalizedString("Yes, I've been here before", comment: "Yes, I've been here before") : NSLocalizedString("No", comment: "No, I haven't been here")
            }
        case 4:
            cell.fieldLabel.text = NSLocalizedString("Phone", comment: "Phone Field")
            cell.valueLabel.text = restaurant.phoneNumber
        default:
            cell.fieldLabel.text = ""
            cell.valueLabel.text = ""
            
        }
        return cell
    }
    
    @IBAction func share() {
            let shareMenu = UIAlertController(title: nil, message: "分享", preferredStyle: .ActionSheet)
            let weiboAction = UIAlertAction(title: "新浪微博", style: .Default, handler: { (action) -> Void in
                
                //检查微博是否可用
                guard SLComposeViewController.isAvailableForServiceType(SLServiceTypeSinaWeibo) else {
                    let alertMessage = UIAlertController(title: "新浪微博不可用", message: "未登录系统账户", preferredStyle: .Alert)
                    alertMessage.addAction(UIAlertAction(title: "确定", style: .Default, handler: nil))
                    if let popover = alertMessage.popoverPresentationController {
                        popover.barButtonItem = self.navigationItem.rightBarButtonItem
                    }
                    self.presentViewController(alertMessage, animated: true, completion: nil)
                    return
                }
                let weiboComposer = SLComposeViewController(forServiceType: SLServiceTypeSinaWeibo)
                weiboComposer.setInitialText(self.restaurant.name)
                weiboComposer.addImage(UIImage(data: self.restaurant.image!))
                self.presentViewController(weiboComposer, animated: true, completion: nil)
            })
            let wechatAction = UIAlertAction(title: "腾讯微博", style: .Default, handler: { (action) -> Void in
                
                //检查微博是否可用
                guard SLComposeViewController.isAvailableForServiceType(SLServiceTypeTencentWeibo) else {
                    let alertMessage = UIAlertController(title: "腾讯微博不可用", message: "未登录系统账户", preferredStyle: .Alert)
                    alertMessage.addAction(UIAlertAction(title: "确定", style: .Default, handler: nil))
                    if let popover = alertMessage.popoverPresentationController {
                        popover.barButtonItem = self.navigationItem.rightBarButtonItem
                    }
                    self.presentViewController(alertMessage, animated: true, completion: nil)
                    return
                }
                let weichatComposer = SLComposeViewController(forServiceType: SLServiceTypeTencentWeibo)
                weichatComposer.setInitialText(self.restaurant.name)
                weichatComposer.addImage(UIImage(data: self.restaurant.image!))
                self.presentViewController(weichatComposer, animated: true, completion: nil)
            })
            let cancleAction = UIAlertAction(title: "取消", style: .Cancel, handler: nil)
            shareMenu.addAction(weiboAction)
            shareMenu.addAction(wechatAction)
            shareMenu.addAction(cancleAction)
            if let popover = shareMenu.popoverPresentationController {
                popover.barButtonItem = self.navigationItem.rightBarButtonItem
            }
            self.presentViewController(shareMenu, animated: true, completion: nil)
        
    }
    
    @IBAction func close(segue: UIStoryboardSegue) {
        if let reviewViewController = segue.sourceViewController as? ReviewViewController {
            if let rating = reviewViewController.rating {
                ratingLabel = rating
                restaurant.rating = rating
                ratingButton.setImage(UIImage(named: rating), forState: UIControlState.Normal)
                
                if let managedObjectContext = (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext {
                    do {
                        try managedObjectContext.save()
                    } catch {
                        print(error)
                    }
                }
            }
        }
    }
    
    @IBAction func uploadFood() {
        let newFood = AVObject(className: "Restaurant")
        newFood.setObject(restaurant.name, forKey: "name")
        newFood.setObject(false, forKey: "isLike")
        newFood.setObject(restaurant.location, forKey: "location")
        let image = AVFile(name: restaurant.name + ".jpg", data: restaurant.image!)
        newFood.setObject(image, forKey: "image")
        newFood.saveInBackgroundWithBlock( { (success, error) -> Void in
            if success {
                let alertController = UIAlertController(title: "", message: "上传成功", preferredStyle: .Alert)
                let okAction = UIAlertAction(title: "确定", style: .Cancel, handler: nil)
                alertController.addAction(okAction)
                if let popover = alertController.popoverPresentationController {
                    popover.barButtonItem = self.navigationItem.backBarButtonItem
                }
                self.presentViewController(alertController, animated: true, completion: nil)
            } else {
                print(error)
                print("上传失败")
            }
        })
    }
   
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "showMap" {
            let destinationController = segue.destinationViewController as! MapViewController
            destinationController.restaurant = restaurant
        }
    }
    

}

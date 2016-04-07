//
//  AboutTableTableViewController.swift
//  FoodPin
//
//  Created by angelorlover on 16/3/16.
//  Copyright © 2016年 angelorlover. All rights reserved.
//

import UIKit
import SafariServices
import AVOSCloud

class AboutTableTableViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet var imageView : UIImageView!
    @IBOutlet var userImageView: UIImageView!
    @IBOutlet var userLabel: UILabel!
    private var account : Account?
    var blureffectView : UIVisualEffectView?
    
    var sectionTitles = [NSLocalizedString("Leave Feedback", comment: "Leave Feedback"), NSLocalizedString("Follow Us", comment: "Follow Us"), "帮助"]
    var sectionContent = [[NSLocalizedString("Rate us on App Store", comment: "Rate us on App Store"), NSLocalizedString("Tell us your feedback", comment: "Tell us your feedback")],
        [NSLocalizedString("Twitter", comment: "Twitter"), NSLocalizedString("Facebook", comment: "Facebook"), NSLocalizedString("Weibo", comment: "Weibo")], ["欢迎页"]]
    var links = ["https://twitter.com/angelorlover", "https://facebook.com/angelorlover", "http://weibo.com/wuzhangyong"]
    

    override func viewDidLoad() {
        super.viewDidLoad()
//        loadUserFromLeanCloud()
        //刷新功能
//        self.refreshControl = UIRefreshControl()
//        self.refreshControl?.addTarget(self, action: #selector(AboutTableTableViewController.refreshAccount), forControlEvents: .ValueChanged)
//        refreshControl?.attributedTitle = NSAttributedString(string: "更新用户信息")
//        view.addSubview(refreshControl!)
        userImageView.layer.cornerRadius = 25
        userImageView.clipsToBounds = true
//        blureffectView = UIVisualEffectView(effect: UIBlurEffect(style: .Dark))
//        blureffectView?.frame = view.bounds
//        imageView.addSubview(blureffectView!)
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        tableView.tableFooterView?.backgroundColor = UIColor.grayColor()
    }
    
//    //屏幕方向改变时
//    override func traitCollectionDidChange(previousTraitCollection: UITraitCollection?) {
//        blureffectView?.frame = imageView.bounds
//    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        loadUserFromLeanCloud()
        let defaults = NSUserDefaults.standardUserDefaults()
        let bool = defaults.boolForKey("isLogin")
        if bool {
            navigationItem.rightBarButtonItem?.title = "注销"
        } else {
            navigationItem.rightBarButtonItem?.title = "登录"
        }
    }
    
//    func close(segue: UIStoryboardSegue) {
//        loadUserFromLeanCloud()
//        print("更新用户信息")
//    }
    
    @IBAction func refreshAccount(sender: UIRefreshControl?) {
        loadUserFromLeanCloud()
        sender?.endRefreshing()
        
    }
    
    @IBAction func takePhoto() {
        let menu = UIAlertController(title: "", message: "选项", preferredStyle: .ActionSheet)
        let cameraAction = UIAlertAction(title: "相机", style: .Default, handler: { (action) -> Void in
            if UIImagePickerController.isSourceTypeAvailable(.Camera) {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.allowsEditing = false
                imagePicker.sourceType = .Camera
                imagePicker.modalPresentationStyle = .FullScreen
                self.presentViewController(imagePicker, animated: true, completion: nil)
            }
        })
        let photoAction = UIAlertAction(title: "图库", style: .Default, handler: { (action) -> Void in
            if UIImagePickerController.isSourceTypeAvailable(.PhotoLibrary) {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.allowsEditing = false
                imagePicker.sourceType = .PhotoLibrary
                self.presentViewController(imagePicker, animated: true, completion: nil)
            }
        })
        let cancleAction = UIAlertAction(title: "取消", style: .Cancel, handler: nil)
        menu.addAction(cameraAction)
        menu.addAction(photoAction)
        menu.addAction(cancleAction)
        if let popover = menu.popoverPresentationController {
            popover.barButtonItem = navigationItem.backBarButtonItem
        }
        presentViewController(menu, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        let data = UIImageJPEGRepresentation(image!, 1.0)
        if let account = account {
            account.image = AVFile(data: data)
        }
        userImageView.contentMode = UIViewContentMode.ScaleAspectFill
        userImageView.clipsToBounds = true
        dismissViewControllerAnimated(true, completion: { () -> Void in
            if NSUserDefaults.standardUserDefaults().boolForKey("isLogin") {
                self.userImageView.image = image
                self.account?.toAVObeject().saveInBackgroundWithBlock( { (success, error) -> Void in
                    if success {
                        print("图片更新成功")
                    } else {
                        print(error)
                        print("图片更新失败")
                    }
                })
            } else {
                let alertController = UIAlertController(title: "未登录", message: "", preferredStyle: .Alert)
                let action = UIAlertAction(title: "确定", style: .Cancel, handler: nil)
                alertController.addAction(action)
                if let popover = alertController.popoverPresentationController {
                    popover.barButtonItem = self.navigationItem.backBarButtonItem
                }
                self.presentViewController(alertController, animated: true, completion: nil)
            }
        })
    }


    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        switch section {
        case 0:
            return 2
        case 1:
            return 3
        case 2:
            return 1
        default:
            return 0
        }
    }
    
    //MARK: - Delegate
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)

        // Configure the cell...
        cell.textLabel?.text = sectionContent[indexPath.section][indexPath.row]

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch indexPath.section {
        case 0:
            if indexPath.row == 0 {
                if let url = NSURL(string: "http://weibo.com/wuzhangyong") {
                    UIApplication.sharedApplication().openURL(url)
                }
            } else if indexPath.row == 1 {
                performSegueWithIdentifier("showWebView", sender: self)
            }
        case 1:
                if let url = NSURL(string: self.links[indexPath.row]) {
                    let safariController = SFSafariViewController(URL: url, entersReaderIfAvailable: true)
                    self.presentViewController(safariController, animated: true, completion: nil)
                }
        case 2:
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let guideViewController = storyboard.instantiateViewControllerWithIdentifier("WalkthroughController") as! WalkthroughPageViewController
            presentViewController(guideViewController, animated: true, completion: nil)
        default:
            break
        }
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    
    @IBAction func log() {
        let defaults = NSUserDefaults.standardUserDefaults()
        let bool = defaults.boolForKey("isLogin")
        if bool {
            navigationItem.rightBarButtonItem?.title = "登录"
            defaults.setBool(false, forKey: "isLogin")
            defaults.setValue("", forKey: "username")
        } else {
            performSegueWithIdentifier("showLogin", sender: nil)
        }
        loadUserFromLeanCloud()
    }
    
    func uploadImage() {
        account?.toAVObeject().saveInBackgroundWithBlock( { (success, error) -> Void in
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
    
    func loadUserFromLeanCloud() {
        
        
        let name = "Account"
        let query = AVQuery(className: name)
        if NSUserDefaults.standardUserDefaults().boolForKey("isLogin") {
            let username = NSUserDefaults.standardUserDefaults().valueForKey("username")
            query.whereKey("username", equalTo: username)
            query.cachePolicy = AVCachePolicy.NetworkElseCache
            query.getFirstObjectInBackgroundWithBlock({ (objects, error) -> Void in
                if let error = error {
                    print("Error: \(error) \(error.userInfo)")
                }
                if let objects = objects {
                    self.account = Account(avObject: objects)
                    if let image = self.account!.image {
                        image.getDataInBackgroundWithBlock({ (imageData, error) -> Void in
                            if let data = imageData {
                                print("开始获取用户头像")
                                self.userImageView.image = UIImage(data: data)
                                print("成功获取用户头像")
                            } else {
                                print("获取用户头像失败")
                            }
                        })
                    }
                    if let username = self.account?.username {
                        self.userLabel.text = username
                    }
                } else {
                    print("获取头像数据失败")
                }
            })
        } else {
            userImageView.image = UIImage(named: "photoalbum")
            userLabel.text = "用户名"
        }
    }

    
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

//
//  RestaurantLeanViewController.swift
//  FoodPin
//
//  Created by angelorlover on 16/3/21.
//  Copyright © 2016年 angelorlover. All rights reserved.
//

import UIKit
import AVOSCloud

class DiscoverViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, RestaurantLeanCollectionCellDelegate, UIGestureRecognizerDelegate {
    
    
    @IBOutlet var imageView: UIImageView!
    
    @IBOutlet var collectionView: UICollectionView!
    
    var blurEffectiveView: UIVisualEffectView?
    
    private var restaurantLean = [RestaurantLean]()

    override func viewDidLoad() {
        
//        self.automaticallyAdjustsScrollViewInsets = false
        
        
        collectionView.backgroundColor = UIColor.clearColor()
        
//        loadRestaurantsFromLeanCloud()
        
        //毛玻璃效果
        blurEffectiveView = UIVisualEffectView(effect: UIBlurEffect(style: .Dark))
        blurEffectiveView?.frame = view.bounds
        imageView.addSubview(blurEffectiveView!)
        
        //上滑手势
        let swipeUpRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(DiscoverViewController.deleteCell(_:)))
        swipeUpRecognizer.direction = .Up
        swipeUpRecognizer.delegate = self
        self.collectionView.addGestureRecognizer(swipeUpRecognizer)
        
        //Long-pressed gestrue
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(DiscoverViewController.saveImage(_:)))
        longPress.delegate = self
        self.collectionView.addGestureRecognizer(longPress)
        
        // Do any additional setup after loading the view.
    }
    
    //屏幕方向改变时
    override func traitCollectionDidChange(previousTraitCollection: UITraitCollection?) {
        blurEffectiveView?.frame = view.bounds
    }
    
    override func viewWillAppear(animated: Bool) {
        loadRestaurantsFromLeanCloud()
    }
    
    override func viewDidAppear(animated: Bool) {
        let defaults = NSUserDefaults.standardUserDefaults()
        if defaults.boolForKey("isLogin") {
            return 
        }
        let story = UIStoryboard(name: "About", bundle: nil)
        let controller = story.instantiateViewControllerWithIdentifier("Sign") as! SignViewController
        presentViewController(controller, animated: true, completion: nil)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Data Source
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

            return restaurantLean.count

    }
    
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! RestaurantLeanCollectionCell
        
        cell.delegate = self
        cell.nameLabel.text = restaurantLean[indexPath.row].name
        cell.locationLabel.text = restaurantLean[indexPath.row].location
        cell.isLike = restaurantLean[indexPath.row].isLike
        cell.imageView.image = UIImage()
        cell.layer.cornerRadius = 4.0
        if let image = restaurantLean[indexPath.row].image {
                image.getDataInBackgroundWithBlock({ (imageData, error) -> Void in
                    if let data = imageData {
//                        print("开始获取图像")
                        cell.imageView.image = UIImage(data: data)
//                        print("成功获取图像")
                    } else {
                        print("获取图像失败")
                    }
                })
            }
        return cell
    }
    
    //从LeanCloud上下载数据
    
    func loadRestaurantsFromLeanCloud() {
        
        restaurantLean.removeAll(keepCapacity: true)
        collectionView.reloadData()
        
            let name = "Restaurant"
            let query = AVQuery(className: name)
            query.cachePolicy = AVCachePolicy.NetworkElseCache
            query.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
                
                if let error = error {

                    print("Error: \(error) \(error.userInfo)")
                }

                if let objects = objects {
                    
//                    print("开始获取数据")
                    for (index, object) in objects.enumerate() {
                        let restaurant = RestaurantLean(avObject: object as! AVObject)
                        self.restaurantLean.append(restaurant)
                        let indexPath = NSIndexPath(forRow: index, inSection: 0)
                        self.collectionView.insertItemsAtIndexPaths([indexPath])
//                        print("获取数据成功")
                    }
                } else {
                    print("获取数据失败")
                }
            })
    }
    
    // 喜欢
    
    func didLikeButtonPressed(cell: RestaurantLeanCollectionCell) {
        if let indexPath = collectionView.indexPathForCell(cell) {
                restaurantLean[indexPath.row].isLike = restaurantLean[indexPath.row].isLike ? false : true
                cell.isLike = restaurantLean[indexPath.row].isLike
                restaurantLean[indexPath.row].toAVObeject().saveInBackgroundWithBlock({ (success, error) -> Void in
                    if success {
                        print("已更新云端")
                    } else {
                        print(error)
                        print("云端更新失败")
                    }
                })
            }
        }
    
    //刷新数据
    
    @IBAction func refresh(sender: AnyObject) {
        
        loadRestaurantsFromLeanCloud()
        
    }
    
    //删除数据
    
    func deleteCell(gesture: UISwipeGestureRecognizer) {
        let point = gesture.locationInView(self.collectionView)
        if (gesture.state == UIGestureRecognizerState.Ended) {
            if let indexpath = collectionView.indexPathForItemAtPoint(point) {

                    restaurantLean[indexpath.row].toAVObeject().deleteInBackgroundWithBlock({ (success, error) -> Void in
                        if success {
//                            print("已删除数据")
                        } else {
                            print("删除数据失败")
                        }
                        self.restaurantLean.removeAtIndex(indexpath.row)
                        self.collectionView.deleteItemsAtIndexPaths([indexpath])
                    })
                }
            }
        }
    
    //保存图片
    func saveImage(gesture: UILongPressGestureRecognizer) {
        
            //捕捉动作语句置于UIAlertAction外
        
            let point = gesture.locationInView(self.collectionView)
        
            if (gesture.state == UIGestureRecognizerState.Began) {
            
            let alertController = UIAlertController(title: "即将保存图片至图库", message: "", preferredStyle: .Alert)
            let enterAction = UIAlertAction(title: "Enter", style: .Default, handler: { (action: UIAlertAction) -> Void in
                

                if let indexPath = self.collectionView.indexPathForItemAtPoint(point) {

                        if let image = self.restaurantLean[indexPath.row].image {
                            
                            image.getDataInBackgroundWithBlock({ (imageData, error) -> Void in
                                print("start loading the image")
                                if let data = imageData {
                                    UIImageWriteToSavedPhotosAlbum(UIImage(data: data)!, nil, nil, nil)
                                    print("save success")
                                }
                            })
                        }
                    }
            })
            let cancleAction = UIAlertAction(title: "Cancle", style: .Cancel, handler: nil)
            alertController.addAction(enterAction)
            alertController.addAction(cancleAction)
            let popover = alertController.popoverPresentationController
            popover?.sourceView = self.collectionView
            popover?.sourceRect = self.collectionView.bounds
            self.presentViewController(alertController, animated: true, completion: nil)
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
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
    }

}

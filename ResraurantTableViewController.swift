//
//  ResraurantTableViewController.swift
//  FoodPin
//
//  Created by angelorlover on 16/3/9.
//  Copyright © 2016年 angelorlover. All rights reserved.
//

import UIKit
import CoreData
import Social

class ResraurantTableViewController: UITableViewController, NSFetchedResultsControllerDelegate, UISearchResultsUpdating {
    
    // MARK: - Data
    
    var restaurants:[Restaurant] = []
    var fetchResultController: NSFetchedResultsController!
    var searchController:UISearchController!
    var searchResults:[Restaurant] = []
    var animation = [Bool](count: 100, repeatedValue: false)
    
    //unwind segue
    @IBAction func close(segue:UIStoryboardSegue) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //自定义导航栏返回键
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
        tableView.backgroundColor = UIColor(red: 135/255, green: 206/255, blue: 235/255, alpha: 1)
        tableView.separatorColor = UIColor(red: 135/255, green: 206/255, blue: 235/255, alpha: 1)
        tableView.estimatedRowHeight = 80.0
        tableView.rowHeight = UITableViewAutomaticDimension
        
        
        // 从数据库加载数据
        let fetchRequest = NSFetchRequest(entityName: "Restaurant")
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        if let managedObjectContext = (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext {
            
            fetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
            fetchResultController.delegate = self
            
            do {
                try fetchResultController.performFetch()
                restaurants = fetchResultController.fetchedObjects as! [Restaurant]
            } catch {
                print(error)
            }
        }
        
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        
        searchController.searchBar.placeholder = "寻找你爱的"
        searchController.searchBar.tintColor = UIColor.whiteColor()
        searchController.searchBar.barTintColor = UIColor.grayColor()
        searchController.searchBar.searchBarStyle = .Prominent
        
        tableView.tableHeaderView = searchController.searchBar

        // Uncomment the following line to preserve selection between presentations
//         self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {

        super.viewWillAppear(animated)
    }
    

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if searchController.active {
            return searchResults.count
        } else {
            return restaurants.count
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cellIdentifier = "Cell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! RestaurantTableViewCell        
        let restaurant = (searchController.active) ? searchResults[indexPath.row] : restaurants[indexPath.row]
        
        //configure the cell
        
        cell.nameLabel?.text = restaurant.name
        cell.locationLabel?.text = restaurant.location
        cell.typeLabel?.text = restaurant.type
        cell.thumbImageView?.image = UIImage(data: restaurant.image!)
        cell.thumbImageView?.layer.cornerRadius = 5
        cell.thumbImageView.clipsToBounds = true
        if let isVisited = restaurants[indexPath.row].isVisited?.boolValue {
            cell.accessoryType = isVisited ? .Checkmark : .None
        }
        cell.backgroundColor = UIColor.blackColor()
        return cell
    }
    
    // MARK: - Table view delegate
    
    //cell飞入动画
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if animation[indexPath.row] {
            return
        }
        animation[indexPath.row] = true
        let rotationTransform = CATransform3DTranslate(CATransform3DIdentity, -500, 0, 0)
        cell.layer.transform = rotationTransform
        UIView.animateWithDuration(1.0, animations: { cell.layer.transform = CATransform3DIdentity })
        
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        if searchController.active {
            return false
        } else {
            return true
        }
    }
    
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        
        // Scocial sharing button
        
        let shareAction = UITableViewRowAction(style: .Default, title: "Share", handler: { (action, indexPath) -> Void in
            
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
                    weiboComposer.setInitialText(self.restaurants[indexPath.row].name)
                    weiboComposer.addImage(UIImage(data: self.restaurants[indexPath.row].image!))
                    self.presentViewController(weiboComposer, animated: true, completion: nil)
                })
            let wechatAction = UIAlertAction(title: "腾讯微博", style: .Default, handler: { (action) -> Void in
                
                //检查微信是否可用
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
                weichatComposer.setInitialText(self.restaurants[indexPath.row].name)
                weichatComposer.addImage(UIImage(data: self.restaurants[indexPath.row].image!))
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
            
        })
        
        //Delete button
        
        let deleteAction = UITableViewRowAction(style: .Default, title: "Delete", handler: { (action, indexPath) -> Void in
            
            if let managedObjectContext = (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext {
                let restaurantToDelete = self.fetchResultController.objectAtIndexPath(indexPath) as! Restaurant
                managedObjectContext.deleteObject(restaurantToDelete)
                do {
                    try managedObjectContext.save()
                } catch {
                    print(error)
                }
            }
        })
        
        shareAction.backgroundColor = UIColor.blackColor()
        deleteAction.backgroundColor = UIColor.redColor()
        
        return [deleteAction,shareAction]
        
    }
    
    //管理CoreData
    
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        tableView.beginUpdates()
    }
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        switch type {
        case .Insert:
            if let index = newIndexPath {
                tableView.insertRowsAtIndexPaths([index], withRowAnimation: .Fade)
            }
        case .Delete:
            if let index = indexPath {
                tableView.deleteRowsAtIndexPaths([index], withRowAnimation: .Fade)
            }
        case .Update:
            if let index = indexPath {
                tableView.reloadRowsAtIndexPaths([index], withRowAnimation: .Fade)
            }
        default:
            tableView.reloadData()
        }
        
        restaurants = controller.fetchedObjects as! [Restaurant]
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        tableView.endUpdates()
    }
    
    func filterContentForSearchText(searchText: String) {
        searchResults = restaurants.filter({ (restaurant: Restaurant) -> Bool in
            
            //以名字和地点为搜索项
            let nameMatch = restaurant.name.rangeOfString(searchText, options:
            NSStringCompareOptions.CaseInsensitiveSearch)
            let locationMatch = restaurant.location.rangeOfString(searchText, options: NSStringCompareOptions.CaseInsensitiveSearch)
            return nameMatch != nil || locationMatch != nil
        })
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            filterContentForSearchText(searchText)
            tableView.reloadData()
        }
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        // 向目标controller传递数据        
        if segue.identifier == "showRestaurantDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let destinationController = segue.destinationViewController as! RestaurantDetailViewController
                destinationController.restaurant = (searchController.active) ? searchResults[indexPath.row] : restaurants[indexPath.row]

            }
        }
    }
}


    

//
//  DigestViewController.swift
//  FoodPin
//
//  Created by angelorlover on 16/3/26.
//  Copyright © 2016年 angelorlover. All rights reserved.
//  功能暂时搁置，日后更新

import UIKit

class DigestViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    private var rssItems:[ (title: String, description: String, pubDate: String, link: String) ]?
    
    @IBOutlet var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = 150.0
        tableView.rowHeight = UITableViewAutomaticDimension
        let feedParser = FeedParser()
        //http://www.zui.ms/feed
        feedParser.parseFeed("http://www.zui.ms/feed", completionHandler: { (rssItems: [(title:String, description: String, pubDate: String, link: String)]) -> Void in
            self.rssItems = rssItems
            NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                self.tableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: .None)
            })
        })
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    //delegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let item = rssItems?[indexPath.row] {
            if let url = NSURL(string: item.link) {
                UIApplication.sharedApplication().openURL(url)
            }
            tableView.deselectRowAtIndexPath(indexPath, animated: false)
        }
    }
    
    //Data Source
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        guard let rssItems = rssItems else {
            return 0
        }
        return rssItems.count
//        return 10
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! DigestTableViewCell
        
//         Configure the cell...
        if let item = rssItems?[indexPath.row] {
            cell.titleLabel.text = item.title
            cell.descriptionLabel.text = item.description
            cell.dateLabel.text = item.pubDate
            
        }
//        cell.titleLabel.text = "a"
//        cell.descriptionLabel.text = "b"
//        cell.dateLabel.text = "c"
        
        return cell
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

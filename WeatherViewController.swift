//
//  WeatherViewController.swift
//  
//
//  Created by angelorlover on 16/3/18.
//
//

import UIKit

class WeatherViewController: UIViewController{
    
    @IBOutlet var cityLabel: UILabel!
    @IBOutlet var temperatrueLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    
    let weatherURL = "http://api.openweathermap.org/data/2.5/weather?id=1850147&appid=66890b227ff7c3a88180cb030f2dc9b2"

    override func viewDidLoad() {
        super.viewDidLoad()
        getWeather()
        // Do any additional setup after loading the view.
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func close(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func getWeather() {
        let request = NSURLRequest(URL: NSURL(string: weatherURL)!)
        let urlSession = NSURLSession.sharedSession()
        let task = urlSession.dataTaskWithRequest(request, completionHandler: {
            (data, response, error) -> Void in
            if let error = error {
                print(error)
                return
            }
            if let data = data {
                
                do {
                    let jsonResult = try NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers) as? NSDictionary
                    
                    //解析JSON数据
                    
                    let city = jsonResult?["name"] as? String
                    let array = jsonResult?["weather"] as! [AnyObject]
                    let description = array[0]["main"] as? String
                    let main = jsonResult?["main"]
                    let temperatrue = Int((main!["temp"] as! Double) - 273.15)
                    
                    NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                        self.cityLabel.text = city
                        self.descriptionLabel.text = description
                        //格式化输出，增加摄氏度符号
                        self.temperatrueLabel.text = String(format: "%d", temperatrue) + "\u{00B0}"
                    })
                    
                } catch {
                    print(error)
                }
            }
        })
        task.resume()
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

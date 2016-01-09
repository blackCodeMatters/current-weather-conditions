//
//  ViewController.swift
//  currentConditionsEnhanced
//
//  Created by Dustin M on 1/4/16.
//  Copyright © 2016 Vento. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var cityTextField: UITextField!
    @IBOutlet var threeDayLabel: UILabel!
    @IBOutlet var sevenDayLabel: UILabel!
    @IBOutlet var cityImageView: UIImageView!
    

    @IBAction func checkConditionsButtonPressed(sender: AnyObject) {
        
        var wasSuccessful = false
        
        let attemptedUrl = NSURL(string: "http://www.weather-forecast.com/locations/" + cityTextField.text!.stringByReplacingOccurrencesOfString(" ", withString: "-") + "/forecasts/latest")
        
        if let url = attemptedUrl {
            
            let task = NSURLSession.sharedSession().dataTaskWithURL(url) { (data, response, error) -> Void in
                
                if let urlContent = data {
                    let threeDayWebContent = NSString(data: urlContent, encoding: NSUTF8StringEncoding)
                    let threeDayWebsiteArray = threeDayWebContent?.componentsSeparatedByString("3 Day Weather Forecast Summary:</b><span class=\"read-more-small\"><span class=\"read-more-content\"> <span class=\"phrase\">")
                    
                    let sevenDayWebContent = NSString(data: urlContent, encoding: NSUTF8StringEncoding)
                    let sevenDayWebsiteArray = sevenDayWebContent!.componentsSeparatedByString("7 Day Weather Forecast Summary:</b><span class=\"read-more-small\"><span class=\"read-more-content\"> <span class=\"phrase\">")
                    
                    
                    if threeDayWebsiteArray!.count > 1 {
                        let threeDayWeatherArray = threeDayWebsiteArray![1].componentsSeparatedByString("</span>")
                        let sevenDayWeatherArray = sevenDayWebsiteArray[1].componentsSeparatedByString("</span>")
                        
                        if threeDayWeatherArray.count > 1 {
                            wasSuccessful = true
                            let threeDayWeatherSummary = threeDayWeatherArray[0].stringByReplacingOccurrencesOfString("&deg;", withString: "º")
                            let sevenDayWeatherSummary = sevenDayWeatherArray[0].stringByReplacingOccurrencesOfString("&deg;", withString: "º")
                            
                            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                self.threeDayLabel.text = threeDayWeatherSummary
                                self.sevenDayLabel.text = sevenDayWeatherSummary
                            })
                        }
                    }
                }
                if wasSuccessful == false {
                    self.threeDayLabel.text = "error, try another city"
                    self.sevenDayLabel.text = "error, try another city"
                }
            }
        task.resume()
            
        } else {
            self.threeDayLabel.text = "error, try another city"
            self.sevenDayLabel.text = "error, try another city"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}


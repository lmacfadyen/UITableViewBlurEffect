//
//  ViewController.swift
//  UITableViewBlurEffect
//
//  Created by Lawrence F MacFadyen on 2016-04-21.
//  Copyright © 2016 LawrenceM. All rights reserved.
//

import UIKit

// Struct for the famous quotes
struct Quote {
    var text: String
    var author: String
}

// Define one custom color for a nice selection background color
extension UIColor {
    class func applicationChevyOrangeColor() -> UIColor {
        return UIColor(red:225.0/255.0, green:50.0/255.0, blue:29.0/255.0, alpha:0.3);
    }
}

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    // Famous quotes and authors
    var quotes = [Quote(text: "You miss 100% of the shots you don’t take.", author: "Wayne Gretzky"),Quote(text: "If you don’t design your own life plan, chances are you’ll fall into someone else’s plan. And guess what they have planned for you? Not much.", author: "Jim Rohn"),Quote(text: "A goal should scare you a little, and excite you a lot.", author: "Joe Vitale"),Quote(text: "Start by doing what's necessary; then do what's possible; and suddenly you are doing the impossible.", author: "Francis of Assisi")]
    
    // Identifier for the table view cell
    let cellIdentifier = "quoteCell"
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        // Only show separators where there is data
        tableView.tableFooterView = UIView(frame: CGRectZero)
        
        // Dynamically size the height of the table view cells
        tableView.estimatedRowHeight = 44.0
        tableView.rowHeight = UITableViewAutomaticDimension
        
        addBlurEffect()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // Hide the status bar for this app
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    // Only one section in the table view
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    // Rows is equal to the number of Quotes defined above
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return quotes.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // Our custom cell so we can access the quote text and author
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! QuoteTableViewCell

        // Surrounding quotes with quotation marks and factoring in locale
        let locale = NSLocale.currentLocale()
        let qBegin = locale.objectForKey(NSLocaleQuotationBeginDelimiterKey) as? String ?? "\""
        let qEnd = locale.objectForKey(NSLocaleQuotationEndDelimiterKey) as? String ?? "\""
        
        let row = indexPath.row
        // Set the labels in the custom cell
        cell.quoteLabel.text = qBegin + quotes[row].text + qEnd
        cell.authorLabel.text = quotes[row].author
        
        // Background color for each cell using the UIColor extension color above
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.applicationChevyOrangeColor()
        cell.selectedBackgroundView = backgroundView
        
        return cell
    }
    
    func addBlurEffect(){
        
        // Create the UIVisialEffectView instance with UIBlurEffect
        let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .Dark))
        
        // CRITICAL - Needs to be false for constraints and rotation to work
        blurView.translatesAutoresizingMaskIntoConstraints = false
        
        // Add as subview so it is "above" the imageView and blurs it
        imageView.addSubview(blurView)
        
        // This is the other way to add the blurView in this example
        // If you choose this way, it is also above the imageView
        // Uncomment imageView.addSubview(blurView) if you want to try it
        //view.insertSubview(blurView, aboveSubview: imageView)
        
        // Constraints to keep size of blurView and view the same
        let topConstraint = NSLayoutConstraint(item: blurView, attribute: .Top, relatedBy: .Equal, toItem: view, attribute: .Top, multiplier: 1, constant: 0)
        let leftConstraint = NSLayoutConstraint(item: blurView, attribute: .Left, relatedBy: .Equal, toItem: view, attribute: .Left, multiplier: 1, constant: 0)
        let rightConstraint = NSLayoutConstraint(item: blurView, attribute: .Right, relatedBy: .Equal, toItem: view, attribute: .Right, multiplier: 1, constant: 0)
        let bottomConstraint = NSLayoutConstraint(item: blurView, attribute: .Bottom, relatedBy: .Equal, toItem: view, attribute: .Bottom, multiplier: 1, constant: 0)
        
        // Add the constraints, and now rotation works perfectly so that the 
        // blur view does not get out of sync with the view and image rotation
        view.addConstraints([topConstraint, leftConstraint, rightConstraint, bottomConstraint])
        
        // Add separatorEffect to give some color and transparency to the separator lines
        tableView.separatorEffect = UIVibrancyEffect(forBlurEffect: blurView.effect as! UIBlurEffect)
    }

}


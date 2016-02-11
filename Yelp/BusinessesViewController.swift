//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Timothy Lee on 4/23/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit

class BusinessesViewController: UIViewController , UITableViewDataSource, UITableViewDelegate, FiltersViewControllerDelegate{

    var businesses: [Business]!
    
    @IBOutlet weak var businessTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.businessTableView.delegate = self
        self.businessTableView.dataSource = self
        self.businessTableView.rowHeight = UITableViewAutomaticDimension
        self.businessTableView.estimatedRowHeight = 120
        
        Business.searchWithTerm("Thai", completion: { (businesses: [Business]!, error: NSError!) -> Void in
            self.businesses = businesses
            
            self.businessTableView.reloadData()
            for business in businesses {
                print(business.name!)
                print(business.address!)
            }
        })
        
    

/* Example of Yelp search with more search options specified
        Business.searchWithTerm("Restaurants", sort: .Distance, categories: ["asianfusion", "burgers"], deals: true) { (businesses: [Business]!, error: NSError!) -> Void in
            self.businesses = businesses
            
            for business in businesses {
                print(business.name!)
                print(business.address!)
            }
        }
*/
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = businessTableView.dequeueReusableCellWithIdentifier("BusinessCell", forIndexPath: indexPath) as! BusinessCell
        cell.business = self.businesses[indexPath.row]
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.businesses != nil {
            return self.businesses.count
        } else {
            return 0 
        }
    }
    
    func filterViewController(filterViewController: FiltersViewController, didUpdateFilters filters: [String : AnyObject]) {
        
        let categories = filters["categories"] as? [String]
        print(categories )
        Business.searchWithTerm("Restaurants", sort: nil, categories: categories, deals: nil) { (businesses:[Business]!, error:NSError!) -> Void in
            self.businesses = businesses
            print(businesses)
            self.businessTableView.reloadData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let navigationController = segue.destinationViewController as! UINavigationController
        let filtersController = navigationController.topViewController as! FiltersViewController
        
        filtersController.delegate = self
    }

}

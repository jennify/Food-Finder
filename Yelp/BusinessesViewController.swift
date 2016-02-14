//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Timothy Lee on 4/23/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit

class BusinessesViewController: UIViewController , UITableViewDataSource, UITableViewDelegate, FiltersViewControllerDelegate, UISearchBarDelegate{

    var businesses: [Business]!
    var searchBar: UISearchBar!
    var currentFilters: Filters!
    
    @IBOutlet weak var businessTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.businessTableView.delegate = self
        self.businessTableView.dataSource = self
        self.businessTableView.rowHeight = UITableViewAutomaticDimension
        self.businessTableView.estimatedRowHeight = 120
        

        // Initialize the UISearchBar
        searchBar = UISearchBar()
        searchBar.delegate = self
        
        // Add SearchBar to the NavigationBar
        searchBar.sizeToFit()
        navigationItem.titleView = searchBar
        
        self.currentFilters = Filters(dictionary: ["searchTerm": "Restaurants"])
        doYelpSearch()


    }
    
    func doYelpSearch() {

        doYelpSearch(currentFilters.searchTerm!, sort: currentFilters.sortMode, categories: currentFilters.categories, deals: currentFilters.deals, radius: currentFilters.radius)
    }
    
    func doYelpSearch(searchTerm: String!, sort:YelpSortMode?, categories: [String]?, deals: Bool?, radius: Int?) {
        
        Business.searchWithTerm(searchTerm, sort: sort, categories: categories, deals: deals, radius: radius) { (businesses: [Business]!, error: NSError!) -> Void in
            self.businesses = businesses
            self.businessTableView.reloadData()

        }
        
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
    

    
    func filterViewController(filterViewController: FiltersViewController, didUpdateFilters filters: Filters) {
        currentFilters = filters
        doYelpSearch()

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

    func searchBarShouldBeginEditing(searchBar: UISearchBar) -> Bool {
        searchBar.setShowsCancelButton(true, animated: true)
        return true;
    }
    
    func searchBarShouldEndEditing(searchBar: UISearchBar) -> Bool {
        searchBar.setShowsCancelButton(false, animated: true)
        return true;
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.text = ""
        currentFilters.searchTerm = "Restaurants"
        doYelpSearch()
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        currentFilters.searchTerm =  searchBar.text!
        doYelpSearch()
    }
    
}

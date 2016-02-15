//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Timothy Lee on 4/23/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit

class BusinessesViewController: UIViewController , UITableViewDataSource, UITableViewDelegate, FiltersViewControllerDelegate, UISearchBarDelegate, UIScrollViewDelegate {

    var businesses: [Business]!
    var searchBar: UISearchBar!
    var currentFilters: Filters!
    var isMoreDataLoading: Bool!
    var loadingMoreView: InfiniteScrollActivityView?
    

    @IBOutlet weak var businessTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.businessTableView.delegate = self
        self.businessTableView.dataSource = self
        self.businessTableView.rowHeight = UITableViewAutomaticDimension
        self.businessTableView.estimatedRowHeight = 120
        
        
        // Initialize Infinite scroll loading view
        self.isMoreDataLoading = false
        self.loadingMoreView = InfiniteScrollActivityView()
        
        // Set up Infinite Scroll loading indicator
        let frame = CGRectMake(0, businessTableView.contentSize.height, businessTableView.bounds.size.width, InfiniteScrollActivityView.defaultHeight)
        loadingMoreView = InfiniteScrollActivityView(frame: frame)
        loadingMoreView!.hidden = true
        businessTableView.addSubview(loadingMoreView!)
        
        // Set up Insets to view the Infinite Scroll
        var insets = businessTableView.contentInset;
        insets.bottom += InfiniteScrollActivityView.defaultHeight;
        businessTableView.contentInset = insets

        // Initialize the UISearchBar
        searchBar = UISearchBar()
        searchBar.delegate = self
        
        // Add SearchBar to the NavigationBar
        searchBar.sizeToFit()
        navigationItem.titleView = searchBar
        
        self.currentFilters = Filters(dictionary: ["searchTerm": "Restaurants"])
        doYelpSearch()
        


    }
    
    /* Yelp API calls */
    
    func doYelpSearch() {
        doYelpSearch(currentFilters.searchTerm!, sort: currentFilters.sortMode, categories: currentFilters.categories, deals: currentFilters.deals, radius: currentFilters.radius, offset: nil)
    }
    
    func doLoadMoreYelpSearch() {
        // Infinite Scroll
        
        let searchTerm = currentFilters.searchTerm
        let categories = currentFilters.categories
        let deals = currentFilters.deals
        let radius = currentFilters.radius
        let offset = businesses.count
        let sort = currentFilters.sortMode
        
        Business.searchWithTerm(searchTerm, sort: sort, categories: categories, deals: deals, radius: radius, offset: offset) { (businesses: [Business]!, error: NSError!) -> Void in
            self.businesses.appendContentsOf(businesses)
            self.isMoreDataLoading = false
            self.loadingMoreView?.stopAnimating()
            self.businessTableView.reloadData()
            
        }
    }
    
    func doYelpSearch(searchTerm: String!, sort:YelpSortMode?, categories: [String]?, deals: Bool?, radius: Int?, offset: Int?) {
        Business.searchWithTerm(searchTerm, sort: sort, categories: categories, deals: deals, radius: radius, offset: offset) { (businesses: [Business]!, error: NSError!) -> Void in
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

        if (segue.identifier == "filtersSegue"){
            let navigationController = segue.destinationViewController as! UINavigationController
            let filtersController = navigationController.topViewController as! FiltersViewController
    
            filtersController.delegate = self
        } else if (segue.identifier == "mapsSegue") {
            let mapsController = segue.destinationViewController as! BusinessMapsViewController
            mapsController.businesses = self.businesses
//            mapsController.delegate = self
        }

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
    
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        if (!isMoreDataLoading) {
            // Calculate the position of one screen length before the bottom of the results
            let scrollViewContentHeight = businessTableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - businessTableView.bounds.size.height
            
            // When the user has scrolled past the threshold, start requesting
            if(scrollView.contentOffset.y > scrollOffsetThreshold && businessTableView.dragging) {
                isMoreDataLoading = true
                // Code to load more results
                // Update position of loadingMoreView, and start loading indicator
                let frame = CGRectMake(0, businessTableView.contentSize.height, businessTableView.bounds.size.width, InfiniteScrollActivityView.defaultHeight)
                loadingMoreView?.frame = frame
                loadingMoreView?.startAnimating()
                
                doLoadMoreYelpSearch()

            }
        }
    }
}

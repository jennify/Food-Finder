//
//  Filters.swift
//  Yelp
//
//  Created by Jennifer Lee on 2/13/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit

class Filters: NSObject {
    var filters : [String:AnyObject]
    
    var categories : [String]?
    var deals : Bool?
    var sortMode : YelpSortMode?
    var distance : String?
    var searchTerm : String!
    var radius : Int?
    
    init(dictionary: [String:AnyObject]) {
        self.filters = dictionary
        
        self.categories = dictionary["categories"] as? [String]
        self.deals = dictionary["deals"] as? Bool
        self.radius = dictionary["radius"] as? Int
        
        self.sortMode = dictionary["sortMode"] as? YelpSortMode
        self.distance = ""
        if dictionary["searchTerm"] != nil {
            self.searchTerm = dictionary["searchTerm"] as? String
        } else {
            self.searchTerm = "Restaurants"
        }

    }
}

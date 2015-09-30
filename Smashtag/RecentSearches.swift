//
//  RecentSearches.swift
//  Smashtag
//
//  Created by nevercry on 9/25/15.
//  Copyright © 2015 nevercry. All rights reserved.
//

import Foundation

class RecentSearches {
    
    private struct Const {
        static let ValuesKey = "RecentSearches.Value"
        static let NumberOfSearches = 100
    }
    
    private let defaults = NSUserDefaults.standardUserDefaults()
    
    var values: [String] {
        get { return defaults.objectForKey(Const.ValuesKey) as? [String] ?? [] }
        set { defaults.setObject(newValue, forKey: Const.ValuesKey) }
    }
    
    func add (search: String) {
        var currentSearches = values
        if let index = currentSearches.indexOf(search) {
            currentSearches.removeAtIndex(index)
        }
        currentSearches.insert(search, atIndex: 0)
        while currentSearches.count > Const.NumberOfSearches {
            currentSearches.removeLast()
        }
        values = currentSearches
    }
    
    func removeAtIndex(index: Int) {
        var currentSearches = values
        currentSearches.removeAtIndex(index)
        values = currentSearches
    }
    
}
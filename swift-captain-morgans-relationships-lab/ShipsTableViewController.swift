//
//  ShipsTableViewController.swift
//  swift-captain-morgans-relationships-lab
//
//  Created by Flatiron School on 10/20/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit

class ShipsTableViewController: UITableViewController {
    
    let store = DataStore.sharedDataStore
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        store.fetchData()
        store.generateTestData()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(true)
        store.fetchData()
        tableView.reloadData()
        
    }

}

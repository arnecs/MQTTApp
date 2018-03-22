//
//  ViewController.swift
//  MQTTApp
//
//  Created by Arne Christian Skarpnes on 12.03.2018.
//  Copyright © 2018 Arne Christian Skarpnes. All rights reserved.
//

import Cocoa

class ViewController: NSSplitViewController {


    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        if let splitSetting = UserDefaults.standard.value(forKey: "SplitViewSetting") as? Int {
            
            splitViewItems[0].isCollapsed = splitSetting % 2 != 0
            splitViewItems[1].isCollapsed = splitSetting % 3 != 0
            
        }
        
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    


}


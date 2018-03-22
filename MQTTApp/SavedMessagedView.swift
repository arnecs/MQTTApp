//
//  SavedMessagedView.swift
//  MQTTApp
//
//  Created by Arne Christian Skarpnes on 20.03.2018.
//  Copyright © 2018 Arne Christian Skarpnes. All rights reserved.
//

import Cocoa


class SavedMessagesView: NSView {
    
    
    //var color: NSColor = NSColor.green
    
    
    override var exposedBindings: [NSBindingName] {
        return super.exposedBindings + [NSBindingName("selected")]
    }
    @objc dynamic var selected: Bool = false

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
        
        
        if selected {
            NSColor.black.withAlphaComponent(0.1).setFill()
            self.bounds.fill()
        }
        
        let clr = NSColor(//red: CGFloat(0.5), green: CGFloat(1), blue: CGFloat(0.25), alpha: CGFloat(0.5))
            
                      red: CGFloat(arc4random_uniform(UInt32(255))) / 255,
                                  green: CGFloat(arc4random_uniform(UInt32(255))) / 255,
                                   blue: CGFloat(arc4random_uniform(UInt32(255))) / 255,
                                  alpha: CGFloat(0.5))
 
        
        clr.setFill()
        
        //self.color.setFill()
        
        let rect = CGRect(x: 45, y: 0, width: 5, height: 45)
        
        rect.fill()
        
        
    }
}



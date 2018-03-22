//
//  WindowController.swift
//  MQTTApp
//
//  Created by Arne Christian Skarpnes on 13.03.2018.
//  Copyright © 2018 Arne Christian Skarpnes. All rights reserved.
//

import Cocoa
import CocoaMQTT

class WindowController: NSWindowController {
    
    @IBOutlet weak var connectionMenu: NSPopUpButton!
    @IBOutlet weak var statusIndicator: NSToolbarItem!
    @IBOutlet weak var connectButton: NSButton!
    
    var connections: [MQTTConnection] = []
    
    override func windowDidLoad() {
        super.windowDidLoad()
    
        // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
        
        // Setup MQTT
        let mqtt = MQTTManager.shared.mqtt

        mqtt.didChangeState = { mqtt, state in
            
            switch state {
            case .connecting:
                self.statusIndicator.image = NSImage(named: NSImage.Name.statusPartiallyAvailable)
                self.connectButton.title = "Cancel"
                
            case .connected:
                self.statusIndicator.image = NSImage(named: NSImage.Name.statusAvailable)
                self.connectButton.title = "Disconnect"
                
            case .disconnected:
                self.statusIndicator.image = NSImage(named: NSImage.Name.statusUnavailable)
                self.connectButton.title = "Connect"
            default:
                ()
            }
        }
        
        updateConnectionList()
        
        
    }
    
    
    func updateConnectionList() {
        
        let appDelegate = NSApp.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        do {
            if let connections = try context.fetch(NSFetchRequest<NSFetchRequestResult>(entityName: "MQTTConnection")) as? [MQTTConnection] {
                self.connections = connections
                
                /*
                // Remove all but separator and edit
                while connectionMenu.numberOfItems > 2 {
                    connectionMenu.removeItem(at: 0)
                }
                
                
                
                // Add connections on top
                for conn in connections {
                    if let name = conn.name {
                        
                        let item = ConnectionMenuItem(title: name, action: #selector(connectionSelect(_:)), keyEquivalent: "")
                        item.connection = conn
                        
                        connectionMenu.menu?.insertItem(item, at: 0)
                    }
                }
                
                self.connList = connections + connList
                
                
                if connectionMenu.numberOfItems == 2 {
                    connectionMenu.insertItem(withTitle: "No Connections", at: 0)
                } else if let firstItem = connectionMenu.item(at: 0) as? ConnectionMenuItem {
                    MQTTManager.shared.connection = firstItem.connection
                }
                */
                
                
                // Clear list
                connectionMenu.removeAllItems()
                
                // Selected connection
                let selectedItem = UserDefaults.standard.value(forKey: "UserConnectionName") as? String
                
                
                // Add connections
                var connectionSet = false
                for con in connections {
                    let item = ConnectionMenuItem(title: con.name ?? "No Name", action: #selector(connectionSelect(_:)), keyEquivalent: "")
                    item.connection = con
                    
                    if con.name == selectedItem {
                        // Add to top
                        connectionMenu.menu?.insertItem(item, at: 0)
                        MQTTManager.shared.connection = con
                        connectionSet = true
                        
                    } else {
                        // Add to bottom
                        connectionMenu.menu?.addItem(item)
                    }
                }
                
                if !connectionSet {
                    MQTTManager.shared.connection = connections.first
                }
                
                // Separator + Edit
                connectionMenu.menu?.addItem(NSMenuItem.separator())
                
                let edit = NSMenuItem(title: "Edit Connections...", action: #selector(editConnection(_:)), keyEquivalent: "")
                
                connectionMenu.menu?.addItem(edit)
                
                
                
                
            }
        } catch {
            print(error)
        }
        
    }
    
    @objc func connectionSelect(_ sender: ConnectionMenuItem) {
        if let conn = sender.connection {
            
            MQTTManager.shared.connection = conn
            
            let index = connectionMenu.indexOfSelectedItem
            if index >= 0 && index < connectionMenu.numberOfItems {
                // Remove item
                connectionMenu.removeItem(at: index)
                // Insert at tom
                connectionMenu.menu?.insertItem(sender, at: 0)
            }
            
            
            UserDefaults.standard.set(conn.name, forKey: "UserConnectionName")
        }
    }
    
    @objc func editConnection (_ sender: Any) {
        print ("Edit now")
        let identifier = NSStoryboard.SceneIdentifier(rawValue: "ConnectionScene")
        if let conVC = self.storyboard?.instantiateController(withIdentifier: identifier) as? ConnectionsViewController {
            
            conVC.windowController = self
            
            self.contentViewController?.presentViewControllerAsModalWindow(conVC)
            
        }
        
    }
    
    @IBAction func connect(_ sender: Any) {
        
        let mqttManager = MQTTManager.shared
        
        // Disconnect if connecting or connected
        if (mqttManager.state == .connected || mqttManager.state == .connecting) {
            mqttManager.disconnect()
            
        } else {
            mqttManager.connect()
        }
        
        
    }
    
    override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
        
        if segue.identifier?.rawValue == "connections_segue", let dest = segue.destinationController as? ConnectionsViewController {
           
            dest.windowController = self
        }
    }
    
    
    
    @IBAction func setViews(_ sender: NSSegmentedControl) {
        
        let contController = contentViewController as! ViewController
        
        switch sender.selectedSegment {
        case 0:
            // Publish
            contController.splitViewItems[0].isCollapsed = false
            contController.splitViewItems[1].isCollapsed = true
        case 1:
            // Subscribe
            contController.splitViewItems[0].isCollapsed = true
            contController.splitViewItems[1].isCollapsed = false
        case 2:
            // Publish + Subscribe
            contController.splitViewItems[0].isCollapsed = false
            contController.splitViewItems[1].isCollapsed = false
        default:
            ()
        }
    }
    
    
    
}



class ConnectionMenuItem: NSMenuItem {
    var connection: MQTTConnection?
}

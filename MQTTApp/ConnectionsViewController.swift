//
//  ConnectionsViewController.swift
//  MQTTApp
//
//  Created by Arne Christian Skarpnes on 13.03.2018.
//  Copyright © 2018 Arne Christian Skarpnes. All rights reserved.
//

import Cocoa
import CocoaMQTT

class ConnectionsViewController: NSViewController {
    
    @IBOutlet var testButton: NSButton!
    @IBOutlet var connectionsArrayController: NSArrayController!
    
    @IBOutlet weak var connectionStatus: NSImageView!
    @IBOutlet weak var connectionSpinner: NSProgressIndicator!
    
    var mqtt: CocoaMQTT!
    
    var windowController: WindowController?
    
    @objc let managedObjectContext: NSManagedObjectContext
    
    required init?(coder: NSCoder) {
        self.managedObjectContext = (NSApp.delegate as! AppDelegate).persistentContainer.viewContext
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    @IBAction func addConnection(_ sender: Any) {
        
        let context = (NSApp.delegate as! AppDelegate).persistentContainer.viewContext
        let conn = MQTTConnection(context: context)
        let lastWill = MQTTLastWill(context: context)
        
        // Enter some example values
        conn.name = "Mosquitto"
        conn.host = "test.mosquitto.org"
        conn.port = 1883
        conn.clientID = UUID().uuidString
        
        conn.lastWill = lastWill
        
        connectionsArrayController.addObject(conn)
        
    }
    @IBAction func removeConnection(_ sender: Any) {
        // Remove selected item
        connectionsArrayController.remove(contentsOf: connectionsArrayController.selectedObjects)
        
    }
    @IBAction func generateUniqueID(_ sender: Any) {
     
        let uuid = UUID().uuidString
        if let selected = connectionsArrayController.selectedObjects.first as? MQTTConnection {
            selected.clientID = uuid
        }
 
    }
    
    @IBAction func testConnection(_ sender: Any) {
        
        if let conn = connectionsArrayController.selectedObjects.first as? MQTTConnection {
            
            if let host = conn.host, let clientID = conn.clientID {
                let port = conn.port
                
                print(host, port, clientID)
                
                self.mqtt = CocoaMQTT(clientID: clientID, host: host, port: UInt16(port))
                
                mqtt.autoReconnect = conn.autoReconnect
                mqtt.cleanSession = conn.cleanSession
                mqtt.keepAlive = UInt16(conn.keepAlive)
                
                // More settings here
                // ...
                // ...Later
                
                
                var connected = false
                mqtt.didChangeState = { mqtt, state in
                    
                    switch state {
                    case .connected:
                        //self.testButton.image = NSImage(named: NSImage.Name.statusAvailable)
                        self.connectionStatus.image = NSImage(named: NSImage.Name.statusAvailable)
                        
                        self.connectionSpinner.isHidden = true
                        self.connectionSpinner.stopAnimation(self)

                        connected = true
                        mqtt.disconnect()
                        
                    case .connecting:
                        //self.testButton.image = NSImage(named: NSImage.Name.statusPartiallyAvailable)
                        self.connectionStatus.image = nil
                        self.connectionSpinner.startAnimation(self)
                        self.connectionSpinner.isHidden = false

                    case .disconnected:
                        
                        self.connectionSpinner.stopAnimation(self)
                        self.connectionSpinner.isHidden = true

                        if connected {
                            self.connectionStatus.image = NSImage(named: NSImage.Name.statusAvailable)
                        } else {
                            self.connectionStatus.image = NSImage(named: NSImage.Name.statusUnavailable)
                            //self.testButton.image = NSImage(named: NSImage.Name.statusUnavailable)
                            
                        }

                    case .initial:
                        //self.testButton.image = NSImage(named: NSImage.Name.statusNone)
                        ()
                    }
                }

                mqtt.didConnectAck = { mqtt, ack in
                    print("Ack", ack)
                }
                
                // Test connection
                mqtt.connect()
            }
        }
    }
    
    @IBAction func okPressed(_ sender: Any) {
        
        // Save the data to coredata
        (NSApplication.shared.delegate as! AppDelegate).saveContext()
        
        windowController?.updateConnectionList()
        
       
        
        dismiss(self)
    }
    
    @IBAction func cancelPressed(_ sender: Any) {
        managedObjectContext.rollback()
        
        // Propmt Revert changes?
        dismiss(self)
    }
    
    
    override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
        print(segue.destinationController)
    }
}

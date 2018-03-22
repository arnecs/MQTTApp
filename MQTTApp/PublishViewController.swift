//
//  PublishViewController.swift
//  MQTTApp
//
//  Created by Arne Christian Skarpnes on 13.03.2018.
//  Copyright © 2018 Arne Christian Skarpnes. All rights reserved.
//

import Cocoa
import CocoaMQTT

class PublishViewController: NSViewController, NSOutlineViewDelegate, NSOutlineViewDataSource {

    @IBOutlet weak var qosField: NSSegmentedControl!
    @IBOutlet weak var topicField: NSTextField!
    @IBOutlet weak var payloadField: NSTextView!
    @IBOutlet weak var retainedField: NSButton!
    
    @IBOutlet var savedMessagesView: SavedMessagesView!
    
    @IBOutlet weak var savedMessagesTableView: NSTableView!
    //var mqttController: MQTTController!
    
    
    @objc dynamic var items = ["A","B","C","D"]

    
    @objc dynamic var savedMessages: [String] = ["A", "B", "C"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        
        payloadField.isRichText = false
        
        payloadField.isAutomaticQuoteSubstitutionEnabled = false
        
        savedMessagesTableView.selectionHighlightStyle = .none
        
        
        /*
        // Setup MQTT
        let mqtt = MQTTManager.shared.mqtt
        
        mqtt.didCompletePublish = {mqtt, uint in }
        mqtt.didPublishMessage = {mqtt, msg, uint in }
        mqtt.didPublishAck = {mqtt, uint in }
 
         */
        
    }
    @IBAction func publish(_ sender: Any) {
        
        let topic = topicField.stringValue
        let payload = payloadField.string
        let qos = CocoaMQTTQOS(rawValue: UInt8(qosField.selectedSegment))!
        let retained = retainedField.state == .on
        let dup = false
        
        print("QoS", qosField.selectedSegment, qos)
        
        MQTTManager.shared.mqtt.publish(topic, withString: payload, qos: qos, retained: retained, dup: dup)
        
    }
    
    
    
        
    
    
}


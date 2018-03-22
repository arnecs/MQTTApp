//
//  SubscribeViewController.swift
//  MQTTApp
//
//  Created by Arne Christian Skarpnes on 13.03.2018.
//  Copyright © 2018 Arne Christian Skarpnes. All rights reserved.
//

import Cocoa
import CocoaMQTT

class SubscribeViewController: NSViewController {

    @IBOutlet weak var topicField: NSTextField!
    @IBOutlet var inspectMessagePayloadField: NSTextView!    
    @IBOutlet weak var subscribeButton: NSButton!
    @IBOutlet var subscriptionsArrayController: NSArrayController!
    
    @objc dynamic var subscriptions: [MQTTSubscription] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        inspectMessagePayloadField.isEditable = false
        
        // Setup MQTT
        let mqtt = MQTTManager.shared.mqtt
        

        mqtt.didSubscribeTopic = {_, topic in
            
            // Add topic
            var subAlreadyInCollection = false
            for sub in self.subscriptions {
                if sub.topic == topic {
                    // Subscription found
                    sub.active = true
                    subAlreadyInCollection = true
                    break
                }
            }
            
            if !subAlreadyInCollection {
                // Add subscription
                let sub = MQTTSubscription(topic: topic)
                self.subscriptions.append(sub)
            }
        }
        
        mqtt.didUnsubscribeTopic = {_, topic in
            for sub in self.subscriptions {
                if sub.topic == topic {
                    sub.active = false
                }
            }
        }
        
        mqtt.didReceiveMessage = {_, msg, _ in
            
            // Add message
            let message = MQTTMessage(msg)
            
            for sub in self.subscriptions {
                if sub.active && self.topicMatch(sub.topic, message.topic) {
                    sub.add(message: message)
                }
            }
        }
        
    }
    
    func topicMatch(_ topicA: String, _ topicB: String) -> Bool {
        
        let a = topicA.components(separatedBy: "/")
        let b = topicB.components(separatedBy: "/")
        
       
        for i in 0..<max(a.count, b.count) {
            if i == a.count || i == b.count {
                return false
            }
            let ai = a[i], bi = b[i]
            if  (
                
                (ai == bi) ||
                (ai == "+" || bi == "+")) {
                continue
            } else if (
                (ai == "#" && i == a.count - 1) ||
                    (bi == "#" && i == b.count - 1)) {
                return true
            } else {
                return false
            }
        }
        
        return true
        
    }
        
    @IBAction func subscribe(_ sender: Any) {
        
       
        
        let topic = topicField.stringValue
        
        // Check if topic already exists
        for sub in subscriptions {
            if sub.topic == topic {
                // Topic already exists
                // Subscribe if not active
                if !sub.active {
                    MQTTManager.shared.mqtt.subscribe(topic)
                }
                //
                return
            }
        }
        
        MQTTManager.shared.mqtt.subscribe(topic)
    }
    
    @IBAction func delete_subscription(_ sender: Any) {
        
        // Get selected topic and unsubscribe
        if let sub = subscriptionsArrayController.selectedObjects.first as? MQTTSubscription {
            // Unsubscribe
            MQTTManager.shared.mqtt.unsubscribe(sub.topic)
            
            // Remove topic
            if let i = subscriptions.index(of: sub) {
                subscriptions.remove(at: i)
            }
        }
    }
    
    @IBAction func clearMessages(_ sender: Any) {
        
        if let topic = (subscriptionsArrayController.selectedObjects.first as? MQTTSubscription)?.topic {
            
            for sub in subscriptions {
                if sub.topic == topic {
                    sub.clearMessages()
                    break
                }
            }
        }
    }
    
    @IBAction func toggleSubscribe(_ sender: Any) {
        
        if let sub = subscriptionsArrayController.selectedObjects.first as? MQTTSubscription {
            if sub.active {
                MQTTManager.shared.mqtt.unsubscribe(sub.topic)
            } else {
                MQTTManager.shared.mqtt.subscribe(sub.topic)
            }
        }
    }
    
}













//
//  MQTTSubscription.swift
//  MQTTApp
//
//  Created by Arne Christian Skarpnes on 20.03.2018.
//  Copyright © 2018 Arne Christian Skarpnes. All rights reserved.
//

import Foundation
import CocoaMQTT


class MQTTSubscription: NSObject {
    
    @objc dynamic let topic : String
    @objc dynamic var messages : [MQTTMessage] = []
    @objc dynamic var active: Bool = true
    
    init(topic: String) {
        self.topic = topic
    }
    
    func add(message: MQTTMessage) {
        self.messages.append(message)
    }
    
    func clearMessages() {
        self.messages = []
    }
}

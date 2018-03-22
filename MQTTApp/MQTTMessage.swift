//
//  MQTTMessage.swift
//  MQTTApp
//
//  Created by Arne Christian Skarpnes on 16.03.2018.
//  Copyright © 2018 Arne Christian Skarpnes. All rights reserved.
//

import Foundation
import CocoaMQTT

class MQTTMessage: NSObject {
    
    @objc dynamic var qos: CocoaMQTTQOS
    @objc dynamic var topic: String
    @objc dynamic var payload: [UInt8]
    @objc dynamic var retained: Bool
    
    @objc dynamic var string: String? {
        return String(bytes: self.payload, encoding: .utf8)
    }
    
    @objc dynamic let timeRecieved : String
    
    init(_ msg: CocoaMQTTMessage) {
        qos = msg.qos
        topic = msg.topic
        payload = msg.payload
        retained = msg.retained
        
        
        let now = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = "MM-dd HH:mm:ss"
        timeRecieved = dateFormatter.string(from: now)
        
        super.init()
    }
    
}

//
//  MQTTController.swift
//  MQTTApp
//
//  Created by Arne Christian Skarpnes on 13.03.2018.
//  Copyright © 2018 Arne Christian Skarpnes. All rights reserved.
//

import Foundation
import CocoaMQTT

typealias CocoaMQTTStateChange = (CocoaMQTT, CocoaMQTTConnState) -> Void

class MQTTManager {
    
    
    
    let defaultValues: [String: Any] = [
        "clientID": "",
        "host": "localhost"
    ]
    
    var connection: MQTTConnection? {
        didSet {
            // Disconnect before changing connection
            mqtt.disconnect()
            
            
            mqtt.clientID = connection?.clientID            ?? ""
            mqtt.host = connection?.host                    ?? ""
            mqtt.port = UInt16(connection?.port             ?? 1883)
            mqtt.autoReconnect = connection?.autoReconnect  ?? false
            mqtt.keepAlive = UInt16(connection?.keepAlive   ?? 60)
            //mqtt.autoReconnectTimeInterval = UInt16(
             //   connection?.autoReconnectTimeInterval       ?? 10)
            /*
            mqtt.willMessage = CocoaMQTTWill(topic: connection?.lastWill?.topic ?? "", message: connection?.lastWill?.message ?? "")
            mqtt.willMessage?.retained = connection?.lastWill?.retained ?? mqtt.willMessage!.retained
            mqtt.willMessage?.qos = CocoaMQTTQOS(rawValue: UInt8(connection?.lastWill?.qos ?? 0))!

            mqtt.username = connection?.username
            mqtt.password = connection?.password
            
            mqtt.secureMQTT = connection?.secure ?? mqtt.secureMQTT
 */
        }
    }
    
    var mqtt: CocoaMQTT = CocoaMQTT(clientID: "")
    
    
    fileprivate init() {
        
    }
    
    static let shared = MQTTManager()
    
    
    
    var state: CocoaMQTTConnState {
        return mqtt.connState
    }
    
    
    func connect() {
        mqtt.connect()
    }
    
    func disconnect() {
        mqtt.disconnect()
    }
}


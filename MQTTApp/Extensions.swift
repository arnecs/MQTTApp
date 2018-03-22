//
//  Extensions.swift
//  MQTTApp
//
//  Created by Arne Christian Skarpnes on 20.03.2018.
//  Copyright © 2018 Arne Christian Skarpnes. All rights reserved.
//

import Foundation


extension MQTTConnection {
    
    override public var description: String {
        return self.name ?? "No name"
    }
}

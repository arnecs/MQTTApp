//
//  ValueTransformers.swift
//  Bind
//
//  Created by Arne Christian Skarpnes on 13.03.2018.
//  Copyright © 2018 Arne Christian Skarpnes. All rights reserved.
//

import Cocoa


class NumberTransformer: ValueTransformer {
    
    override class func transformedValueClass() -> AnyClass {
        return Int.self as! AnyClass
    }
    
    override class func allowsReverseTransformation() -> Bool {
        return true
    }
    
    override func transformedValue(_ value: Any?) -> Any? {
        if let v = value as? NSNumber {
            return "\(v)"
        }
        return nil
    }
    
    override func reverseTransformedValue(_ value: Any?) -> Any? {
        if let str = value as? NSString {
            return str.integerValue
        }
        return nil
    }
}

class BoolTransformer: ValueTransformer {
    
    override class func transformedValueClass() -> AnyClass {
        return Bool.self as! AnyClass
    }
    
    override class func allowsReverseTransformation() -> Bool {
        return true
    }
    
    override func transformedValue(_ value: Any?) -> Any? {
        if let b = value as? Bool {
            return b ? "Yes" : "No"
        }
        return nil
    }
    
    override func reverseTransformedValue(_ value: Any?) -> Any? {
        if let str = value as? NSString {
            return str == "Yes"
        }
        return nil
    }
}

class ActiveSubscribeTransformer: ValueTransformer {
    
    override class func transformedValueClass() -> AnyClass {
        return Bool.self as! AnyClass
    }
    
    override class func allowsReverseTransformation() -> Bool {
        return false
    }
    
    override func transformedValue(_ value: Any?) -> Any? {
        if let b = value as? Bool {
            return b ? "Unsubscribe" : "Subscribe"
        }
        return nil
    }
}

extension NSValueTransformerName {
    static let numberTransformerName = NSValueTransformerName(rawValue: "NumberTransformer")
    static let boolTransformerName = NSValueTransformerName(rawValue: "BoolTransformer")
    static let activeSubscribeTransformerName = NSValueTransformerName(rawValue: "ActiveSubscribeTransformer")

}



/*
class TransformerNSNumberToString: NSValueTransformer {
    
    override class func transformedValueClass() -> AnyClass { //What do I transform
        return NSNumber.self
    }
    
    override class func allowsReverseTransformation() -> Bool { //Can I transform back?
        returntrue
    }
    
    override func transformedValue(value: AnyObject?) -> AnyObject? { //Perform transformation
        guard let type = value as? NSNumber else { return nil }
        return type.stringValue
        
    }
    
    override func reverseTransformedValue(value: AnyObject?) -> AnyObject? { //Revert transformation
        guard let type = value as? NSString else { return nil }
        return NSNumber(double: type.doubleValue)
    }
}*/

//
//  String.swift
//  Swift Calculator
//
//  Created by Тимур on 14.06.14.
//  Copyright (c) 2014 SPbAU RAS. All rights reserved.
//
import Foundation

extension String {
    func __in(let left: String, let _ rigth: String) -> Bool {
        if (self.length != 1) {
            return false
        }
        let c = self.uppercaseString
        return left <= c && c <= rigth
    }
    
    func isAlpha() -> Bool {
        return __in("A", "Z")
    }
    
    func isDigit() -> Bool {
        return __in("0", "9")
    }
    
    var length: Int {
        return countElements(self)
    }
    
    var doubleValue: Double {
        return self.bridgeToObjectiveC().doubleValue
    }
}

extension Double {
    func format(f: String) -> String {
        return NSString(format: "%\(f)f", self)
    }
}

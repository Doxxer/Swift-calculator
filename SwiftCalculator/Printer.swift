//
//  Printer.swift
//  Swift Calculator
//
//  Created by Тимур on 20.06.14.
//  Copyright (c) 2014 SPbAU RAS. All rights reserved.
//

import Foundation

class Printer : PrinterVisitor {
    var program: [Expression]
    
    init(let _ program: [Expression]) {
        self.program = program
    }
    
    func print() {
        for expr in program {
            println("\(expr.accept(self))")
        }
    }
    
    func Visit(let a: UnaryFunction) -> String {
        return "\(a.function)(\(a.expr.accept(self)))"
    }
    func Visit(let a: BinaryFunction) -> String {
        switch a.function {
        case "+", "-", "*", "/", "INT_DIV", "%", "**":
            return "(\(a.left.accept(self)) \(a.function) \(a.right.accept(self)))"
        default:
            return "\(a.function)(\(a.left.accept(self)), \(a.right.accept(self)))"
        }
        
    }
    func Visit(let a: VariableDefinition) -> String {
        return "\(a.name) = \(a.expr.accept(self))"
    }
    func Visit(let a: Number) -> String {
        return "\(a.value)"
    }
    func Visit(let a: Variable) -> String {
        return "\(a.name)"
    }
}

//
//  AST.swift
//  Swift Calculator
//
//  Created by Тимур on 18.06.14.
//  Copyright (c) 2014 SPbAU RAS. All rights reserved.
//

protocol Expression {
    var lineNumber: Int { get }
    
    func accept(let v: EvaluatorVisitor) -> Double;
    
    func accept(let v: PrinterVisitor) -> String;
}

class Number : Expression {
    var lineNumber: Int
    var value: Double
    
    init(let value: Double, let lineNumber: Int) {
        self.value = value
        self.lineNumber = lineNumber
    }
    
    func accept(let v: EvaluatorVisitor) -> Double {
        return v.Visit(self)
    }
    
    func accept(let v: PrinterVisitor) -> String {
        return v.Visit(self)
    }
}

class Variable : Expression {
    var lineNumber: Int
    var name: String
    
    init(let name: String, let lineNumber: Int) {
        self.name = name
        self.lineNumber = lineNumber
    }
    
    func accept(let v: EvaluatorVisitor) -> Double {
        return v.Visit(self)
    }
    
    func accept(let v: PrinterVisitor) -> String {
        return v.Visit(self)
    }
}

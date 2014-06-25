//
//  BinaryExpression.swift
//  Swift Calculator
//
//  Created by Тимур on 19.06.14.
//  Copyright (c) 2014 SPbAU RAS. All rights reserved.
//

class BinaryFunction: Expression {
    var lineNumber: Int
    var left: Expression
    var right: Expression
    var function: String
    
    init(let _ function: String, var left: Expression, var right: Expression, lineNumber: Int) {
        self.function = function
        self.lineNumber = lineNumber
        self.left = left
        self.right = right
    }
    
    func accept(let v: EvaluatorVisitor) -> Double {
        return v.Visit(self)
    }
    
    func accept(let v: PrinterVisitor) -> String {
        return v.Visit(self)
    }
}
//
//  VariableDefinition.swift
//  Swift Calculator
//
//  Created by Тимур on 19.06.14.
//  Copyright (c) 2014 SPbAU RAS. All rights reserved.
//

class VariableDefinition : Expression {
    var lineNumber: Int
    var expr: Expression
    var name: String
    
    init(let variableName: String, let expr: Expression, let lineNumber: Int) {
        self.name = variableName
        self.lineNumber = lineNumber
        self.expr = expr
    }
    
    func accept(let v: EvaluatorVisitor) -> Double {
        return v.Visit(self)
    }
    
    func accept(let v: PrinterVisitor) -> String {
        return v.Visit(self)
    }
}
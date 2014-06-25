//
//  Visitor.swift
//  Swift Calculator
//
//  Created by Тимур on 18.06.14.
//  Copyright (c) 2014 SPbAU RAS. All rights reserved.
//

protocol EvaluatorVisitor {
    func Visit(let a: UnaryFunction) -> Double;
    func Visit(let a: BinaryFunction) -> Double;
    func Visit(let a: VariableDefinition) -> Double;
    func Visit(let a: Number) -> Double;
    func Visit(let a: Variable) -> Double;
}

protocol PrinterVisitor {
    func Visit(let a: UnaryFunction) -> String;
    func Visit(let a: BinaryFunction) -> String;
    func Visit(let a: VariableDefinition) -> String;
    func Visit(let a: Number) -> String;
    func Visit(let a: Variable) -> String;
}
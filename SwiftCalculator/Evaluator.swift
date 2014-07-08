//
//  Evaluator.swift
//  Swift Calculator
//
//  Created by Тимур on 25.06.14.
//  Copyright (c) 2014 SPbAU RAS. All rights reserved.
//

import Foundation

class Evaluator : EvaluatorVisitor {
    var program: [Expression]
    var variables: Dictionary<String, Double> = [:]
    let format: String = ".6"
    
    init(let _ program: [Expression]) {
        self.program = program
    }
    
    func eval() {
        var lastResult: Double? = nil
        for expr in program {
            lastResult = expr.accept(self)
        }
        var keys = Array(variables.keys)
        sort(&keys)
        for name in keys {
            println("\(name) = \(variables[name]!.format(format))")
        }
        if (lastResult) {
            println(lastResult!.format(format))
        }
    }
    
    func processError(let n: Double, let _ operation: String, let _ lineNumber: Int) {
        if !n.isZero && !n.isNormal {
            println("Error occured in \(operation) at line: \(lineNumber + 1)")
            exit(1)
        }
    }
    
    func Visit(let a: UnaryFunction) -> Double {
        let value = a.expr.accept(self)
        var result: Double
        switch a.function {
        case "sin":
            result = sin(value)
            processError(result, "sin", a.lineNumber)
        case "cos":
            result = cos(value)
            processError(result, "cos", a.lineNumber)
        case "tan":
            result = tan(value)
            processError(result, "tan", a.lineNumber)
        case "cot":
            result = 1.0 / tan(value)
            processError(result, "cot", a.lineNumber)
        case "abs":
            result = abs(value)
            processError(result, "abs", a.lineNumber)
        case "sqrt":
            result = sqrt(value)
            processError(result, "sqrt", a.lineNumber)
        default:
            println("Pattern matching failed at visit(UnaryFunction). Line: \(a.lineNumber)")
            exit(1)
        }
        return result
    }
    
    func Visit(let a: BinaryFunction) -> Double {        
        let lhs = a.left.accept(self)
        let rhs = a.right.accept(self)
        var result: Double
        switch a.function {
        case "+":
            result = lhs + rhs
            processError(result, "addition", a.lineNumber)
        case "-":
            result = lhs - rhs
            processError(result, "subtraction", a.lineNumber)
        case "*":
            result = lhs * rhs
            processError(result, "multiplication", a.lineNumber)
        case "/":
            result = lhs / rhs
            processError(result, "division", a.lineNumber)
        case "INT_DIV":
            result = round(lhs / rhs)
            processError(result, "integral division", a.lineNumber)
        case "%":
            result = lhs % rhs
            processError(result, "modulo", a.lineNumber)
        case "**":
            result = pow(lhs, rhs)
            processError(result, "pow", a.lineNumber)
        case "min":
            result = min(lhs, rhs)
            processError(result, "min", a.lineNumber)
        case "max":
            result = max(lhs, rhs)
            processError(result, "max", a.lineNumber)
        default:
            println("Pattern matching failed at visit(BinaryFunction). Line: \(a.lineNumber)")
            exit(1)
        }
        return result
    }
    
    func Visit(let a: Number) -> Double {
        return a.value
    }
    
    func Visit(let a: VariableDefinition) -> Double {
        if variables.indexForKey(a.name) {
            println("Error at line \(a.lineNumber + 1): variable \(a.name) has aleady been initialized.")
            exit(1)
        }
        var value = a.expr.accept(self)
        processError(value, "variable value calculating", a.lineNumber)
        variables[a.name] = value
        return value
    }
    
    func Visit(let a: Variable) -> Double {
        if !variables.indexForKey(a.name) {
            println("Error at line \(a.lineNumber + 1): unknown variable '\(a.name)'.")
            exit(1)
        }
        return variables[a.name]!
    }
}

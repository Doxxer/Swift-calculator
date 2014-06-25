//
//  Parser.swift
//  Swift Calculator
//
//  Created by Тимур on 18.06.14.
//  Copyright (c) 2014 SPbAU RAS. All rights reserved.
//

import Foundation

class Parser {
    let lexer: Lexer
    var errorCaptured: Bool = false
    
    init(_ sourceFileContent: String[]) {
        self.lexer = Lexer(sourceFileContent)
    }
    
    func parse() -> Expression[] {
        var content = Expression[]()
        while lexer.currentToken.type != .EOF {
            var instruction = parseInstruction()
            if instruction {
                content.append(instruction!)
                continue
            }
            if lexer.currentToken.type != .EOF {
                if !errorCaptured {
                    println("Parse error at line \(lexer.currentToken.lineNumber + 1)")
                }
                exit(1)
            }
        }
        return content
    }
    
    func parseInstruction() -> Expression? {
        while lexer.currentToken.type == .CR {
            lexer.peekCurrentAndSeekNextToken
        }
        var result = parseVaribaleDefinition()
        if !result {
            result = parseExpression()
        }
        return result
    }
    
    func parseUnaryBuiltinFunction() -> Expression? {
        var functionType = lexer.currentToken.type
        switch functionType {
        case .Sin, .Cos, .Tan, .Cot, .Abs, .Sqrt:
            lexer.peekCurrentAndSeekNextToken; // keyword <function_name>
            if lexer.currentToken.type != .OpeningBracket {
                captureError("( expected after builtin function")
                return nil
            }
            lexer.peekCurrentAndSeekNextToken // opening bracket
            
            var expr: Expression? = parseExpression()
            if !expr || lexer.currentToken.type != .ClosingBracket {
                captureError(") expected after calling builtin function")
                return nil
            }
            lexer.peekCurrentAndSeekNextToken // closing bracket
            
            return UnaryFunction(function: functionType.toRaw(), expr: expr!, lineNumber: lexer.currentToken.lineNumber);
        default:
            return nil;
        }
    }
    
    func parseBinaryBuilinFunction() -> Expression? {
        var functionType = lexer.currentToken.type
        switch functionType {
        case .Max, .Min:
            lexer.peekCurrentAndSeekNextToken; // keyword max/min
            if lexer.currentToken.type != .OpeningBracket {
                captureError("( expected after builtin function")
                return nil
            }
            lexer.peekCurrentAndSeekNextToken // opening bracket
            
            var expr1: Expression? = parseExpression()
            if !expr1 || lexer.currentToken.type != .Comma { return nil }
            lexer.peekCurrentAndSeekNextToken // comma
            
            var expr2: Expression? = parseExpression()
            if !expr2 || lexer.currentToken.type != .ClosingBracket {
                captureError(") expected after calling builtin function")
                return nil
            }
            lexer.peekCurrentAndSeekNextToken // closing bracket
            
            return BinaryFunction(functionType.toRaw(),
                left: expr1!,
                right: expr2!,
                lineNumber: lexer.currentToken.lineNumber);
        default:
            return nil;
        }
    }
    
    func parseVaribaleDefinition() -> Expression? {
        if lexer.currentToken.type != .Identifier { return nil }
        let variableName: String = lexer.peekCurrentAndSeekNextToken.name
        
        if lexer.currentToken.type != .Equal { return nil }
        lexer.peekCurrentAndSeekNextToken
        var expr: Expression? = parseExpression()
        if !expr { return nil }
        
        return VariableDefinition(variableName: variableName, expr: expr!, lineNumber: lexer.currentToken.lineNumber)
    }
    
    func parseExpression() -> Expression? {
        return parseExpression(currentLevelPriorityFunction: Token.IsLowPriority, nextLevelParser: parseMediumPriority)
    }
    
    func parseMediumPriority() -> Expression? {
        return parseExpression(currentLevelPriorityFunction: Token.IsMediumPriority, nextLevelParser: parseHighProirity)
    }
    
    func parseHighProirity() -> Expression? {
        return parseExpression(currentLevelPriorityFunction: Token.IsHighPriority, nextLevelParser: parseValue)
    }
    
    func parseExpression(#currentLevelPriorityFunction: (Token) -> Bool, nextLevelParser: () -> Expression?) -> Expression? {
        var lhs: Expression? = nextLevelParser()
        if !lhs { return nil }
        
        if !currentLevelPriorityFunction(lexer.currentToken) {
            return lhs!
        }
        
        var res: Expression? = lhs
        while currentLevelPriorityFunction(lexer.currentToken) {
            var operation = lexer.peekCurrentAndSeekNextToken.type
            let rhs: Expression? = nextLevelParser()
            if !rhs { return nil }
            res = BinaryFunction(operation.toRaw(),
                left: lhs!,
                right: rhs!,
                lineNumber: lexer.currentToken.lineNumber)
            lhs = res
        }
        return res
    }
    
    func parseValue() -> Expression? {
        if lexer.currentToken.type == .Minus || lexer.currentToken.type == .Plus {
            var op = lexer.peekCurrentAndSeekNextToken
            let expr: Expression? = parseValue()
            if !expr { return nil }
            
            return BinaryFunction(op.type.toRaw(),
                left: Number(value: 0, lineNumber: 0),
                right: expr!,
                lineNumber: lexer.currentToken.lineNumber)
        }
        
        if lexer.currentToken.type == .OpeningBracket {
            lexer.peekCurrentAndSeekNextToken
            let expr: Expression? = parseExpression()
            if !expr || lexer.peekCurrentAndSeekNextToken.type != .ClosingBracket { return nil }
            return expr!
        }
        
        var expr = parseNumber()
        if !expr { expr = parseIdentifier() }
        return expr;
    }
    
    func parseNumber() -> Expression? {
        switch lexer.currentToken.type {
        case .Number:
            return Number(value: lexer.peekCurrentAndSeekNextToken.name.doubleValue, lineNumber: lexer.currentToken.lineNumber)
        case .PI:
            lexer.peekCurrentAndSeekNextToken
            return Number(value: 3.141592653589792, lineNumber: lexer.currentToken.lineNumber)
        case .E:
            lexer.peekCurrentAndSeekNextToken
            return Number(value: 2.718281828459045, lineNumber: lexer.currentToken.lineNumber)
        default:
            return nil
        }
    }
    
    func parseIdentifier() -> Expression? {
        switch lexer.currentToken.type {
        case .Sin, .Cos, .Tan, .Cot, .Abs, .Min, .Max, .Sqrt:
            var function = parseBinaryBuilinFunction()
            if !function {
                function = parseUnaryBuiltinFunction()
            }
            return function;
        case .Identifier:
            let name: String = lexer.peekCurrentAndSeekNextToken.name
            return Variable(name: name, lineNumber: lexer.currentToken.lineNumber)
        default:
            return nil
        }
    }
    
    func captureError(let message: String) {
        println("Error at line \(lexer.currentToken.lineNumber + 1): \(message)")
        errorCaptured = true
    }
}

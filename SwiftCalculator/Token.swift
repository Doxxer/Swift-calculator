//
//  Token.swift
//  Swift Calculator
//
//  Created by Тимур on 13.06.14.
//  Copyright (c) 2014 SPbAU RAS. All rights reserved.
//

struct Token {
    enum TokenType : String {
        case OpeningBracket = "OpeningBracket", ClosingBracket = "ClosingBracket", Comma = "Comma"
        case Plus = "+", Minus = "-", Mult = "*", Div = "/", Equal = "=", IntegralDiv = "INT_DIV", Mod = "%", Pow = "**"
        case Sin = "sin", Cos = "cos", Tan = "tan", Cot = "cot", Abs = "abs", Min = "min", Max = "max", Sqrt = "sqrt", Identifier = "id"
        case PI = "PI", E = "EULER", Number = "number"
        case CR = "CR", EOF = "EOF", Unknown = "UNKNOWN"
    }
    
    static let EOFToken = Token(type: .EOF, name: "eof", lineNumber: 0)
    
    static func IsHighPriority(let token: Token) -> Bool {
        switch token.type {
        case .Pow:
            return true
        default:
            return false
        }
    }
    
    static func IsMediumPriority(let token: Token) -> Bool {
        switch token.type {
        case .Div, .Mult, .IntegralDiv, .Mod:
            return true
        default:
            return false
        }
    }
    
    static func IsLowPriority(let token: Token) -> Bool {
        switch token.type {
        case .Plus, .Minus:
            return true
        default:
            return false
        }
    }
    
    var type: TokenType = .Unknown
    var name: String = ""
    let lineNumber: Int = 0
}
//
//  Lexer.swift
//  Swift Calculator
//
//  Created by Тимур on 13.06.14.
//  Copyright (c) 2014 SPbAU RAS. All rights reserved.
//

import Foundation

class Lexer {
    var tokens: Token[]
    var tokenCurrentPosition: Int = 0
    
    init(_ content: String[]) {
        tokens = []
        for (lineNumber, line) in enumerate(content) {
            self.parseLine(line, lineNumber)
        }
        self.tokens += Token.EOFToken
    }
    
    var currentToken: Token {
        return tokenCurrentPosition < tokens.count ? tokens[tokenCurrentPosition] : Token.EOFToken
    }
    
    var peekCurrentAndSeekNextToken: Token {
        return tokenCurrentPosition < tokens.count ? tokens[tokenCurrentPosition++] : Token.EOFToken
    }
    
    
    func parseLine(line: String, _ lineNumber: Int) {
        for var index = line.startIndex, counter = 0; index != line.endIndex; index = index.succ(), counter++ {
            if line[index] == " " { continue; }
            
            var currentToken: Token = Token(type: Token.TokenType.Unknown, name: "unknown", lineNumber: lineNumber)
            
            parseOperator(&index, &currentToken, line)
            if currentToken.type == Token.TokenType.Unknown {
                parseIdentifier(&index, &currentToken, line)
            }
            if currentToken.type == Token.TokenType.Unknown {
                parseNumber(&index, &currentToken, line)
            }
            if currentToken.type != Token.TokenType.Unknown {
                self.tokens += currentToken
            } else {
                println("Unknown token at line \(lineNumber + 1), index \(counter + 1)")
                exit(1)
            }
        }
        self.tokens += Token(type: Token.TokenType.CR, name: "cr", lineNumber: lineNumber)
    }
    
    func parseOperator(inout index: String.Index, inout _ token: Token, let _ line: String) {
        let char = line[index]
        switch char {
        case "+":   token.type = .Plus;
        case "-":   token.type = .Minus;
        case "/":   token.type = .Div;
        case "\\":  token.type = .IntegralDiv;
        case "%":   token.type = .Mod;
        case "(":   token.type = .OpeningBracket;
        case ")":   token.type = .ClosingBracket;
        case ",":   token.type = .Comma;
        case "=":   token.type = .Equal;
        case "*":
            token.type = .Mult
            if index != line.endIndex && line[index.succ()] == "*" {
                token.type = .Pow; index = index.succ()
            }
        default:    break
        }
    }
    
    func parseIdentifier(inout index: String.Index, inout _ token: Token, let _ line: String) {
        let char: String = String(line[index])
        if !char.isAlpha() {
            return
        }
        
        var identifier: String = ""
        
        while index != line.endIndex && (String(line[index]).isAlpha() || String(line[index]).isDigit()) {
            identifier += line[index]
            index = index.succ()
        }
        index = index.pred()
        switch identifier {
        case "sin": token.type = .Sin
        case "cos": token.type = .Cos
        case "tan": token.type = .Tan
        case "cot": token.type = .Cot
        case "abs": token.type = .Abs
        case "min": token.type = .Min
        case "max": token.type = .Max
        case "sqrt": token.type = .Sqrt
        case "PI": token.type = .PI
        case "E": token.type = .E
        default:
            token.type = .Identifier
            token.name = identifier
        }
    }
    
    func parseNumber(inout index: String.Index, inout _ token: Token, let _ line: String) {
        let char: String = String(line[index])
        if !char.isDigit() {
            return
        }
        
        var number: String = ""
        
        while index != line.endIndex && String(line[index]).isDigit() {
            number += line[index]
            index = index.succ()
        }
        
        if index != line.endIndex && String(line[index]) == "." {
            index = index.succ()
            if index == line.endIndex || !String(line[index]).isDigit() { return }
            number += "."
            while index != line.endIndex && String(line[index]).isDigit() {
                number += line[index]
                index = index.succ()
            }
        }
        
        index = index.pred()
        token.type = .Number
        token.name = number
    }
}
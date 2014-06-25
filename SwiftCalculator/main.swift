import Foundation

if Process.arguments.count != 2 {
    println("Usage: \(Process.arguments[0]) <source filename>")
    exit(1)
}

let sourceFileName = Process.arguments[1]
let content = String.stringWithContentsOfFile(sourceFileName, encoding: NSUTF8StringEncoding)

if !content {
    println("File \(sourceFileName) not found")
    exit(1)
}

let sourceFileContent = content!.componentsSeparatedByString("\n").filter { !$0.isEmpty }

let program = Parser(sourceFileContent).parse()

/// Printer(program).print()
/// println("---------------")

Evaluator(program).eval()
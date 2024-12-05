// The Swift Programming Language
// https://docs.swift.org/swift-book
// 
// Swift Argument Parser
// https://swiftpackageindex.com/apple/swift-argument-parser/documentation

import ArgumentParser

// Part 1:
// Attempts: 
// 4286 too low
// 7198 correct!
// Part 2:
// Attempts:


@main
struct Day05: ParsableCommand {

    @Argument(help: "The input file for day 5.")
    var filename: String

    mutating func run() throws {
        let input = try! String(contentsOfFile: self.filename, encoding: .utf8)
        var (updates, rules) = input.parseAsUpdateAndRules()
        // print(rules)
        let splitIndex = updates.partition { $0.isValid(with: rules) }
        let invalidUpdates = updates[..<splitIndex].map { $0 }
        let validUpdates = updates[splitIndex...].map { $0 }
        let _ = invalidUpdates
        print("Number of valid updates: \(validUpdates.count)")
        print("Number of invalid updates: \(invalidUpdates.count)")
        let midPageSum = validUpdates.reduce(0) { $0 + $1.middlePage }
        print("Sum of middle pages of valid updates: \(midPageSum)")
    }
}

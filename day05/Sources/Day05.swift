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
// 4230 correct!

@main
struct Day05: ParsableCommand {
    static let configuration = CommandConfiguration(
        abstract: "A utility for solving the Day05 puzzle of Advent of Code 2024",
        subcommands: [Day05Part1.self, Day05Part2.self]
    )

}

struct Day05Part1: ParsableCommand, FileInput {
    static let configuration = CommandConfiguration(
        commandName: "part1",
        abstract: "Solve the 1st part of the Day05 puzzle"
    )

    @Option(name: [.short, .long], help: "The input file to use for the puzzle")
    var filename: String

    mutating func run() throws {
        var (updates, rules) = parseAsUpdateAndRules()
        let partitioned = updates.partitionValidAndInvalid(rules: rules)
        let validUpdates = partitioned.validUpdates
        let invalidUpdates = partitioned.invalidUpdates
        print("Number of valid updates: \(validUpdates.count)")
        print("Number of invalid updates: \(invalidUpdates.count)")
        let midPageSum = validUpdates.reduce(0) { $0 + $1.middlePage }
        print("Sum of middle pages of valid updates: \(midPageSum)")
    }
}


struct Day05Part2: ParsableCommand, FileInput {
    static let configuration = CommandConfiguration(
        commandName: "part2",
        abstract: "Solve the 2nd part of the Day05 puzzle"
    )

    @Option(name: [.short, .long], help: "The input file to use for the puzzle")
    var filename: String

    mutating func run() throws {
        var (updates, rules) = parseAsUpdateAndRules()
        let partitioned = updates.partitionValidAndInvalid(rules: rules)
        let invalidUpdates = partitioned.invalidUpdates
        print("Number of invalid updates: \(invalidUpdates.count)")
        let correctedUpdates = invalidUpdates.map { $0.fix(with: rules) }
        let midPageSum = correctedUpdates.reduce(0) { $0 + $1.middlePage }
        print("Sum of middle pages of corrected updates: \(midPageSum)")
        
    }
}

protocol FileInput {
    var filename: String { get set }
}

extension FileInput {
    func getInput() -> String {
        return try! String(contentsOfFile: self.filename, encoding: .utf8)
    }

    func parseAsUpdateAndRules() -> ([Update], [Int:PrintOrderRule]) {
        return self.getInput().parseAsUpdateAndRules()
    }
}


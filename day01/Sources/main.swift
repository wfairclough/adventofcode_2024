// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation
import SwiftParsec

// Example input line: "23523    34423"

struct Record {
    let a: Int
    let b: Int

    init(_ a: Int, _ b: Int) {
        self.a = a
        self.b = b
    }

    static func fromArray(_ array: [Int]) -> Record {
        return Record(array[0], array[1])
    }

    static func parse(_ input: String) throws -> [Record] {
        let newLine = StringParser.newLine
        let spaces = StringParser.spaces
        let decimalDigit = StringParser.decimalDigit
        let decimalParser = { Int(String($0))! } <^> decimalDigit.many1
        let record = GenericParser.lift4(
            { a, _, b, _ in Record(a, b)},
            parser1: decimalParser,
            parser2: spaces,
            parser3: decimalParser,
            parser4: newLine.optional
        )
        let records = record.many1
        
        return try records.run(sourceName: "", input: input)
    }
}

func main() {
    partA()
    partB()
}

let filePath = "/Users/will/Development/github/wfairclough/adventofcode_2024/day01/input.txt"

func partA() {
    do {
        let content = try String(contentsOfFile: filePath, encoding: .utf8)
        let records = try Record.parse(content)
        let sortedA = records.sorted { $0.a < $1.a }.map { $0.a }
        let sortedB = records.sorted { $0.b < $1.b }.map { $0.b }
        let zipped = zip(sortedA, sortedB)
        let diffed = zipped.map { abs($0.0 - $0.1) }
        let sum = diffed.reduce(0, +)
        print(sum)
    } catch {
        // Handle any errors
        print("Error parsing: \(error.localizedDescription)")
        print(error)
    }
}


func partB() {
    do {
        let content = try String(contentsOfFile: filePath, encoding: .utf8)
        let records = try Record.parse(content)
        let sortedA = records.map { $0.a }
        let similarityScores = records.reduce(into: [Int: Int]()) { (result, record) in
            result[record.b, default: 0] += 1
        }
        
        let result = sortedA.reduce(0) { acc, a in
            let bOccurrences = similarityScores[a]

            return acc + (a * (bOccurrences ?? 0))
        }
        print(result)
        
    } catch {
        // Handle any errors
        print("Error parsing: \(error.localizedDescription)")
        print(error)
    }
}

main()

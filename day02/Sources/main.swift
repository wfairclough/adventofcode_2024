// The Swift Programming Language
// https://docs.swift.org/swift-book

import SwiftParsec

let sampleInput = """
7 6 4 2 1
1 2 7 8 9
9 7 6 2 1
1 3 2 4 5
8 6 4 4 1
1 3 6 7 9
""".trimmingCharacters(in: .whitespacesAndNewlines)

extension Array {
    subscript(safe index: Int) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

struct Report {
    let levels: [Int]
    var isSafe: Bool {
        var isIncreasing: Bool?
        for i in 0..<levels.count {
            guard let a = levels[safe: i] else { continue }
            guard let b = levels[safe: i + 1] else { continue }
            let diff = b - a
            if diff == 0 {
                return false
            }
            let currIsIncreasing = diff > 0
            if let isIncreasing = isIncreasing, isIncreasing != currIsIncreasing {
                return false
            }
            isIncreasing = currIsIncreasing
            if abs(diff) > 3 {
                return false
            }
        }
        return true
    }
}

let newLine = StringParser.newLine
let space = StringParser.character(" ")
let number = { Int(String($0)) ?? 0 } <^> StringParser.decimalDigit.many1
let reportParser = GenericParser.lift2(
    { nums, _ in Report(levels: nums) },
    parser1: number.separatedBy1(space),
    parser2: newLine.optional
)
let reportsParser = reportParser.many1


func main() {
    let file = "/Users/will/Development/github/wfairclough/adventofcode_2024/day02/input.txt"
    let input = try! String(contentsOfFile: file)
    // let input = sampleInput
    let reports = try! reportsParser.run(sourceName: "", input: input)
    partA(reports)
    partB(reports)
}

func partA(_ reports: [Report]) {
    let safeReports = reports.filter { $0.isSafe }.count
    print("Safe reports: \(safeReports)")
}

func partB(_ reports: [Report]) {
    print("Hello, Part B")
}

main()

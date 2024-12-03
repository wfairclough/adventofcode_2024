// The Swift Programming Language
// https://docs.swift.org/swift-book

// False attempts:
// 519
// 530
// 531

import SwiftParsec

let sampleInput = """
7 6 4 2 1
1 2 7 8 9
9 7 6 2 1
1 3 2 4 5
8 6 4 4 1
1 3 6 7 9
8 11 13 14 15 18 17
""".trimmingCharacters(in: .whitespacesAndNewlines)

extension Array {
    subscript(safe index: Int) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }

    func removing(at index: Int) -> [Element] {
        var copy = self
        copy.remove(at: index)
        return copy
    }

    func removingLast() -> [Element] {
        var copy = self
        copy.removeLast()
        return copy
    }
}

enum Dir {
    case inc
    case dec
    case none

    static func from(integer: Int) -> Dir {
        if integer > 0 {
            return .inc
        } else if integer < 0 {
            return .dec
        } else {
            return .none
        }
    }
}

enum Mods {
    case none
    case removed(Int, Int)
}

struct Report {
    let levels: [Int]
    var isSafe: (Bool, Mods) {
        var dir: Dir = .none
        let checkLevels = { (levels: [Int]) -> Bool in
            for (i, a) in levels.enumerated() {
                guard let b = levels[safe: i + 1] else { continue }
                let diff = b - a
                switch (diff) {
                case 1, 2, 3, -1, -2, -3:
                    break
                default:
                    return false
                }
                let currDir = Dir.from(integer: diff)
                switch (dir, currDir) {
                case (.none, .none):
                    fallthrough
                case (.inc, .dec):
                    fallthrough
                case (.dec, .inc):
                    fallthrough
                case (.inc, .none):
                    fallthrough
                case (.dec, .none):
                    print("Invalid direction change: .\(currDir) \(a) -> \(b) when prev was .\(dir) in \(levels)")
                    return false
                case (.none, let d) where d != .none:
                    dir = d
                default:
                    break
                }
            }
            return true
        }
        let safe = checkLevels(levels)
        guard safe else {
            for i in 0..<levels.count {
                let newLevels = levels.removing(at: i)
                if checkLevels(newLevels) {
                    print("Fixed by removing \(i):\(levels[i]) in \(levels)")
                    return (true, .removed(i, levels[i]))
                }
            }
            print("Could not fix: \(levels)")
            return (false, .none)
        }
        return (safe, .none)
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
//    let input = sampleInput
    let reports = try! reportsParser.run(sourceName: "", input: input)
    partA(reports)
    partB(reports)
}

func partA(_ reports: [Report]) {
    let safeReports = reports.map { ($0, $0.isSafe) }.filter { $0.1.0 }
    print("Safe reports:\n \(safeReports.map { "\($0)" }.joined(separator: "\n"))")
    print("Safe report count: \(safeReports.count)")
}

func partB(_ reports: [Report]) {
    print("Hello, Part B")
}

main()



// The Swift Programming Language
// https://docs.swift.org/swift-book

// False attempts:
// 519
// 530
// 531

// Correct answer:
// Part 1: 490
// Part 2: 536

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

enum SafeCheckError: Error {
    case unsafeLevel(Int, Int)
    case invalidDirChange(Dir, Dir)
}

struct Report {
    let levels: [Int]
    func isSafe() -> Result<Bool, SafeCheckError> {
        var dir: Dir = .none
        for (i, a) in levels.enumerated() {
            guard let b = levels[safe: i + 1] else { continue }
            let diff = b - a
            switch (diff) {
            case 1, 2, 3, -1, -2, -3:
                break
            default:
                return .failure(.unsafeLevel(i, diff))
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
                return .failure(.invalidDirChange(dir, currDir))
            case (.none, let d) where d != .none:
                dir = d
            default:
                break
            }
        }
        return .success(true)
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
    let file = CommandLine.arguments[1]
    let input = try! String(contentsOfFile: file)
//    let input = sampleInput
    let reports = try! reportsParser.run(sourceName: "", input: input)
    part1(reports)
    part2(reports)
}

func part1(_ reports: [Report]) {
    let (safeReports, unsafeReports) = reports.reduce(into: ([Report](), [Report]())) { (result, report) in
        switch report.isSafe() {
        case .success(true):
            result.0.append(report)
        case .failure(let error):
            result.1.append(report)
            print("Error: \(error) in \(report)")
        case .success(false):
            break
        }
    }
    print("Part 1")
    print("SAFE REPORTS")
    print("\(safeReports.map { "\($0)" }.joined(separator: "\n"))")
    print("===========================================================================")
    print("UNSAFE REPORTS")
    print("===========================================================================")
    print("\(unsafeReports.map { "\($0)" }.joined(separator: "\n"))")
    print("===========================================================================")
    print("Safe report count: \(safeReports.count)")
}

func part2(_ reports: [Report]) {
    print("\n\n\n\n")
    let (safeReports, unsafeReports) = reports.reduce(into: ([Report](), [Report]())) { (result, report) in
        switch report.isSafe() {
        case .success(true):
            result.0.append(report)
        case .failure(let error):
            result.1.append(report)
            print("Error: \(error) in \(report)")
        case .success(false):
            break
        }
    }
    let fixedReports = unsafeReports.compactMap { report -> Report? in
        for i in 0..<report.levels.count {
            let newLevels = report.levels.removing(at: i)
            let newReport = Report(levels: newLevels)
            switch newReport.isSafe() {
            case .success(true):
                return newReport
            case .failure(let error):
                print("Error: \(error) in \(newReport)")
            case .success(false):
                break
            }
        }
        return nil
    }
    print("Part 2")
    print("SAFE REPORTS")
    print("\(safeReports.map { "\($0)" }.joined(separator: "\n"))")
    print("===========================================================================")
    print("UNSAFE REPORTS")
    print("===========================================================================")
    print("\(unsafeReports.map { "\($0)" }.joined(separator: "\n"))")
    print("===========================================================================")
    print("FIXED REPORTS")
    print("===========================================================================")
    print("\(fixedReports.map { "\($0)" }.joined(separator: "\n"))")
    print("===========================================================================")
    print("Safe report count: \(safeReports.count)")
    print("Fixed reports count: \(fixedReports.count)")
    print("Total Safe reports count: \(safeReports.count + fixedReports.count)")
}

main()



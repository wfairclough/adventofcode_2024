// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation

// Part 1:
// False: 185906358
// Correct: 185797128
// Part 2:
// Correct: 89798695


extension String.SubSequence {
    func dropLastUntil(firstOccuranceOf char: Character) -> Self.SubSequence {
        guard let index = self.firstIndex(of: char) else {
            return self
        }
        return self[..<index]
    }
}

enum MemoryValue {
    case mul(Int, Int, String)
    case doit(String)
    case dont(String)
    case garbage(String)

    func product() -> Int {
        switch self {
            case .mul(let lhs, let rhs, _):
                return lhs * rhs
            default:
                return 0
        }
    }
}

struct MemorySlidingWindow: Sequence, IteratorProtocol {
    private let characters: [Character]
    private let windowSize: Int
    private var currentIndex: Int = 0

    init(string: String, windowSize: Int) {
        self.characters = Array(string)
        self.windowSize = windowSize
    }

    mutating func next() -> MemoryValue? {
        while currentIndex + windowSize <= characters.count {
            let window = String(characters[currentIndex..<currentIndex + windowSize])
            currentIndex += 1
            switch toMemoryValue(window: window) {
                case .some(let memVal):
                    return memVal
                default:
                   return .garbage(window)
            }
        }
        // if the window is less than the window size we should scan with the remaining characters
        while currentIndex < characters.count {
            let window = String(characters[currentIndex..<characters.count])
            currentIndex += 1
            switch toMemoryValue(window: window) {
                case .some(let memVal):
                    return memVal
                default:
                   return .garbage(window)
            }
        }
        return nil
    }

    private func toMemoryValue(window: String) -> MemoryValue? {
        if window.starts(with: "mul(") {
            if !window.dropFirst(4).contains(")") {
                return nil
            }
            let values = window
                .dropFirst(4)
                .dropLastUntil(firstOccuranceOf: ")")
                .split(separator: ",")
                .map { Int($0) }
            guard let lhs = values[0], let rhs = values[1] else {
                return nil
            }
            guard lhs <= 999, rhs <= 999 else {
                return nil
            }
            return .mul(lhs, rhs, window)
        } else if window.starts(with: "do()") {
            return .doit(window)
        } else if window.starts(with: "don't()") {
            return .dont(window)
        }
        return nil
    }
}

let sampleInput = "xmul(2,4)%&mul[3,7]!@^do_not_mul(5,5)+mul(32,64]then(mul(11,8)mul(8,5))"

let file = CommandLine.arguments[1]
let input = try! String(contentsOfFile: file)
// let input = sampleInput
let windowSize = 12

let memoryScanner = MemorySlidingWindow(
    string: input,
    windowSize: windowSize
)

var sum = 0
var valid: [MemoryValue] = []

enum SumEnabled {
    case enabled
    case disabled
}

var sumEnabled: SumEnabled = .enabled

for memVal in memoryScanner {
    switch memVal {
        case .mul(let lhs, let rhs, let win):
            print("valid: \(lhs) * \(rhs) = \(lhs * rhs) for \(win)")
            if sumEnabled == .enabled {
                valid.append(memVal)
            }
        case .doit(let win):
            print("doit: \(win)")
            sumEnabled = .enabled
        case .dont(let win):
            print("dont: \(win)")
            sumEnabled = .disabled
        default:
            print("\(memVal)")
            break;
    }
    sum += memVal.product()
}

print("Sum: \(valid.reduce(0) { $0 + $1.product() })")



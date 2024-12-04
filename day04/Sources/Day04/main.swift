// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation

/*
Attempts:
Part1:
Correct: 2578

Part2:
Failed: 21814 - Too High
*/

let file = CommandLine.arguments[1]
let input = try String(contentsOfFile: file)

let grid = buildGrid(input)

print("Part 1: \(grid.count(occuranceseOf: "XMAS"))")


let xMasMasks: [Grid] = [
    [
        ["M", ".", "M"],
        [".", "A", "."],
        ["S", ".", "S"],
    ],
    [
        ["S", ".", "S"],
        [".", "A", "."],
        ["M", ".", "M"],
    ],
    [
        ["M", ".", "S"],
        [".", "A", "."],
        ["M", ".", "S"],
    ],
    [
        ["S", ".", "M"],
        [".", "A", "."],
        ["S", ".", "M"],
    ],
]
var count = 0
for mask in xMasMasks {
    count += grid.count(occurancesOfMask: mask)
}
print("Part 2: \(count)")



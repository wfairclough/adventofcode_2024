// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation

let file = CommandLine.arguments[1]
let input = try String(contentsOfFile: file)

let grid = buildGrid(input)

print(grid)
print(grid.count(occuranceseOf: "XMAS"))


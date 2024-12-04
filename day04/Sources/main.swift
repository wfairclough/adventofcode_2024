// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation

typealias Grid = [[Character]]

typealias Position = (x: Int, y: Int)

extension Grid {
    func isInside(_ position: Position) -> Bool {
        return position.y >= 0 && position.y < count && position.x >= 0 && position.x < self[position.y].count
    }

    func get(_ position: Position) -> Character {
        return self[position.y][position.x]
    }

    func count(occuranceseOf word: String) -> Int {
        var count = 0
        for y in 0..<count {
            for x in 0..<self[y].count {
                for dir in directions {
                    let wordChars = word.map { $0 }
                    for i in 0..<word.count {
                        let position: Position = (x: x + (i * dir.x), y: y + (dir.y * i))
                        if !isInside(position) || get(position) != wordChars[i] {
                            break
                        }
                        if i == (word.count - 1) {
                            count += 1
                        }
                    }
                }
            }
        }
        return count
    }
}

let directions: [Position] = [
    (0, -1), // up
    (1, 0), // right
    (0, 1), // down
    (-1, 0), // left
    (1, -1), // up-right
    (1, 1), // down-right
    (-1, 1), // down-left
    (-1, -1) // up-left
]

func buildGrid(_ input: String) -> Grid {
    return input.components(separatedBy: "\n").map { $0.map { $0 } }.filter { !$0.isEmpty }
}

let file = CommandLine.arguments[1]
let input = try String(contentsOfFile: file)

let grid = buildGrid(input)

print(grid)
print(grid.count(occuranceseOf: "XMAS"))


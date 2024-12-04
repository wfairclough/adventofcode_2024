import Foundation

public typealias Grid = [[Character]]

public typealias Position = (x: Int, y: Int)

public extension Grid {
    func isInBounds(_ position: Position) -> Bool {
        return position.y >= 0 && position.y < count && position.x >= 0 && position.x < self[position.y].count
    }

    func get(_ position: Position) -> Character {
        return self[position.y][position.x]
    }

    func count(occuranceseOf word: String) -> Int {
        print("count word: \(word)")
        var count = 0
        for y in 0..<self.count {
            for x in 0..<self[y].count {
                for dir in directions {
                    let wordChars = word.map { $0 }
                    for i in 0..<word.count {
                        let position: Position = (x: x + (i * dir.x), y: y + (dir.y * i))
                        let isInside = isInBounds(position)
                        if !isInside {
                            break
                        }
                        let charAtPosition = get(position)
                        let charInWord = wordChars[i]
                        if charAtPosition != charInWord {
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

    func count(occurancesOfMask mask: Grid, maskSize: Int = 3) -> Int {
        var count = 0
        for y in 0..<(self.count - maskSize + 1) {
            for x in 0..<(self[y].count - maskSize + 1) {
                mask: for yMask in 0..<mask.count {
                    for xMask in 0..<mask[yMask].count {
                        let position: Position = (x: x + xMask, y: y + yMask)
                        let charAtPosition = get(position)
                        let charInMask = mask.get((x: xMask, y: yMask))
                        if charInMask == "." {
                            continue
                        }
                        if charAtPosition != charInMask {
                            break mask
                        }
                        if yMask == (mask.count - 1) && xMask == (mask[yMask].count - 1) {
                            count += 1
                            print("\(mask) found at \(position)")
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

public func buildGrid(_ input: String) -> Grid {
    return input.components(separatedBy: "\n").map { $0.map { $0 } }.filter { !$0.isEmpty }
}


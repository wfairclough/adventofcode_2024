// The Swift Programming Language
// https://docs.swift.org/swift-book
//
// Swift Argument Parser
// https://swiftpackageindex.com/apple/swift-argument-parser/documentation

import ArgumentParser

@main
struct Day06: ParsableCommand {
    static let configuration = CommandConfiguration(
        abstract: "A utility for solving the Day06 puzzle of Advent of Code 2024",
        subcommands: [Day06Part1.self, Day06Part2.self]
    )
}

struct Day06Part1: ParsableCommand, FileInput {
    static let configuration = CommandConfiguration(
        commandName: "part1",
        abstract: "Solve the first part of the Day06 puzzle"
    )

    @Option(name: [.short, .long], help: "The input file path")
    var filename: String

    mutating func run() throws {
        let input = getInput()
        let grid = GridParser().parse(input)
        var map = Map(grid: grid)
        print(map)

        loop: while true {
            let result = map.moveGuard()
            switch result {
            case .success(let position):
                print("Guard moved to \(position)")
            case .failure(let error):
                print("Error: \(error)")
                break loop
            }
        }
        print(map)
    }
}

struct Day06Part2: ParsableCommand, FileInput {
    static let configuration = CommandConfiguration(
        commandName: "part2",
        abstract: "Solve the second part of the Day06 puzzle"
    )

    @Option(name: [.short, .long], help: "The input file path")
    var filename: String

    mutating func run() throws {
    }
}

typealias Position = (row: Int, column: Int)

enum Direction {
    case north
    case south
    case east
    case west

    var symbol: Character {
        switch self {
        case .north:
            return "^"
        case .south:
            return "v"
        case .east:
            return ">"
        case .west:
            return "<"
        }
    }
}

struct Guard {
    var position: Position
    var direction: Direction

    mutating func move() -> Position {
        switch direction {
        case .north:
            position.row -= 1
        case .south:
            position.row += 1
        case .east:
            position.column += 1
        case .west:
            position.column -= 1
        }
        return position
    }
}

enum GuardPositionError: Error {
    case noGuardPosition
    case outOfBounds(position: Position)
}

protocol MapGrid {
    var grid: Grid { get set }
    var guardDirection: Direction { get set }
}

extension MapGrid {
    var rows: Int {
        grid.count
    }
    var columns: Int {
        grid.first?.count ?? 0
    }
    var guardVisitedPositionCount: Int {
        grid.flatMap { $0 }.filter { $0 == "X" }.count
    }

    var guardPosition: Position? {
        for row in 0..<rows {
            for column in 0..<columns {
                if grid[row][column] == "^" || grid[row][column] == "v" || grid[row][column] == "<"
                    || grid[row][column] == ">"
                {
                    return (row, column)
                }
            }
        }
        return nil
    }

    func isObjectAt(_ position: Position) -> Bool {
        guard let row = grid[safe: position.row] else { return false }
        guard let column = row[safe: position.column] else { return false }
        return column == "#"
    }

    func isWallAt(_ position: Position) -> Bool {
        guard let row = grid[safe: position.row] else { return true }
        guard row[safe: position.column] != nil else { return true }
        if position.row > rows || position.column > columns {
            return true
        }
        return false
    }

    func isGuardAt(_ position: Position) -> Bool {
        guard let row = grid[safe: position.row] else { return false }
        guard let column = row[safe: position.column] else { return false }
        return column == "^" || column == "v" || column == "<" || column == ">"
    }

    mutating func moveGuard() -> Result<Position, GuardPositionError> {
        guard let guardPosition = guardPosition else { return .failure(.noGuardPosition) }
        var gd = Guard(position: guardPosition, direction: guardDirection)
        let pos = gd.move()
        if isObjectAt(pos) {
            guardDirection =
                guardDirection == .north
                ? .east
                : guardDirection == .east ? .south : guardDirection == .south ? .west : .north
            gd.direction = guardDirection
            gd.position = guardPosition
            let newPos = gd.move()
            self.grid[newPos.row][newPos.column] = guardDirection.symbol
            self.grid[guardPosition.row][guardPosition.column] = Character("X")
            return .success(newPos)
        } else if isWallAt(pos) {
            self.grid[guardPosition.row][guardPosition.column] = Character("X")
            return .failure(.outOfBounds(position: pos))
        }
        self.grid[pos.row][pos.column] = guardDirection.symbol
        self.grid[guardPosition.row][guardPosition.column] = Character("X")
        return .success(pos)
    }
}

struct Map: MapGrid {
    var guardDirection: Direction = .north
    var grid: Grid
}

func emoji(_ char: Character) -> String {
    switch char {
    case "^":
        return String("🔼")
    case "v":
        return String("🔽")
    case "<":
        return String("🔽")
    case ">":
        return String("🔽")
    case "#":
        return String("⬜️")
    case "X":
        return String("·")
    default:
        return String(" ")
    }
}

extension Map: CustomStringConvertible {
    var description: String {
        """
        \(grid.map { row in row.map { col in emoji(col) }.joined() }.joined(separator: "\n"))
        Guard: \(guardPosition ?? (-1, -1))
        Visited: \(guardVisitedPositionCount)
        Rows: \(rows)
        Columns: \(columns)
        """
    }
}

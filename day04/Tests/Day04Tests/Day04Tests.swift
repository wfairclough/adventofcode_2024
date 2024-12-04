import XCTest
@testable import Day04

extension String {
    func trimmingCharactersPerLine(in set: CharacterSet) -> String {
        return self.split(separator: "\n").map { $0.trimmingCharacters(in: set) }.joined(separator: "\n")
    }
}

final class Day04Tests: XCTestCase {
    let sample = String("""
        MMMSXXMASM
        MSAMXMSMSA
        AMXSXMAAMM
        MSAMASMSMX
        XMASAMXAMM
        XXAMMXXAMA
        SMSMSASXSS
        SAXAMASAAA
        MAMMMXMMMM
        MXMXAXMASX
    """
        .trimmingCharactersPerLine(in: .whitespaces)
        .trimmingCharacters(in: .newlines))


    func testBuildGrid() {
        let grid = buildGrid(sample)
        XCTAssertEqual(grid, [
            ["M", "M", "M", "S", "X", "X", "M", "A", "S", "M"],
            ["M", "S", "A", "M", "X", "M", "S", "M", "S", "A"],
            ["A", "M", "X", "S", "X", "M", "A", "A", "M", "M"],
            ["M", "S", "A", "M", "A", "S", "M", "S", "M", "X"],
            ["X", "M", "A", "S", "A", "M", "X", "A", "M", "M"],
            ["X", "X", "A", "M", "M", "X", "X", "A", "M", "A"],
            ["S", "M", "S", "M", "S", "A", "S", "X", "S", "S"],
            ["S", "A", "X", "A", "M", "A", "S", "A", "A", "A"],
            ["M", "A", "M", "M", "M", "X", "M", "M", "M", "M"],
            ["M", "X", "M", "X", "A", "X", "M", "A", "S", "X"]])
    }

    func testPart1CountXMASOccurances() {
        let grid = buildGrid(sample)
        XCTAssertEqual(grid.count(occuranceseOf: "XMAS"), 18)
    }


    let sample2 = String("""
        M.M.MM.M.M.
        .A.A.AA.A..
        S.S.SSSS.S.
    """
        .trimmingCharactersPerLine(in: .whitespaces)
        .trimmingCharacters(in: .newlines))

    let sample3 = String("""
        M.M...S.S..
        .A.....A...
        S.S...M.M..
        .A.....A...
        S.S...M.M..
    """
        .trimmingCharactersPerLine(in: .whitespaces)
        .trimmingCharacters(in: .newlines))

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

    func testPart2CountXMasMasks() {
        let grid = buildGrid(sample)
        var count = 0
        for mask in xMasMasks {
            count += grid.count(occurancesOfMask: mask)
            print("count: \(count)")
        }
        XCTAssertEqual(count, 9)
    }
}


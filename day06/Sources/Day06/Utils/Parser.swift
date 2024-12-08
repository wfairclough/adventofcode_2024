import Foundation


protocol Parser {
    associatedtype Input
    associatedtype Output

    func parse(_ input: Input) -> Output
}

struct ParserError: Error {
    let message: String
}

struct LineParser: Parser {
    typealias Input = String
    typealias Output = [String]

    func parse(_ input: String) -> [String] {
        return input.components(separatedBy: .newlines)
    }
}

struct GroupParser: Parser {
    typealias Input = [String]
    typealias Output = [[String]]

    func parse(_ input: [String]) -> [[String]] {
        return input.map { $0.split(separator: "", omittingEmptySubsequences: true).map { String($0) } }
    }
}

typealias Grid = [[Character]]

struct GridParser: Parser {
    typealias Input = String
    typealias Output = Grid

    let lineParser = LineParser()
    let groupParser = GroupParser()

    func parse(_ input: String) -> Grid {
        let lines = lineParser.parse(input)
        print(lines)
        let groups = groupParser.parse(lines)
        print(groups)
        return groups.map { $0.map { Character($0) } }.dropLast(while: { $0.isEmpty })
    }
}

extension Array {
    func dropLast(while predicate: (Element) -> Bool) -> [Element] {
        var result = self
        while let last = result.last, predicate(last) {
            result.removeLast()
        }
        return result
    }
}


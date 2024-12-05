
public struct PrintOrderRule {
    let page: Int
    let mustComeBefore: [Int]

    func isBefore(_ other: Int) -> Bool {
        return mustComeBefore.contains(other)
    }

    func isBeforeAll(pages: [Int]) -> Bool {
        return pages.allSatisfy(isBefore)
    }

    func isValid(beforePages: [Int]) -> Bool {
        // If the `beforePages` contains any of the `mustComeBefore` pages, then it's invalid
        return !beforePages.contains { mustComeBefore.contains($0) }
    }

    func clone(newBeforeValue: Int) -> PrintOrderRule {
        return PrintOrderRule(page: page, mustComeBefore: mustComeBefore + [newBeforeValue])
    }
}

public extension PrintOrderRule {
    // Parse PrintOrderRule from a string Int|Int
    static func parsePrintOrderRules(from input: String) -> [Int:PrintOrderRule] {
        return input
            .split(separator: "\n")
            .reduce(into: [Int:PrintOrderRule]()) { (result, line) in
                if line.isEmpty { return }
                let parts = line.split(separator: "|")
                let page = Int(parts[0])!
                let mustComeBefore = Int(parts[1])!
                if let existingRule = result[page] {
                    result[page] = existingRule.clone(newBeforeValue: mustComeBefore)
                } else {
                    result[page] = PrintOrderRule(page: page, mustComeBefore: [mustComeBefore])
                }
            }
    }
}


public struct Update : Equatable {
    let pages: [Int]
    var middlePage: Int {
        let midIndex = Int(pages.count / 2)
        return pages[midIndex]
    }

    func isValid(with rules: [Int:PrintOrderRule]) -> Bool {
        return pages.allSatisfy { page in
            guard let rule = rules[page] else { return true }
            let pagesAfterPage = pages.dropFirst(pages.firstIndex(of: page)! + 1).map { $0 }
            let pagesBeforePage = pages.dropLast(pages.count - pages.firstIndex(of: page)!).map { $0 }
            let beforeResult = rule.isValid(beforePages: pagesBeforePage)
            let afterResult = rule.isBeforeAll(pages: pagesAfterPage)
            print("Checking page \(page) with rule \(rule.mustComeBefore)")
            print("Pages: \(pages)")
            print("Result: \(beforeResult && afterResult)")
            if !beforeResult {
                print("XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX \(page) is not valid \(pages)")
            }
            print("-------------------------")
            return beforeResult && afterResult
        }
    }
}

public extension Update {
    static func parseUpdates(from input: String) -> [Update] {
        return input
            .split(separator: "\n")
            .map { line in
                let pages = line.split(separator: ",").map { Int($0)! }
                return Update(pages: pages)
            }
    }
}


public extension String {
    func parseAsUpdateAndRules() -> ([Update], [Int:PrintOrderRule]) {
        let parts = self.split(separator: "\n\n")
        // print(parts[0])
        // print("----")
        // print(parts[1])
        let rules = PrintOrderRule.parsePrintOrderRules(from: String(parts[0]))
        let update = Update.parseUpdates(from: String(parts[1]))
        return (update, rules)
    }
}

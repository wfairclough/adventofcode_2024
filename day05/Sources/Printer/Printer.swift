
public struct PrintOrderRule {
    let page: Int
    let mustComeBefore: Set<Int>

    init(page: Int, mustComeBefore: [Int]) {
        self.page = page
        self.mustComeBefore = Set(mustComeBefore)
    }

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
            let pagesBeforePage = pages.dropLast(pages.count - pages.firstIndex(of: page)!).map { $0 }
            let beforeResult = rule.isValid(beforePages: pagesBeforePage)
            // print("Checking page \(page) with rule \(rule.mustComeBefore)")
            // print("Pages: \(pages)")
            // print("Result: \(beforeResult)")
            // if !beforeResult {
            //     print("XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX \(page) is not valid \(pages)")
            // }
            // print("-------------------------")
            return beforeResult
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

    func fix(with rules: [Int:PrintOrderRule]) -> Update {
        var newPages = pages
        var invalidPageIndexes = [Int]()
        for (index, page) in pages.enumerated() {
            guard let rule = rules[page] else { continue }
            let pagesBeforePage = Array(pages.dropLast(pages.count - index))
            if !rule.isValid(beforePages: pagesBeforePage) {
                invalidPageIndexes.append(index)
            }
        }
        let invalidPages = invalidPageIndexes.enumerated().map { (offset, index) -> Int in
            let invalidPage = newPages.remove(at: index - offset)
            return invalidPage
        }
        var fixedPages = [Int]()
        invalid_loop: for invalidPage in invalidPages {
            guard let rule = rules[invalidPage] else { continue }
            for index in stride(from: newPages.count, to: 0, by: -1) {
                let pagesBeforePage = Array(newPages.dropLast(newPages.count - index))
                if rule.isValid(beforePages: pagesBeforePage) {
                    let pagesAfterPage = Array(newPages.dropFirst(index))
                    newPages = pagesBeforePage + [invalidPage] + pagesAfterPage
                    fixedPages.append(invalidPage)
                    continue invalid_loop
                }
            }
            newPages = [invalidPage] + newPages
            fixedPages.append(invalidPage)
        }
        let newUpdate = Update(pages: newPages)
        if !newUpdate.isValid(with: rules) {
            print("\(newUpdate) is not valid after fixing")
            fatalError("Invalid update after fixing")
        } else {
            print("Invalid pages: \(invalidPages)")
            for invalidPage in invalidPages {
                print("Invalid page \(invalidPage) must come before \(rules[invalidPage]!.mustComeBefore.sorted())")
            }
            print("Update pre fix: \(self)")
            print("Update pst fix: \(newUpdate)")
            print("Fixed pages: \(fixedPages)")
            print("=================================")
        }
        return newUpdate
    }
}

public extension Array where Element == Update {
    struct PartitionedUpdates {
        let validUpdates: [Update]
        let invalidUpdates: [Update]
    }

    mutating func partitionValidAndInvalid(rules: [Int:PrintOrderRule]) -> PartitionedUpdates {
        let splitIndex = self.partition { $0.isValid(with: rules) }
        let invalidUpdates = Array(self[..<splitIndex])
        let validUpdates = Array(self[splitIndex...])
        return PartitionedUpdates(validUpdates: validUpdates, invalidUpdates: invalidUpdates)
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


import XCTest
@testable import Day05

extension String {
    func trimmingCharactersPerLine(in set: CharacterSet) -> String {
        return self.split(separator: "\n").map { $0.trimmingCharacters(in: set) }.joined(separator: "\n")
    }
}

final class Day05Tests: XCTestCase {
    let sampleRulesInput = String("""
    47|53
    97|13
    97|61
    97|47
    75|29
    61|13
    75|53
    29|13
    97|29
    53|29
    61|53
    97|53
    61|29
    47|13
    75|47
    97|75
    47|61
    75|61
    47|29
    75|13
    53|13
    """
        .trimmingCharactersPerLine(in: .whitespaces)
        .trimmingCharacters(in: .newlines))

    func testPrintOrderRuleParsing() {
        let rules = PrintOrderRule.parsePrintOrderRules(from: sampleRulesInput)
        // 75,47,61,53,29 is valid
        XCTAssertEqual(rules.count, 6) // 6 uniqe page numbers
        XCTAssertEqual(rules[47]?.mustComeBefore, [53, 13, 61, 29])
        XCTAssertEqual(rules[47]?.isBefore(61), true)
        XCTAssertEqual(rules[75]?.isBeforeAll(pages: [47, 61, 53, 29]), true)
        XCTAssertEqual(rules[47]?.isBeforeAll(pages: [61, 53, 29]), true)
        XCTAssertEqual(rules[61]?.isBeforeAll(pages: [53, 29]), true)
        XCTAssertEqual(rules[53]?.isBeforeAll(pages: [29]), true)
    }

    let sampleUpdateInput = String("""
    75,47,61,53,29
    97,61,53,29,13
    75,29,13
    75,97,47,61,53
    61,13,29
    97,13,75,29,47
    """
        .trimmingCharactersPerLine(in: .whitespaces)
        .trimmingCharacters(in: .newlines))

    func testUpdateIsValid() {
        let rules = PrintOrderRule.parsePrintOrderRules(from: sampleRulesInput)

        let updates = Update.parseUpdates(from: self.sampleUpdateInput)

        XCTAssertEqual(updates.count, 6)
        XCTAssertEqual(updates[0], Update(pages: [75, 47, 61, 53, 29]))
        XCTAssertEqual(updates[1], Update(pages: [97, 61, 53, 29, 13]))
        XCTAssertEqual(updates[2], Update(pages: [75, 29, 13]))
        XCTAssertEqual(updates[3], Update(pages: [75, 97, 47, 61, 53]))
        XCTAssertEqual(updates[4], Update(pages: [61, 13, 29]))
        XCTAssertEqual(updates[5], Update(pages: [97, 13, 75, 29, 47]))
        XCTAssertTrue(updates[0].isValid(with: rules))
        let validUpdates = updates.filter { $0.isValid(with: rules) }
        let invalidUpdates = updates.filter { !$0.isValid(with: rules) }
        XCTAssertEqual(validUpdates.count, 3)
        XCTAssertEqual(invalidUpdates.count, 3)
        print(validUpdates)
    }

    func testUpdateMiddlePage() {
        let update = Update(pages: [75, 47, 61, 53, 29])
        XCTAssertEqual(update.middlePage, 61)
    }
}


import Foundation

protocol FileInput {
    var filename: String { get }
    func getInput() -> String
}

extension FileInput {
    func getInput() -> String {
        return try! String(contentsOfFile: filename)
    }
}


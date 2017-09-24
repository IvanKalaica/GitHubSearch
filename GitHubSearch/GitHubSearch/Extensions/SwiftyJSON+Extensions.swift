//
//  SwiftyJSON+Extensions.swift
//  GitHubSearch
//
//  Created by Ivan Kalaica on 21/09/2017.
//  Copyright © 2017 Kalaica. All rights reserved.
//

import Foundation
import SwiftyJSON
import SwiftDate

public enum ParsingError : Error {
    case instance(file: String, line: Int, function: String)
}

public extension ParsingError {
    static func createParsingError(function: String = #function, file: String = #file, line: Int = #line) -> ParsingError {
        return .instance(file: file, line: line, function: function)
    }
}

public extension JSON {
    func stringOrThrow(function: String = #function, file: String = #file, line: Int = #line) throws -> String {
        guard let string = self.string else {
            throw ParsingError.createParsingError(function: function, file: file, line: line)
        }
        return string
    }

    func intOrThrow(function: String = #function, file: String = #file, line: Int = #line) throws -> Int {
        guard let int = self.int ?? Int(self.string ?? "") else {
            throw ParsingError.createParsingError(function: function, file: file, line: line)
        }

        return int
    }

    func doubleOrThrow(function: String = #function, file: String = #file, line: Int = #line) throws -> Double {
        guard let int = self.double ?? Double(self.string ?? "") else {
            throw ParsingError.createParsingError(function: function, file: file, line: line)
        }

        return int
    }

    func arrayOrThrow(function: String = #function, file: String = #file, line: Int = #line) throws -> [JSON] {
        guard let array = self.array else {
            throw ParsingError.createParsingError(function: function, file: file, line: line)
        }
        return array
    }

    func dateOrThrow(function: String = #function, file: String = #file, line: Int = #line) throws -> Date {
        guard let date = try self.dateOptionalOrThrow() else {
            throw ParsingError.createParsingError(function: function, file: file, line: line)
        }

        return date
    }

    func boolOrThrow(function: String = #function, file: String = #file, line: Int = #line) throws -> Bool {
        guard let bool = self.bool else {
            throw ParsingError.createParsingError(function: function, file: file, line: line)
        }

        return bool
    }

    func dateOptionalOrThrow(function: String = #function, file: String = #file, line: Int = #line) throws -> Date? {
        guard let date = self.string else {
            return nil
        }
        guard let dateOptional = DateInRegion(string: date, format: .iso8601Auto) else {
            throw ParsingError.createParsingError()
        }
        return dateOptional.absoluteDate
    }
}

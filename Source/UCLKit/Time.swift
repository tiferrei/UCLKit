//
//  Time.swift
//  UCLKit
//
//  Created by Tiago Ferreira on 25/04/2017.
//  Copyright © 2017 Tiago Ferreira. All rights reserved.
//

import Foundation

public struct Time {

    /**
     A date formatter for ISO 8601 style timestamps. Uses GB locale and GMT timezone.
     - [https://tools.ietf.org/html/rfc3339](https://tools.ietf.org/html/rfc3339)
     - [https://developer.apple.com/library/mac/qa/qa1480/_index.html](https://developer.apple.com/library/mac/qa/qa1480/_index.html)
     - [https://developer.apple.com/library/ios/documentation/Cocoa/Conceptual/DataFormatting/Articles/dfDateFormatting10_4.html](https://developer.apple.com/library/ios/documentation/Cocoa/Conceptual/DataFormatting/Articles/dfDateFormatting10_4.html)
     */
    public static let inclusiveISO8601DateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        return formatter
    }()

    /**
     Parses RFC 3339 date strings into NSDate
     - parameter string: The string representation of the date
     - returns: An `NSDate` with a successful parse, otherwise `nil`
     */
    public static func iso8601Date(_ string: String?) -> Date? {
        guard let string = string else { return nil }
        return Time.inclusiveISO8601DateFormatter.date(from: string)
    }

    /**
     Parses a Date into a RFC 3339 date string
     - parameter date: The NSDate representation of the date
     - returns: A `String` with a successful parse, otherwise `nil`
     */
    public static func iso8601String(_ date: Date?) -> String? {
        guard let date = date else { return nil }
        return Time.inclusiveISO8601DateFormatter.string(from: date)
    }

    /**
     Parses a Date into a YYYYMMDD string
     - parameter date: The NSDate representation of the date
     - returns: A `String` with a successful parse, otherwise `nil`
     */
    public static func conventionalDate(_ date: Date?) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        guard let date = date else { return nil }
        return dateFormatter.string(from: date)
    }
}

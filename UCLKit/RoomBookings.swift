//
//  RoomBookings.swift
//  UCLKit
//
//  Created by Tiago Ferreira on 01/03/2017.
//  Copyright © 2017 Tiago Ferreira. All rights reserved.
//

import Foundation
import RequestKit

// Mark: Model

@objc open class RoomsResponse: NSObject {
    open var OK: Bool?
    open var error: String?
    open var rooms: [Room]?

    public init(_ json: [String: Any]) {
        OK = json["ok"] as? Bool
        error = json["error"] as? String
        rooms = (json["rooms"] as? [[String: AnyObject]])?.map { Room($0) }
    }
}

@objc open class Room: NSObject {
    open let roomID: String?
    open var roomName: String?
    open var siteID: String?
    open var siteName: String?
    open var capacity: Int?
    open var classification: Classification?
    open var automated: Automation?
    open var location: Location?

    public init(_ json: [String: Any]) {
            roomID = json["roomid"] as? String
            roomName = json["roomname"] as? String
            siteID = json["siteid"] as? String
            siteName = json["sitename"] as? String
            capacity = json["capacity"] as? Int
            classification = Classification(rawValue: json["classification"] as? String ?? "")
            automated = Automation(rawValue: json["automated"] as? String ?? "")
            location = Location(json["location"] as? [String: AnyObject] ?? [:])
    }
}

@objc open class BookingsResponse: NSObject {
    open var OK: Bool?
    open var error: String?
    open var bookings: [Booking]?
    open var nextPageExists: Bool?
    open var pageToken: String?
    open var count: Int?
    
    public init(_ json: [String: Any]) {
        OK = json["ok"] as? Bool
        error = json["error"] as? String
        bookings = (json["bookings"] as? [[String: AnyObject]])?.map { Booking($0) }
        nextPageExists = json["next_page_exists"] as? Bool
        pageToken = json["page_token"] as? String
        count = json["count"] as? Int
    }
}

@objc open class Booking: NSObject {
    open let slotID: Int?
    open var endTime: Date?
    open var bookingDescription: String?
    open var roomName: String?
    open var siteID: String?
    open var contact: String?
    open var weekNumber: Int?
    open var roomID: String?
    open var startTime: Date?
    open var phone: String?

    public init(_ json: [String: Any]) {
        slotID = json["slotid"] as? Int
        endTime = UCLKit.Time.parseString(string: json["end_time"] as? String)
        bookingDescription = json["description"] as? String
        roomName = json["roomname"] as? String
        siteID = json["siteid"] as? String
        contact = json["contact"] as? String
        weekNumber = json["weeknumber"] as? Int
        roomID = json["roomid"] as? String
        startTime = UCLKit.Time.parseString(string: json["start_time"] as? String)
        phone = json["phone"] as? String
    }
}


// Mark: Helper Classes

@objc open class Location: NSObject {
    open var address: [String]?

    public init(_ json: [String: Any]) {
        address = json["address"] as? [String]
    }
}

public enum Classification: String {
    case LectureTheatre = "LT"
    case Classroom = "CR"
    case PublicCluster = "PC1"
    case SocialSpace = "SS"
    case Unknown = ""
}

public enum Automation: String {
    case Automated = "A"
    case NotAutomated = "N"
    case Dependent = "P"
    case Unknown = ""
}

// Mark: Requests

public extension UCLKit {
    /**
     Fetches rooms and information about them.
     - parameter roomID: The room ID (not to be confused, with the roomname).
     - parameter roomName: The name of the room. It often includes the name of the site (building) as well.
     - parameter siteID: Every room is inside a site (building). All sites have IDs.
     - parameter siteName: Every site (building) has a name. In some cases this is contained in the roomname as well.
     - parameter classificaton: The type of room. LT = Lecture Theatre, CR = Classroom, SS = Social Space, PC1 = Public Cluster or "" = Unknown
     - parameter capacity: very room has a set capacity of how many people can fit inside it. When supplied, all rooms with the given capacity or greater will be returned.
     - parameter completion: Callback for the outcome of the fetch.
     */
    public func rooms(_ session: RequestKitURLSession = URLSession.shared, roomID: String = "", roomName: String = "", siteID: String = "", siteName: String = "", classification: Classification = Classification.Unknown, capacity: String = "", completion: @escaping (_ response: Response<RoomsResponse>) -> Void) -> URLSessionDataTaskProtocol? {
        let router = RoomBookingsRouter.readRooms(configuration: configuration, roomID: roomID, roomName: roomName, siteID: siteID, siteName: siteName, classification: classification, capacity: capacity)
        return router.loadJSON(session, expectedResultType: [String: AnyObject].self) { json, error in
            if let error = error {
                completion(Response.failure(error))
            }

            if let json = json {
                let response =  RoomsResponse(json)
                completion(Response.success(response))
            }
        }
    }
    
    /**
     Fetches public bookings and information about them.
     - parameter pageToken: Page token received in initial /bookings request. The page token does not change as you paginate through the results.
     - parameter roomName: The name of the room. It often includes the name of the site (building) as well.
     - parameter roomID: The room ID (not to be confused with the roomname).
     - parameter startDateTime: Start datetime of the booking. Returns bookings with a start_datetime after the **String** supplied. Use **UCLKit.Time.parseDate** to get an NSDate into the appropriate String format.
     - parameter endDateTime: End datetime of the booking. Returns bookings with endDate before the **String** supplied. Use **UCLKit.Time.parseDate** to get an NSDate into the appropriate String format
     - parameter date: Date of the bookings you need, in the format YYYYMMDD. Returns bookings occurring on this day. This query parameter is only considered when end_datetime and start_datetime are not supplied.
     - parameter siteID: Every room is inside a site (building). All sites have IDs.
     - parameter description: Describes what the booking is. Could contain a module code (for example WIBRG005) or just the type of activity (for example Lecture).
     - parameter contact: The name of the person who made the booking. Substrings of the contact name can be used: Queries for Mark will include Mark Herbster. Sometimes, a society or student group may be the contact for a booking.
     - parameter resultsPerPage: Number of bookings returned per page. Maximum allowed value is 1000. Defaults to 1000.
     - parameter completion: Callback for the outcome of the fetch.
     */
    public func bookings(_ session: RequestKitURLSession = URLSession.shared, pageToken: String = "", roomName: String = "", roomID: String = "", startDateTime: String = "", endDateTime: String = "", date: String = "", siteID: String = "", description: String = "", contact: String = "", resultsPerPage: String = "1000", completion: @escaping (_ response: Response<BookingsResponse>) -> Void) -> URLSessionDataTaskProtocol? {
        let router = RoomBookingsRouter.readBookings(configuration: configuration, pageToken: pageToken, roomName: roomName, roomID: roomID, startDateTime: startDateTime, endDateTime: endDateTime, date: date, siteID: siteID, description: description, contact: contact, resultsPerPage: resultsPerPage)
        return router.loadJSON(session, expectedResultType: [String: AnyObject].self) { json, error in
            if let error = error {
                completion(Response.failure(error))
            }
            
            if let json = json {
                let response =  BookingsResponse(json)
                completion(Response.success(response))
            }
        }
    }
}

// MARK: Router

enum RoomBookingsRouter: Router {
    case readRooms(configuration: Configuration, roomID: String, roomName: String, siteID: String, siteName: String, classification: Classification, capacity: String)
    case readBookings(configuration: Configuration, pageToken: String, roomName: String, roomID: String, startDateTime: String, endDateTime: String, date: String, siteID: String, description: String, contact: String, resultsPerPage: String)

    var configuration: Configuration {
        switch self {
        case .readRooms(let config, _, _, _, _, _, _): return config
        case .readBookings(let config, _, _, _, _, _, _, _, _, _, _): return config
        }
    }

    var method: HTTPMethod {
        return .GET
    }

    var encoding: HTTPEncoding {
        return .url
    }

    var params: [String: Any] {
        switch self {
        case .readRooms(_, let roomID, let roomName, let siteID, let siteName, let classification, let capacity):
            return ["roomid": roomID, "roomname": roomName, "siteid": siteID, "sitename": siteName, "classification": classification, "capacity": capacity]
        case .readBookings(_, let pageToken, let roomName, let roomID, let startDateTime, let endDateTime, let date, let siteID, let description, let contact, let resultsPerPage):
            return ["page_token": pageToken, "roomname": roomName, "roomid": roomID, "start_datetime": startDateTime, "end_datetime": endDateTime, "date": date, "siteid": siteID, "description": description, "contact": contact, "results_per_page": resultsPerPage]
        }
    }

    var path: String {
        switch self {
        case .readRooms:
            return "roombookings/rooms"
        case .readBookings:
            return "roombookings/bookings"
        }
    }
}

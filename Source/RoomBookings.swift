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

/// Wrapper for the Rooms response
@objc open class RoomsResponse: NSObject, Codable {
    open var OK: Bool?
    open var error: String?
    open var rooms: [Room]?

    enum CodingKeys: String, CodingKey {
        case OK = "ok"
        case error
        case rooms
    }
}

/// Payload from the Rooms response
@objc open class Room: NSObject, Codable {
    @objc open var roomID: String?
    @objc open var roomName: String?
    @objc open var siteID: String?
    @objc open var siteName: String?
    open var capacity: Int?
    open var classification: Classification?
    open var automated: Automation?
    @objc open var location: Location?

    enum CodingKeys: String, CodingKey {
        case roomID = "roomid"
        case roomName = "roomname"
        case siteID = "siteid"
        case siteName = "sitename"
        case capacity
        case classification
        case automated
        case location
    }
}

/// Wrapper for the Bookings response
@objc open class BookingsResponse: NSObject, Codable {
    open var OK: Bool?
    open var error: String?
    open var bookings: [Booking]?
    open var nextPageExists: Bool?
    open var pageToken: String?
    open var count: Int?
    
    enum CodingKeys: String, CodingKey {
        case OK = "ok"
        case error
        case bookings
        case nextPageExists = "next_page_exists"
        case pageToken = "page_token"
        case count
    }
}

/// Payload for the Bookings response
@objc open class Booking: NSObject, Codable {
    @objc open private(set) var slotID: Int = -1
    @objc open var endTime: Date?
    @objc open var bookingDescription: String?
    @objc open var roomName: String?
    @objc open var siteID: String?
    @objc open var contact: String?
    open var weekNumber: Int?
    @objc open var roomID: String?
    @objc open var startTime: Date?
    @objc open var phone: String?

    enum CodingKeys: String, CodingKey {
        case slotID = "slotid"
        case endTime = "end_time"
        case bookingDescription = "description"
        case roomName = "roomname"
        case siteID = "siteid"
        case contact
        case weekNumber = "weeknumber"
        case roomID = "roomid"
        case startTime = "start_time"
        case phone
    }
}

/// Wrapper for the Equipment response
@objc open class EquipmentResponse: NSObject, Codable {
    open var OK: Bool?
    open var error: String?
    open var equipment: [Equipment]?
    
    enum CodingKeys: String, CodingKey {
        case OK = "ok"
        case error
        case equipment
    }
}

/// Payload for the Equipment response
@objc open class Equipment: NSObject, Codable {
    open var type: Type?
    open var equipmentDescription: String?
    open var units: Int?
    
    enum CodingKeys: String, CodingKey {
        case type
        case equipmentDescription = "description"
        case units
    }
}

// Mark: Helper Classes

/// Address sub-payload from the Room payload
@objc open class Location: NSObject, Codable {
    open var address: [String]?
    open var coordinates: Coordinate?

    enum CodingKeys: String, CodingKey {
        case address
        case coordinates
    }
}

/// Coordinate sub-payload from the Location
@objc open class Coordinate: NSObject, Codable {
    open var latitude: String?
    open var longitude: String?

    enum CodingKeys: String, CodingKey {
        case latitude = "lat"
        case longitude = "lng"
    }
}

/// Classification enum to clarify options.
public enum Classification: String, Codable {
    case LectureTheatre = "LT"
    case Classroom = "CR"
    case PublicCluster = "PC1"
    case SocialSpace = "SS"
    case TheatreHall = "TH"
    case UndocumentedCFE = "CFE" // FIXME: Undocumented option CFE (UCLAPI #326)
    case UndocumentedMR = "MR" // FIXME: Undocumented option MR (UCLAPI #326)
    case UndocumentedER = "ER" // FIXME: Undocumented option ER (UCLAPI #326)
    case UndocumentedCF = "CF" // FIXME: Undocumented option CF (UCLAPI #326)
    case Unknown = ""
}

/// Automation enum to clarify options.
public enum Automation: String, Codable {
    case Automated = "A"
    case NotAutomated = "N"
    case Dependent = "P"
    case Unknown = ""
}

/// Type enum to clarify options.
public enum Type: String, Codable {
    case FixedEquipment = "FE"
    case FixedFeature = "FF"
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
        let router = RoomBookingsRouter.readRooms(configuration, roomID, roomName, siteID, siteName, classification, capacity)
        return router.load(session, expectedResultType: RoomsResponse.self) { rooms, error in
            if let error = error {
                completion(Response.failure(error))
            }

            if let rooms = rooms {
                completion(Response.success(rooms))
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
        let router = RoomBookingsRouter.readBookings(configuration, pageToken, roomName, roomID, startDateTime, endDateTime, date, siteID, description, contact, resultsPerPage)
        return router.load(session, dateDecodingStrategy: .formatted(Time.inclusiveISO8601DateFormatter), expectedResultType: BookingsResponse.self) { bookings, error in
            if let error = error {
                completion(Response.failure(error))
            }
            
            if let bookings = bookings {
                completion(Response.success(bookings))
            }
        }
    }
    
    /**
     Returns any equipment/feature information about a specific room
     - parameter roomID: The room ID (not to be confused, with the roomname).
     - parameter siteID: Every room is inside a site (building). All sites have IDs.
     - parameter completion: Callback for the outcome of the fetch.
     */
    public func equipment(_ session: RequestKitURLSession = URLSession.shared, roomID: String, siteID: String, completion: @escaping (_ response: Response<EquipmentResponse>) -> Void) -> URLSessionDataTaskProtocol? {
        let router = RoomBookingsRouter.readEquipment(configuration, roomID, siteID)
        return router.load(session, expectedResultType: EquipmentResponse.self) { equipment, error in
            if let error = error {
                completion(Response.failure(error))
            }
            
            if let equipment = equipment {
                completion(Response.success(equipment))
            }
        }
    }
}

// MARK: Router

/**
Main Room Bookings Router, contains:
 - GET Rooms router
 - GET Bookings router
 - GET Equipment router
*/
enum RoomBookingsRouter: Router {
    case readRooms(Configuration, String, String, String, String, Classification, String)
    case readBookings(Configuration, String, String, String, String, String, String, String, String, String, String)
    case readEquipment(Configuration, String, String)

    var configuration: Configuration {
        switch self {
        case .readRooms(let config, _, _, _, _, _, _): return config
        case .readBookings(let config, _, _, _, _, _, _, _, _, _, _): return config
        case .readEquipment(let config, _, _): return config
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
            return ["roomid": roomID, "roomname": roomName, "siteid": siteID, "sitename": siteName, "classification": classification.rawValue, "capacity": capacity]
        case .readBookings(_, let pageToken, let roomName, let roomID, let startDateTime, let endDateTime, let date, let siteID, let description, let contact, let resultsPerPage):
            return ["page_token": pageToken, "roomname": roomName, "roomid": roomID, "start_datetime": startDateTime, "end_datetime": endDateTime, "date": date, "siteid": siteID, "description": description, "contact": contact, "results_per_page": resultsPerPage]
        case .readEquipment(_, let roomID, let siteID):
            return ["roomid": roomID, "siteid": siteID]
        }
    }

    var path: String {
        switch self {
        case .readRooms:
            return "roombookings/rooms"
        case .readBookings:
            return "roombookings/bookings"
        case .readEquipment:
            return "roombookings/equipment"
        }
    }
}

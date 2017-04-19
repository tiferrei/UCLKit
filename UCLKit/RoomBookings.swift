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
}

// MARK: Router

enum RoomBookingsRouter: Router {
    case readRooms(configuration: Configuration, roomID: String, roomName: String, siteID: String, siteName: String, classification: Classification, capacity: String)

    var configuration: Configuration {
        switch self {
        case .readRooms(let config, _, _, _, _, _, _): return config
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
        }
    }

    var path: String {
        switch self {
        case .readRooms:
            return "roombookings/rooms"
        }
    }
}

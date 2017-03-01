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

@objc open class Room: NSObject {
    open let roomID: String
    open var roomName: String?
    open var siteID: String?
    open var siteName: String?
    open var capacity: Int?
    open var classification: String?
    open var automated: String?
    open var location: Location?

    public init(_ json: [String: Any]) {
        if let roomID = json["roomid"] as? String {
            self.roomID = roomID
            roomName = json["roomname"] as? String
            siteID = json["siteid"] as? String
            siteName = json["sitename"] as? String
            capacity = json["capacity"] as? Int
            classification = json["classification"] as? String
            automated = json["automated"] as? String
            location = Location(json["location"] as? [String: AnyObject] ?? [:])
        } else {
            self.roomID = "0"
        }
    }
}

// Mark: Helper Classes

@objc open class Location: NSObject {
    open var address: [String]?

    public init(_ json: [String: Any]) {
        address = json["address"] as? [String]
    }

}

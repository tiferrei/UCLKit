//
//  UCLKit.swift
//  UCLKit
//
//  Created by Tiago Ferreira on 01/03/2017.
//  Copyright © 2017 Tiago Ferreira. All rights reserved.
//

import Foundation
import RequestKit

public let UCLKitErrorDomain = "com.tiferrei.UCLKit"
public let UCLKitErrorKey = RequestKitErrorKey
public let UCLKitCustomTypes: Any = [RoomsResponse.self, Room.self, BookingsResponse.self, Booking.self, EquipmentResponse.self, Equipment.self, Location.self, Classification.self, Automation.self, Type.self, PeopleResponse.self, Person.self, Status.self]

/// Main UCLKit wrapping struct
public struct UCLKit {
    public let configuration: Configuration

    public init(_ config: Configuration = TokenConfiguration()) {
        configuration = config
    }
}

//: Playground - noun: a place where people can play

import UIKit
import UCLKit

let config = TokenConfiguration("12345") // Initialize a config to wrap around the auth.
UCLKit(config).rooms() { response in
    switch response {
    case .success(let rooms):
        print("The first room's name is \(rooms.rooms![0].roomName!)")
    case .failure(let error):
        print("Oops: \(error)")
    }
}

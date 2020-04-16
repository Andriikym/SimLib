/**
*  SimLib
*  Copyright (c) Andrii Myk 2020
*  Licensed under the MIT license (see LICENSE file)
*/

import Foundation

public struct Simulator: Decodable {
    public enum State: String, Decodable {
        case shutdown = "Shutdown"
        case booted = "Booted"
    }

    public let state: State
    public let name: String
    public let udid: String
    public let isAvailable: Bool
    public let runtime: String
    
    public let availabilityError: String?
}

extension Simulator {
    init?(runtime: String, dictionary: [String: Any]) {
        guard let state = State(rawValue: dictionary["state"] as? String ?? ""),
            let udid = dictionary["udid"] as? String,
            let name = dictionary["name"] as? String,
            let isAvailable = dictionary["isAvailable"] as? Bool else
        {
            return nil
        }

        self.runtime = runtime
        self.name = name
        self.state = state
        self.udid = udid
        self.isAvailable = isAvailable
        self.availabilityError = dictionary["availabilityError"] as? String
    }
}

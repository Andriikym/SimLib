/**
*  SimLib
*  Copyright (c) Andrii Myk 2020
*  Licensed under the MIT license (see LICENSE file)
*/

import Foundation

public enum SimulatorFetchError: Error, CustomStringConvertible {
    case simctlFailed
    case failedToReadOutput
    case failedWithError(message: String)

    public var description: String {
        switch self {
        case .simctlFailed:
            return "Running `simctl list` failed"
        case .failedToReadOutput:
            return "Failed to read output"
        case .failedWithError(let message):
            return "Failed with error message '\(message)'"
        }
    }
}

public enum LocationSimulationError: Error, CustomStringConvertible {
    case invalidLocation

    public var description: String {
        switch self {
        case .invalidLocation:
            return "Invalid location on input"
        }
    }
}

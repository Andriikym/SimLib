/**
*  SimLib
*  Copyright (c) Andrii Myk 2020
*  Licensed under the MIT license (see LICENSE file)
*/

import Foundation
import CoreLocation

public struct SimLib {
    
    public init() { }

    // MARK: - Simulators

    public func getAllSimulators() throws -> [Simulator] {
        let task = Process()
        task.executableURL = URL(fileURLWithPath: Self.xcrunPath)
        task.arguments = ["simctl", "list", "-j", "devices"]

        let pipe = Pipe()
        task.standardOutput = pipe

        try task.run()

        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        task.waitUntilExit()

        if task.terminationStatus != 0 {
            throw SimulatorFetchError.simctlFailed
        }

        guard let json = (try? JSONSerialization.jsonObject(with: data, options: [])) as? [String: Any] else {
            throw SimulatorFetchError.failedToReadOutput
        }

        let devices = json["devices"] as? [String: [[String: Any]]] ?? [:]

        let result = devices.map { key, value -> [Simulator] in
            value.compactMap { Simulator(runtime: key.simRuntimeString, dictionary: $0) }
        }.flatMap { $0 }

        return result
    }

    public func getBootedSimulators() throws -> [Simulator] {
        try getAllSimulators().filter { $0.state == .booted }
    }
    
    public func bootSimulator(_ simulator: Simulator) throws {
        guard  simulator.state == .shutdown else { return }
        
        guard simulator.isAvailable else { throw SimulatorFetchError.failedWithError(message: simulator.availabilityError ?? "Unavailable") }
        
        let task = Process()
        task.executableURL = URL(fileURLWithPath: Self.xcrunPath)
        task.arguments = ["simctl", "boot", "\(simulator.udid)"]

        try task.run()
        task.waitUntilExit()

        if task.terminationStatus != 0 {
            throw SimulatorFetchError.simctlFailed
        }
    }
    
    
    // MARK: - Location
    
    public func setLocationToBootedSimulators(_ location: CLLocationCoordinate2D) throws {
        let simulators = try getBootedSimulators()
        try setLocation(location, to: simulators)
    }

    public func setLocation(_ location: CLLocationCoordinate2D, to simulators: [Simulator]) throws {
        guard location.isValid else { throw LocationSimulationError.invalidLocation }

        let udidArray = simulators.map { $0.udid }

        let userInfo: [AnyHashable: Any] = [
            "simulateLocationLatitude": location.latitude,
            "simulateLocationLongitude": location.longitude,
            "simulateLocationDevices": udidArray,
        ]

        let notification = Notification(name: .simulateLocation,
                                        object: nil,
                                        userInfo: userInfo)

        DistributedNotificationCenter.default().post(notification)
    }
    
    // MARK: - Main application
    
    /// Check that Simulator application is runned. NSAppleEventsUsageDescription must be provided by consumer.
    /// Check System Preferences->Security&Privacy->Privacy->Automation for permissions than.
    public func isSimulatorAppRunned() throws -> Bool {
        let script = NSAppleScript(source: "tell application \"System Events\" to (name of processes) contains \"Simulator\"")
        // osascript -e 'tell application "System Events" to (name of processes) contains "Simulator"'
        
        var possibleError: NSDictionary?
        let event = script?.executeAndReturnError(&possibleError)
        if let error = possibleError {
            let message = error["NSAppleScriptErrorMessage"] as? String ?? ""
            throw SimulatorFetchError.failedWithError(message: message)
        }
        
        guard let executeResult = event else { throw SimulatorFetchError.failedToReadOutput}
        
        return executeResult.booleanValue
    }
}

extension SimLib {
    private static let xcrunPath = "/usr/bin/xcrun"
}


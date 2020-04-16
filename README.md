
<p align="left">
    <img src="https://img.shields.io/badge/Swift-5.0-orange.svg" />
    <a href="https://swift.org/package-manager">
        <img src="https://img.shields.io/badge/spm-compatible-brightgreen.svg?style=flat" alt="Swift Package Manager" />
    </a>
</p>


# SimLib
### Xcode-Simulation-Tools

**SimLib** is a library intended to simplify usage of Xcode simulators. It's written in Swift and for now provide next abilities:

* Determining that whole simulator application is running*;
* Getting the list of all simulators installed to the system;
* Determining which simulators are booted already;
* Booting for the arbitrary simulator;
* Setting arbitrary location coordinates to particular simulators or for all already booted;

\* To make this feature work, ***NSAppleEventsUsageDescription*** must be provided by consumer. On call, *Automation* security permission will be asked by the system.

## Usage

As this library internally uses *xcrun* command-line tools and *AppleScript*, and they need some time to execute, it is better to leverage its functionality from thread another than main.


```swift
import SimLib


private lazy var refreshQueue = DispatchQueue(label: "com.consumer_name.refresh_queue", qos: .userInitiated)

func refresh() {
    refreshQueue.async {
        do {
            self.allSimulators = try self.simLib.getAllSimulators()
        } catch {
            DispatchQueue.main.async { show(error) }
        }
    }
}

```

## Installation

As SimLib is a library created as Swift Package, it can be installed by simply adding it via Xcode’s *Swift Packages* option within the File menu or project's *Swift Packages* tab. (Both starting with Xcode 11).

Or it can be added directly as a dependency within your `Package.swift` manifest:

```swift
let package = Package(
    ...
    dependencies: [
        .package(url: "https://github.com/Andriikym/SimLib-Xcode-Simulation-Tools.git", from: "0.1.0")
    ],
    ...
)
```

Hope it will be useful 😀

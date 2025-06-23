# SwiftUI SDK Reference

This folder contains the SwiftUI and SwiftUICore module interface files extracted from the iOS SDK. These files serve as a comprehensive reference for all available SwiftUI APIs, types, and methods.

## Folder Contents

- `SwiftUI.swiftinterface` - Main SwiftUI module interface
- `SwiftUICore.swiftinterface` - Core SwiftUI functionality interface

## What are Swift Interface Files?

Swift interface files (`.swiftinterface`) are textual representations of a module's public API. They show:
- All public types, methods, and properties
- Method signatures and parameter types
- Availability information (iOS versions, platform support)
- Generic constraints and type relationships

These interface files are invaluable for understanding the full scope of SwiftUI's capabilities and can help answer "what's possible?" questions during development.

## Version Information

Current interfaces are from:
- **SDK Version**: iOS 18.1 Simulator
- **Swift Version**: 6.0 effective-5.10
- **Target**: arm64-apple-ios18.1-simulator

## Finding Framework Definitions

Apples frameworks are buried deep in Xcode. You can find them at 

`pathToXcode/Contents/Developer/Platforms/<platform_identifier>.platform/Developer/SDKs/<platform_identifier>.sdk/System/Library/Frameworks`

with `<platform_identifier>` being either

`iPhoneSimulator` for frameworks available to iOS,
`MacOSX` for those used on macOS,
`AppleTVOS` for Apple TV or
`WatchOS` for WatchOS apps 

There are two different formats we can look at to find the entities a framework exports: `tbd` files and `swiftinterface` files. 

`tbd` stands for Text-Based Stub Library and they contain symbols and meta information of a dynamic library needed for linking these libraries during the compilation process. They are human readable `Yaml` files.

`swiftinterface` contain the interface of a Swift module. They encapsulate the public interface of Swift modules, showcasing the accessible entities like classes, structs and more, excluding implementation details. These files, generated during the Swift compilation process, serve as references for external modules and define what parts of the module are available. Starting from the file path above, you need to append 

`Modules/<framework_name>.swiftmodule/arm64-apple-<platform>.swiftinterface`

with `<framework_name>` being the name of the framework and `<platform>` being either `ios-simulator`, `macos`, `tvos-simulator` or `watchos`.

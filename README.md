# ``StapeSDK``

Stape SDK is an event based client for the Stape API.
It allows to track and send events from your mobile app to the Stape backend.

## Overview

SDK implements two main functional parts.
First is a simple event send which allows to compose an event and send it to the backend.
SDK API provides a response from the backend mapped to a simple model that contains serialized response fields.
Second is a mechanism that tracks events dispatched by the Firebase event SDK.
It hooks Firebase event dispatch and maps Firebase event to Stape event.
After that it sends it as an ordinary event.

## Usage

### Installation

#### Cocoapods

To install StapeSDK with Cocoapods just add this line to your Podfile: `pod StapeSDK` and run `pod install`.

#### SPM

For now SPM does not support packages with mixed ObjC/Swift code. We'll add SPM support once this will be included in SPM.
Feature is already in review, you can track progress here: https://forums.swift.org/t/se-0403-package-manager-mixed-language-target-support/66202

### Connection

To use Stape SDK you need to import it:

```swift
import StapeSDK
```

Then start it with config that provides credentials and connection settings.
First create an instance of the `Stape.Configuration` and pass it to the `Stape.start()` method:

```swift
if let url = URL(string: "https://yourdomain.com") {
    let c = Stape.Configuration(domain: url)
    Stape.start(configuration: c)
}
```
After that SDK is ready to use.

### Sending events

To send an event you create instance of `Stape.Event`:

```swift
let e = Stape.Event(name: "foo", payload: ["bar": "baz"])
```

and send it by passing to the `Stape.send()` method:

```swift
Stape.send(event: e) { result in
    switch result {
        case .success(let response): print("Event sent: \(response)")
        case .failure(let error): print("Failed to send event: \(error)")
    }
}
```
`Stape.send()` method provides a callback that is called after event got response and passed a result.
If event was successfullly sent result contains `Stape.EventResponse` instance.
Response provides a `payload` property which is a dictionary 
with serialized key/value pairs got from the backend.

`Stape.Event` struct provides a number of predefined keys for convenience.
Keys are listed in `Stape.Event.Keys` enum:

```swift
public enum Key: String {
    case clientID       = "client_id"
    case idfa           = "idfa"
    case currency       = "currency"
    case ipOverride     = "ip_override"
    case language       = "language"
    case pageEncoding   = "page_encoding"
    case pageHostname   = "page_hostname"
    case pageLocation   = "page_location"
    case pagePath       = "page_path"
}
```
and can be used to compose event as follows:

```swift
let e = Stape.Event(name: "foo", payload: [
    .clientID: "bar",
    .language: "foo"
])
```

### Firebase hooking

To start listening to Firebase events you need to call `Stape.startFBTracking()` method after the call to `Stape.start()`.
There is no way for now to get responses received for those events.

### Logging

Stape SDK uses Apple os.log facility to log its actions.
You can use `com.stape.logger` subsystem to filter Stape SDK logs.
To learn more about Apple structured logging please refer to the official documentation:
https://developer.apple.com/documentation/os/logging`

## Feedback

Let us know what do you think or what would you like to be improved by opening issue.

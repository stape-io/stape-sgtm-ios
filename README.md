# ``StapeSDK``

Stape SDK is a event based client of the Stape API.
It allows to track and send events from your mobile app to the Stape backend.

## Overview

SDK implements two main functional parts.
First is a simple event send which allows to compose an event and send it to the backend.
SDK API provides a response from the backend mapped to a simple model that contains serialized response fields.
Second is a mechanism that tracks events dispatched by the Firebase event SDK.
It hooks Firebase event dispatch and maps Firebase event to Stape event.
Afte that it sends it as an ordinary event.

## Usage

### Installation

### Connection

To use Stape SDK you need to import it:

```
import StapeSDK
```

Then start it with config that provides credentials and connection settings.
First create an instance of the `Stape.Configuration` and pass it to the `Stape.start()` method:

```
if let url = URL(string: "https://yourdomain.com") {
    let c = Stape.Configuration(domain: url)
    Stape.start(configuration: c)
}
```
After that SDK is ready to use.

### Sending events

To send an event you create instance of `Stape.Event`:

```
let e = Stape.Event(name: "foo", payload: [
    .clientID: "bar",
    .language: "foo"
])
```

and send it by passing to the `Stape.send()` method:

```
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

### Firebase hooking

To start listening to Firebase events you need to call `Stape.startFBTracking()` method after the call to `Stape.start()`.
There is no way for now to get responses received for those events.

### Logging

Stape SDK uses Apple os.log facility to log its actions.
You can use `com.stape.logger` subsystem to filter Stape SDK logs.
To learn more about Apple structured logging please refer to the officioal documentation:
https://developer.apple.com/documentation/os/logging`

# TrainInformationService
[![Build Status](https://app.bitrise.io/app/88a957706495b5f6/status.svg?token=PeXfbfTz6p6kexb9dtuUhA&branch=master)](https://app.bitrise.io/app/88a957706495b5f6)
[![Version](https://img.shields.io/cocoapods/v/TrainInformationService.svg?style=flat)](https://cocoapods.org/pods/TrainInformationService)
[![License](https://img.shields.io/cocoapods/l/TrainInformationService.svg?style=flat)](https://cocoapods.org/pods/TrainInformationService)
[![Platform](https://img.shields.io/cocoapods/p/TrainInformationService.svg?style=flat)](https://cocoapods.org/pods/TrainInformationService)

Information services for trains in the UK, using the National Rail open API

The API is a stab at a friendlier interface for the [National Rail Live Departure Boards Web Service](https://lite.realtime.nationalrail.co.uk/OpenLDBWS/)

## Installation

TrainInformationService can be installed using [Swift Package Manager](https://swift.org/package-manager/) or [CocoaPods](https://cocoapods.org).

### Swift Package Manager

Swift Package Manager requires Swift version 4.0 or higher. First, create a
`Package.swift` file. It should look like:

```swift
dependencies: [
  .package(url: "https://github.com/dchakarov/TrainInformationService.git", from: "0.1.0"),
]
```

`swift build` should then pull in and compile TrainInformationService for you to begin using.

### CocoaPods

To install
it, simply add the following line to your Podfile:

```ruby
pod 'TrainInformationService'
```


## Getting Started

### Initialisation

In order to use this framework you need a token for National Rail Enquiries LDBWS (OpenLDBWS). You can register for free and receive you token here - http://realtime.nationalrail.co.uk/OpenLDBWSRegistration/. For more information about the available APIs the National Rail offers you can read here - http://www.nationalrail.co.uk/100296.aspx

After you get your token you can instantiate the service like this:
``` swift
import TrainInformationService

let trainInformationService = TrainInformationService(
  apiUrl: "https://lite.realtime.nationalrail.co.uk/OpenLDBWS/ldb11.asmx",
  token: "your-token-goes-here")
```

Currently the service has support for two of the OpenLDWS methods. Both are asynchronous as they are fetching the data in real time from the National Rail Live Departure Boards Web Service. For a full list of methods and documentation you can go here - https://lite.realtime.nationalrail.co.uk/OpenLDBWS/

### Get the live departure board for a given station (GetDepartureBoard)

You can find the list of stations with their CSR codes here - http://www.nationalrail.co.uk/stations_destinations/48541.aspx

``` swift
let stationCSRCode = "PAD" // Paddington
trainInformationService.departureBoard(for: stationCSRCode, items: 5) { result in
	switch result {
	case .success(let board):
		print(board)
	case .error(_):
		break
	}
}
```

The resulting `board` would be an array of up to 5 [DepartingService](https://github.com/dchakarov/TrainInformationService/blob/master/Sources/TrainInformationService/DepartingService.swift) objects.

### Get service next stops (GetServiceDetails)

Given you have a service ID (e.g. a DepartingService object from the above call), you can get a list of stops remaining on its schedule by doing this:
``` swift
trainInformationService.serviceDetails(service.serviceId) { callingPoints in
  print(callingPoints)
}
```

Here `callingPoints` is an array of [CallingPoint](https://github.com/dchakarov/TrainInformationService/blob/master/Sources/TrainInformationService/CallingPoint.swift) objects.

## Contributing

Contributions are welcome! Just submit a PR.

## Author

Dimitar Chakarov, dimitar@dchakarov.com

## License

This is free and unencumbered software released into the public domain. See the LICENSE file for more info.

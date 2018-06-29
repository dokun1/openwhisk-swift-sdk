## Openwhisk SDK for Swift

<p align="center">
   <a href="">
	<img src="https://img.shields.io/badge/platform- iOS | macOS | watchOS | tvOS-green.svg" alt="platforms available">
   </a>
   <a href="">
	<img src="https://img.shields.io/badge/swift-4.1-orange.svg" alt="swift version">
	</a>
   <a href="">
	<img src="https://img.shields.io/badge/SwiftPM-OK-blue.svg" alt="swift version">
	</a>	
</p>

This is a native SDK for interacting with OpenWhisk.

[OpenWhisk](https://openwhisk.apache.org) is a serverless platform that operates on the basis of creating "actions" and invoking them. To learn more about how to use OpenWhisk, please go [here](https://github.com/apache/incubator-openwhisk).

## Mantra

The goal is to never, ever, ever return raw data to the consumer of OpenWhisk. Ever. Native objects, forever.

## Setup

You can integrate this SDK with Swift Package Manager. Add the following line to your `Package.swift` file:

```swift
import PackageDescription

let package = Package(
    name: "YOUR_PROJECT_NAME",
    targets: [],
    dependencies: [
        .Package(url: "https://github.com/dokun1/openwhisk-swift-sdk.git", majorVersion: 0)
    ]
)
```

After you update your manifest, type `swift build` in your command line, and the project should resolve its dependencies.

In your project, you need to first set up an instance of `Agent`. You must set four properties when using an `Agent` instance:

```swift
let newAgent = Agent()
newAgent.apiKey = "enter API key here"
newAgent.secret = "enter secret here"
newAgent.namespace = "enter namespace here"
newAgent.host = "enter host here"
```

After that, you can make requests with your instance of `Agent`.

## Functionality

### `getActions`

You can retrieve the list of actions in your namespace like so:

```swift
agent.getActions() { actions, error in

}
```

The result passed into the closure is a collection of type `Action`. Please check the class documentation for information on this object.

### `getActionDetail`

If you have an instance of `Action`, you can choose to get details on that action, such as source code, with the following function:

```swift
agent.getActionDetail(action) { details, error in

}
```

The result passed into the closure is an instance of type `ActionDetail`. Please check the class documentation for information on this object.

### `invoke`


If you have an instance of `Action`, you can invoke it in a number of ways. There are two pre-requisites for invoking an action.

1. You must provide an input object that conforms to `Codable`.
2. You must provide an output object type that conforms to `Codable`

As an example, let's assume I have an action that retrieves the price of Bitcoin given a country code. In JSON, my input looks like this:

```json
{"code": "USD"}
```

I would need to make a corresponding `Codable` object like so:

```swift
struct Currency: Codable {
    var code: String
}

let input = Currency(code: "USD")
```

Let's also assume that my potential output, in JSON, would look like this:

```json
{
    "currency": {
        "currencyCode": "USD",
        "name": "Bitcoin",
        "value": 5844.8963
    }
}
```

I would then need to make a corresponding `Codable` type like so:

```swift
struct CurrencyResponse: Codable {
    var currency: CurrencyResponseCurrency
    
    struct CurrencyResponseCurrency: Codable {
        var currencyCode: String
        var name: String
        var value: Double
    }
}
```

Having both of these defined, I can then invoke such an action like so:

```swift
agent.invoke(action: action, input: Currency(code: "USD"), responseType: CurrencyResponse.self, blocking: true, resultOnly: false, completion: { response, error in

})
```

There are two parameters in this call, `blocking` and `resultOnly`, which could elicit three possible responses. OpenWhisk is usually asynchronous in nature, which means that default behavior will return a token called `activationId` to be redeemed for a response when the action completes its work. The default value for both of these parameters in this function is `false`.

- if `blocking` is set to `false`, then a token will be returned to redeem later (this functionality has not yet been built into the SDK)
- if `blocking` is set to `true`, and `resultOnly` is set to `false`, then the action will complete and send a full response, including the result of the function in a native context specified per your response object
- if `blocking` is set to `true`, and `resultOnly` is set to `true`, then the action will complete and send only the result of the function minus the metadata of the invoked action.

## Plans

I am fully aware that there is already a Swift SDK for OpenWhisk [here](https://github.com/apache/incubator-openwhisk-client-swift). Can this be better? Time will tell.

Thank you to [James Thomas](https://github.com/jthomas) for peer pressuring me into trying this on a flight from Boston to Austin.
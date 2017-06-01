<h1 align="center">
Welcome to UCLKit
</h1>
<br>
<p align="center">
<a href="https://github.com/tiferrei/UCLKit"><img
alt="UCLKit CI Status" src="https://travis-ci.org/tiferrei/UCLKit.svg?branch=master" /></a>
<img src="https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat" alt="Carthage compatible"/>
<img src="https://img.shields.io/badge/macOS-Mavericks%20(10%2B)-blue.svg" alt="Platform: macOS Mavericks (10+)"/>
<img src="https://img.shields.io/badge/iOS-8%2B-blue.svg" alt="Platform: iOS 8+"/>
<img src="https://img.shields.io/badge/watchOS-2.1%2B-blue.svg" alt="Platform: watchOS 2.1+"/>
<img src="https://img.shields.io/badge/tvOS-9%2B-blue.svg" alt="Platform: tvOS 9+"/>
<a href="https://developer.apple.com/swift"><img src="https://img.shields.io/badge/language-swift3-f48041.svg?style=flat" alt="Language: Swift 3" /></a>
<!-- <a href="https://codebeat.co/projects/gitlab-com-uclapi-uclkit-master"><img alt="Codebeat Badge" src="https://codebeat.co/badges/a33c880a-c618-42da-b8e5-1fa8cc4e8a9f" /></a> -->
</p>
<br>

UCLKit is a Swift wrapper for the [UCL API](uclapi.com). I have developed UCLKit so that Swift developers are able to forget about all the networking, JSON parsing, etc. and with one line, request all the data already fully parsed in object properties, and with the correct Data Types, from the simple `String` and `Int` to the more proprietary `URL` and `Date`.

## Main Features

* 100% native Swift 3 framework
* Fast and native networking
* Smart error handling

## How-To

### Authentication
Just create a config instance with the token as initialization value:
```swift
let config = TokenConfiguration("12345")
```

After that, well, use it! :)
```swift
UCLKit(config).rooms() { response in
  switch response {
  case .Success(let rooms):
    print("The first room's name is \(rooms[0].name!)")
  case .Failure(let error):
    print("Oops: \(error)")
  }
}
```

If you need some more help with the framework you can open an issue above, I'll reply as soon as possible.

## Author

Tiago Ferreira | <a href="https://twitter.com/tiferrei2000/">Twitter</a> | <a href="https://www.tiferrei.com/">Website</a>

## License

UCLKit Copyright (C) 2017 Tiago Ferreira

Please check the <a href="https://gitlab.com/UCLAPI/API/blob/master/LICENSE">license file</a> embed in this project for more details.

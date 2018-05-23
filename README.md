<h1 align="center">
Welcome to UCLKit
</h1>
<br>
<p align="center">
<a href="https://circleci.org/gh/tiferrei/UCLKit"><img alt="UCLKit CI Status" src="https://circleci.com/gh/tiferrei/UCLKit/tree/master.svg?style=svg" /></a>
<img src="https://img.shields.io/badge/macOS-Mavericks%20(10%2B)-blue.svg" alt="Platform: macOS Mavericks (10+)"/>
<img src="https://img.shields.io/badge/iOS-8%2B-blue.svg" alt="Platform: iOS 8+"/>
<img src="https://img.shields.io/badge/watchOS-2.1%2B-blue.svg" alt="Platform: watchOS 2.1+"/>
<img src="https://img.shields.io/badge/tvOS-9%2B-blue.svg" alt="Platform: tvOS 9+"/>
<a href="https://www.codacy.com/app/tiferrei/UCLKit?utm_source=github.com&utm_medium=referral&utm_content=tiferrei/UCLKit&utm_campaign=Badge_Grade"><img src="https://api.codacy.com/project/badge/Grade/9c15107ef03b416bb4e8be997683002b" alt="Codacy" /></a>
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
  case .success(let data):
    print("The first room's name is \(data.rooms[0].name)")
  case .failure(let error):
    print("Oops: \(UCLKit(config).parseError(error))")
  }
}
```

If you need some more help with the framework you can open an issue above, I'll reply as soon as possible.

## Author

Tiago Ferreira | <a href="https://twitter.com/tiferrei2000/">Twitter</a> | <a href="https://www.tiferrei.com/">Website</a>

## License

UCLKit Copyright (C) 2017 Tiago Ferreira

Please check the <a href="https://gitlab.com/UCLAPI/API/blob/master/LICENSE">license file</a> embed in this project for more details.

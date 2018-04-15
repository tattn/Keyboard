<h1 align="center">Keyboard</h1>

<h5 align="center">Keyboard is a framework to make keyboard easier to handle</h5>

<br />


# Installation

## Carthage

```ruby
github "tattn/Keyboard"
```

# Auto scroll until the input text field is visible

```swift
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        Keyboard.shared.enable() // add this line
        return true
    }
}
```


# Contributing

1. Fork it!
2. Create your feature branch: `git checkout -b my-new-feature`
3. Commit your changes: `git commit -am 'Add some feature'`
4. Push to the branch: `git push origin my-new-feature`
5. Submit a pull request :D

# License

Keyboard is released under the MIT license. See LICENSE for details.

<h1 align="center">Keyboard</h1>

<h5 align="center">Keyboard is a framework to make keyboard easier to handle</h5>

<br />


# Installation

## Carthage

```ruby
github "tattn/Keyboard"
```

# Auto scroll until the input text field is visible / Close when tapping other views

<img src="https://github.com/tattn/Keyboard/raw/master/docs/assets/demo_autoscroll.gif" width="300px" alt="demo" />

```swift
func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    Keyboard.shared.enable() // add this line
    return true
}
```

# Option

```swift
// Enable all features
Keyboard.shared.enable()

// Enable a part of features
Keyboard.shared.enable(options: [.autoScroll, .closeOnTapOther])
```


# Contributing

1. Fork it!
2. Create your feature branch: `git checkout -b my-new-feature`
3. Commit your changes: `git commit -am 'Add some feature'`
4. Push to the branch: `git push origin my-new-feature`
5. Submit a pull request :D

# License

Keyboard is released under the MIT license. See LICENSE for details.


# Snackbar

## Specifications

The snackbar specifications on Zeroheight are [here](https://zeroheight.com/1186e1705/v/latest/p/36d4af-snackbar).


A – Icon (optional).  
B – Snackbar content.  
C – Container.  
D – Action button (optional).  


![Figma anatomy horizontal](https://github.com/adevinta/spark-ios-component-snackbar/blob/main/.github/assets/anatomy-horizontal.png)
![Figma anatomy vertical](https://github.com/adevinta/spark-ios-component-snackbar/blob/main/.github/assets/anatomy-vertical.png)

## UIKit

```swift
/// The UIKit version of the snacbkar.
public final class SnackbarUIView: UIView {

    /// Initialize a new snackbar view.
    /// - Parameters:
    ///   - theme: The spark theme of the snackbar.
    ///   - intent: The intent of the snackbar.
    public init(
        theme: any Theme,
        intent: SnackbarIntent
    )
}
```

### Label
To set the text, use the snackbar `label: UILabel` public property.

The label font and textColor are set by Spark and shouldn't be overriden.

### Image
To set the image, use the `setImage(_ image: UIImage?)` function.  
You can also access it via the snackbar `imageView: UIImageView?` public property.

The imageView size and tintColor is managed by Spark and shouldn't be overriden.

### Button
To set a button, add it using the `addButton()` function and set it from either its return value or the snackbar `buttonView: ButtonUIView?` public property.
```swift
    let buttonView = snackbar.addButton()
    buttonView.setTitle("Tap", for: .normal)
```
or 
```swift
    snackbar.addButton()
    snackbar.buttonView?.setTitle("Tap", for: .normal)
```
To remove the button, use the `removeButton()` function.

The buttonView style is managed by Spark and shouldn't be overriden.

## SwiftUI

```swift
/// The SwiftUI version of the Snackbar.
public struct SnackbarView<SnackbarButton>: View where SnackbarButton: View  {

    /// Initialize a new snackbar view without button.
    /// - Parameters:
    ///   - theme: The spark theme of the snackbar.
    ///   - intent: The intent of the snackbar.
    ///   - image: The image of the snackbar. The default is ``nil``.
    ///   - text: The text of the snackbar.
    public init(
        theme: any Theme,
        intent: SnackbarIntent,
        image: Image? = nil,
        text: @escaping () -> Text
    )

    /// Initialize a new snackbar view with a `SnackbarButton`.
    /// - Parameters:
    ///   - theme: The spark theme of the snackbar.
    ///   - intent: The intent of the snackbar.
    ///   - image: The image of the snackbar. The default is ``nil``.
    ///   - text: The text of the snackbar.
    ///   - button: The button builder. It has as a parameter the expected returned ButtonView's configuration.
    public init(
        theme: any Theme,
        intent: SnackbarIntent,
        image: Image? = nil,
        text: @escaping () -> Text,
        button: @escaping (SnackbarView.ButtonConfiguration) -> SnackbarButton
    )

    /// Initialize a new snackbar view with a `SnackbarButton`.
    /// - Parameters:
    ///   - theme: The spark theme of the snackbar.
    ///   - intent: The intent of the snackbar.
    ///   - image: The image of the snackbar. The default is ``nil``.
    ///   - text: The text of the snackbar.
    ///   - button: The button builder. It has as a parameter the expected returned ButtonView.
    ///   - action: The button's action.
    public init(
        theme: any Theme,
        intent: SnackbarIntent,
        image: Image? = nil,
        text: @escaping () -> Text,
        button: @escaping (ButtonView) -> SnackbarButton,
        action: @escaping () -> Void
    )
}
```

### Modifiers

```swift
    /// Snackbar's theme modifier.
    /// - Parameter theme: The modified spark theme for the snackbar.
    /// - Returns: The updated snackbar.
    public func theme(_ theme: any Theme) -> Self

    /// Snackbar's intent modifier.
    /// - Parameter intent: The modified intent for the snackbar.
    /// - Returns: The updated snackbar.
    public func intent(_ intent: SnackbarIntent) -> Self

    /// Snackbar's variant modifier.
    /// - Parameter variant: The modified variant for the snackbar.
    /// - Returns: The updated snackbar.
    public func variant(_ variant: SnackbarVariant) -> Self

    /// Snackbar's type modifier.
    /// - Parameter type: The modified type for the snackbar.
    /// - Returns: The updated snackbar.
    public func type(_ type: SnackbarType) -> Self
```

## Properties

### Intent

```swift
/// The intent of the snackbar.
public enum SnackbarIntent: CaseIterable {
    case success
    case alert
    case error
    case info
    case neutral
    case main
    case basic
    case support
    case accent
    case surfaceInverse

    /// Get the colors to apply on snackbars from an intent
    /// - Parameters:
    ///   - theme: Spark theme
    ///   - variant: The variant of the snackbar
    /// - Returns: SnackbarColors
    public func getColors(
        theme: Theme,
        variant: SnackbarVariant
    ) -> SnackbarColors
}

/// Snackbar colors
public struct SnackbarColors {
    /// Snackbar background color
    let background: any ColorToken
    /// Snackbar foreground color
    let foreground: any ColorToken
}
```

### Variant

```swift
/// The variant of the snackbar.
public enum SnackbarVariant: CaseIterable {
    case filled
    case tinted
}
````

### Type

```swift
/// The type of the snackbar.
public enum SnackbarType: CaseIterable {
    case horizontal
    case vertical
}
```

Note: `SnackbarIntent.surfaceInverse` with `SnackbarVariant.tinted` will have the same colors as with the `.filled` variant.


## License

```
MIT License

Copyright (c) 2024 Adevinta

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```
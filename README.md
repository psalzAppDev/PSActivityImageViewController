# PSActivityImageViewController

## Overview

This view controller allows you to share an image the same way as a normal
`UIActivityViewController` would, with one bonus: The image is actually shown on top of the
`UIActivityViewController` with a nice blurred background.

You can add any items you want to share, but only the image is displayed.

<img src="https://github.com/psalzAppDev/PSActivityImageViewController/blob/main/Assets/PSActivityImageViewController_screen_iPhone.png" width="100" height="100" />

![Screenshot iPhone](https://github.com/psalzAppDev/PSActivityImageViewController/blob/main/Assets/PSActivityImageViewController_screen_iPhone.png)

![Screenshot iPad Landscape](https://github.com/psalzAppDev/PSActivityImageViewController/blob/main/Assets/PSActivityImageViewController_screen_iPad_landscape.png)

![Screenshot iPad Portrait](https://github.com/psalzAppDev/PSActivityImageViewController/blob/main/Assets/PSActivityImageViewController_screen_iPad_portrait.png)

## Input

- `image`: The image you want to share and at the same time display as a preview.
- `activityItems`: All the items you want to share, with the `image` included.
- `completion`: An optional `UIActivityViewController.CompletionWithItemsHandler`
 to handle any code after completion.

## Usage

```swift
import PSActivityImageViewController

...

let activityImageVC = ActivityImageViewController(
   image: someImage,
   activityItems: [someImage, self], // or just [someImage]
   completion: { activity, completed, _, error in

       if let error = error {
           print("Error: \(error.localizedDescription)")
           return
       }

       // Do something with the rest of the information.
   }
)

// Important for iPad, as otherwise the app will crash!
activityImageVC.popoverPresentationController?.sourceView = someView
activityImageVC.popoverPresentationController?.sourceRect = someView.bounds

present(activityImageVC, animated: true)
```

## Warning

As is the case for `UIActivityViewController`, on iPad you need to specify the source for
 the `popoverPresentationController`.

## Installation

#### Swift Package Manager

PSActivityImageViewController is available through [Swift Package Manager](https://swift.org/package-manager).

Add it to an existing Xcode project as a package dependency:

1. From the **File** menu, select **Swift Packages › Add Package Dependency…**
2. Enter "https://github.com/psalzAppDev/PSActivityImageController" into the package repository URL text field

## Requirements

* iOS 10.0+
* Xcode 12+

## License

PSActivityImageViewController is available under the MIT license. See the LICENSE file for more info.



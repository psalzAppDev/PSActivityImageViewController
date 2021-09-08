# PSActivityImageViewController

## Overview

This view controller allows you to share an image the same way as a normal
`UIActivityViewController` would, with one bonus: The image is actually shown on top of the
`UIActivityViewController` with a nice blurred background.

You can add any items you want to share, but only the image is displayed.

A SwiftUI adaptation is also available, based on the excellent work in [ActivityView](https://github.com/SwiftUI-Plus/ActivityView).

## Screenshots

These screenshots are taken from my app TwoSlideOver. Check it out [here](https://apps.apple.com/app/twoslideover/id1547137384)

<img src="https://github.com/psalzAppDev/PSActivityImageViewController/blob/main/Assets/PSActivityImageViewController_screen_iPhone.png" width="236" height="512" />

<img src="https://github.com/psalzAppDev/PSActivityImageViewController/blob/main/Assets/PSActivityImageViewController_screen_iPad_landscape.png" width="512" height="384" />

<img src="https://github.com/psalzAppDev/PSActivityImageViewController/blob/main/Assets/PSActivityImageViewController_screen_iPad_portrait.png" width="384" height="512" />

## Videos

<img src="https://github.com/psalzAppDev/PSActivityImageViewController/blob/main/Assets/PSActivityImageViewController_iPhone_normal.gif" width="296" height="640" />

<img src="https://github.com/psalzAppDev/PSActivityImageViewController/blob/main/Assets/PSActivitymageViewController_iPhone_dual.gif" width="296" height="640" />

<img src="https://github.com/psalzAppDev/PSActivityImageViewController/blob/main/Assets/PSActivityImageViewController_gif_iPad.gif" width="640" height="480" />

## Input

- `image`: The image you want to share and at the same time display as a preview.
- `activityItems`: All the items you want to share, with the `image` included.
- `activities`: Optional array of `UIActivity`
- `excludedTypes`: Optional array of excluded activity types.
- `completion`: An optional `UIActivityViewController.CompletionWithItemsHandler`
 to handle any code after completion.

## Usage

### UIKit

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

### SwiftUI

```swift
import SwiftUI
import PSActivityImageViewController

struct ContentView: View {
    
    let image = Image("Image")
    
    @State
    var activityItem: ActivityImageItem? = nil
    
    var body: some View {
        
        VStack(spacing: 16) {
                
            image
                .resizable()
                .aspectRatio(contentMode: .fit)
                .padding()
            
            Button(
                action: {
                    activityItem = ActivityImageItem(image: image)
                },
                label: {
                    Text("Share image")
                }
            )
            .activityImageSheet($activityItem)
        }
        .padding()
    }
}
```

## Warning

As is the case for `UIActivityViewController`, on iPad you need to specify the source for
 the `popoverPresentationController`.

## Installation

#### Swift Package Manager

PSActivityImageViewController is available through [Swift Package Manager](https://swift.org/package-manager).

Add it to an existing Xcode project as a package dependency:

1. From the **File** menu, select **Swift Packages › Add Package Dependency…**
2. Enter "https://github.com/psalzAppDev/PSActivityImageViewController" into the package repository URL text field

## Requirements

* iOS 10.0+
* Xcode 12+

## License

PSActivityImageViewController is available under the MIT license. See the LICENSE file for more info.



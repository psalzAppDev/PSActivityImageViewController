//
//  ActivityImageViewController.swift
//  PSActivityImageViewController
//
//  Created by Peter Salz on 07.09.21.
//

import UIKit

/**
 This view controller allows you to share an image the same way as a normal
 `UIActivityViewController` would, with one bonus: The image is actually shown on top of the
 `UIActivityViewController` with a nice blurred background.
 
 You can add any items you want to share, but only the image is displayed.
 
 # Input
 
 - `image`: The image you want to share and at the same time display as a preview.
 - `activityItems`: All the items you want to share, with the `image` included.
 - `completion`: An optional `UIActivityViewController.CompletionWithItemsHandler`
  to handle any code after completion.
 
 # Usage
 
 ```
 let activityImageVC = ActivityImageViewController(
    image: someImage,
    activityItems: [someImage, self],
    completion: { activity, completed, _, error in
 
        if let error = error {
            print("Error: \(error.localizedDescription)")
            return
        }
 
        // Do something with the rest of the information.
    }
 )
 
 activityImageVC.popoverPresentationController?.sourceView = someView
 activityImageVC.popoverPresentationController?.sourceRect = someView.bounds
 
 present(activityImageVC, animated: true)
 
 ```
 
 - Warning: As is the case for `UIActivityViewController`, on iPad you need to specify the source for
  the `popoverPresentationController`.
 */
public class ActivityImageViewController: UIViewController {

    private var activityViewController: UIActivityViewController!

    /// This image view shows the preview image on top of a blurred view.
    private var imageView: UIImageView!
    
    /// This image view applies a blur effect to the image as a nice background.
    private var blurredImageView: UIImageView!
    
    /// The `UIActivityViewController` will be embedded as a child view controller, so this view
    /// will hold the `UIActivityViewController`'s view.
    private var activityView: UIView!
    
    @available(*, unavailable)
    public override init(
        nibName nibNameOrNil: String?,
        bundle nibBundleOrNil: Bundle?
    ) {
        fatalError("This initializer is not supported.")
    }
    
    /**
     The only valid initializer for `ActivityImageViewController`.
     
     - Parameters:
        - image: The image you want to share and at the same time display as a preview.
        - activityItems: All the items you want to share, with the `image` included.
        - completion: An optional
         `UIActivityViewController.CompletionWithItemsHandler` to handle any code after
         completion.
     
     - Warning: As is the case for `UIActivityViewController`, on iPad you need to specify the source for
      the `popoverPresentationController` after initialization.
     */
    public init(
        image: UIImage,
        activityItems: [Any],
        completion: UIActivityViewController.CompletionWithItemsHandler? = nil
    ) {
        
        super.init(nibName: nil, bundle: nil)
        
        // Ensure popover presentation style.
        self.modalPresentationStyle = .popover
        
        // Setup the image view.
        self.imageView = UIImageView(image: image)
        self.imageView.contentMode = .scaleAspectFit
        self.imageView.clipsToBounds = true
        
        // Setup the blurred image view.
        self.blurredImageView = UIImageView(image: image)
        self.blurredImageView.contentMode = .scaleAspectFill
        
        // Setup the activity view controller.
        self.activityViewController = UIActivityViewController(
            activityItems: activityItems,
            applicationActivities: nil
        )
        
        // Set the optional completion handler
        self.activityViewController.completionWithItemsHandler = completion
        
        // Add the activityViewController as a child view controller
        self.addChild(self.activityViewController)
        
        // Store the activityViewController's view here.
        self.activityView = self.activityViewController.view
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Ensure that the view controller has the correct size.
        // Confer: https://useyourloaf.com/blog/self-sizing-popovers/
        preferredContentSize = view.systemLayoutSizeFitting(
            UIView.layoutFittingCompressedSize
        )
        
        // Setup the blurred image view.
        
        blurredImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(blurredImageView)
        
        let blurEffect: UIBlurEffect
        
        if #available(iOS 13, *) {
            blurEffect = UIBlurEffect(style: .systemUltraThinMaterial)
        } else {
            blurEffect = UIBlurEffect(style: .extraLight)
        }
        
        let blurredEffectView = UIVisualEffectView(effect: blurEffect)
        blurredEffectView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(blurredEffectView)
        
        // Add the image view as a subview to the blurred image view.
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        blurredEffectView.contentView.addSubview(imageView)
        
        // Add the activityView as a subview.
        
        activityView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(activityView)
        
        // Setup autolayout constraints.
        
        let constraints: [NSLayoutConstraint] = [
            blurredImageView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor
            ),
            blurredImageView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor
            ),
            blurredImageView.topAnchor.constraint(
                equalTo: view.layoutMarginsGuide.topAnchor
            ),
            blurredImageView.heightAnchor.constraint(
                equalTo: view.heightAnchor,
                multiplier: 0.5
            ),
            
            blurredEffectView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor
            ),
            blurredEffectView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor
            ),
            blurredEffectView.topAnchor.constraint(
                equalTo: view.layoutMarginsGuide.topAnchor
            ),
            blurredEffectView.heightAnchor.constraint(
                equalTo: view.heightAnchor,
                multiplier: 0.5
            ),
            
            imageView.leadingAnchor.constraint(
                equalTo: blurredEffectView.contentView.leadingAnchor
            ),
            imageView.trailingAnchor.constraint(
                equalTo: blurredEffectView.contentView.trailingAnchor
            ),
            imageView.topAnchor.constraint(
                equalTo: blurredEffectView.contentView.topAnchor
            ),
            imageView.bottomAnchor.constraint(
                equalTo: blurredEffectView.contentView.bottomAnchor
            ),
            
            activityView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor
            ),
            activityView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor
            ),
            activityView.bottomAnchor.constraint(
                equalTo: view.bottomAnchor
            ),
            activityView.topAnchor.constraint(
                equalTo: imageView.bottomAnchor
            )
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
}

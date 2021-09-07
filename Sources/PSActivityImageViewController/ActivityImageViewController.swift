//
//  ActivityImageViewController.swift
//  PSActivityImageViewController
//
//  Created by Peter Salz on 07.09.21.
//

import UIKit

public class ActivityImageViewController: UIViewController {

    private var activityViewController: UIActivityViewController!
    private var imageView: UIImageView!
    private var blurredImageView: UIImageView!
    private var activityView: UIView!
    
    @available(*, unavailable)
    public override init(
        nibName nibNameOrNil: String?,
        bundle nibBundleOrNil: Bundle?
    ) {
        fatalError("This initializer is not supported.")
    }
    
    public init(
        image: UIImage,
        activityItems: [Any],
        completion: UIActivityViewController.CompletionWithItemsHandler? = nil
    ) {
        
        super.init(nibName: nil, bundle: nil)
        
        self.modalPresentationStyle = .popover
        
        self.imageView = UIImageView(image: image)
        self.imageView.contentMode = .scaleAspectFit
        self.imageView.clipsToBounds = true
        
        self.blurredImageView = UIImageView(image: image)
        self.blurredImageView.contentMode = .scaleAspectFill
        
        self.activityViewController = UIActivityViewController(
            activityItems: activityItems,
            applicationActivities: nil
        )
        
        self.activityViewController.completionWithItemsHandler = nil
        
        self.addChild(self.activityViewController)
        
        self.activityView = self.activityViewController.view
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        
        super.viewDidLoad()
        
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
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        blurredEffectView.contentView.addSubview(imageView)
        
        activityView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(activityView)
        
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

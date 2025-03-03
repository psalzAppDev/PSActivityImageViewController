//
//  ActivityImageView.swift
//  PSActivityImageViewController
//
//  Created by Peter Salz on 08.09.21.
//

#if canImport(SwiftUI)

import SwiftUI

@available(iOS 13, *)
public extension View {
    
    /**
     Presents an activity sheet when the associated `ActivityItem` is present.
     
     The system provides several standard services, such as copying items to the pasteboard, posting
     content to social media sites, sending items via email or SMS, and more. Apps can also define custom
     services.
     
     - Parameters:
        - image: The image you want to share and display as a preview.
        - item: The item to use for this activity.
        - onComplete: When the sheet is dismissed, this will be called with the result.
     */
    func activityImageSheet(
        _ item: Binding<ActivityImageItem?>,
        permittedArrowDirections: UIPopoverArrowDirection = .any,
        onComplete: UIActivityViewController.CompletionWithItemsHandler? = nil
    ) -> some View {
        
        background(
            ActivityView(
                item: item,
                permittedArrowDirections: permittedArrowDirections,
                onComplete: onComplete
            )
        )
    }
}

@available(iOS 13, *)
private struct ActivityView: UIViewControllerRepresentable {
    
    @Binding
    var item: ActivityImageItem?
    
    private var permittedArrowDirections: UIPopoverArrowDirection
    private var completion: UIActivityViewController.CompletionWithItemsHandler?
    
    public init(
        item: Binding<ActivityImageItem?>,
        permittedArrowDirections: UIPopoverArrowDirection,
        onComplete: UIActivityViewController.CompletionWithItemsHandler? = nil
    ) {
        
        self._item = item
        self.permittedArrowDirections = permittedArrowDirections
        self.completion = onComplete
    }
    
    func makeUIViewController(
        context: Context
    ) -> ActivityViewControllerWrapper {
        
        ActivityViewControllerWrapper(
            item: $item,
            permittedArrowDirections: permittedArrowDirections,
            completion: completion
        )
    }
    
    func updateUIViewController(
        _ uiViewController: ActivityViewControllerWrapper,
        context: Context
    ) {
        
        uiViewController.item = $item
        uiViewController.completion = completion
        uiViewController.updateState()
    }
}

@available(iOS 13, *)
private final class ActivityViewControllerWrapper: UIViewController {
    
    var item: Binding<ActivityImageItem?>
    var permittedArrowDirections: UIPopoverArrowDirection
    var completion: UIActivityViewController.CompletionWithItemsHandler?
    
    init(
        item: Binding<ActivityImageItem?>,
        permittedArrowDirections: UIPopoverArrowDirection,
        completion: UIActivityViewController.CompletionWithItemsHandler?
    ) {
        
        self.item = item
        self.permittedArrowDirections = permittedArrowDirections
        self.completion = completion
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(toParent parent: UIViewController?) {
        
        super.didMove(toParent: parent)
        updateState()
    }
    
    fileprivate func updateState() {
        
        let isActivityPresented = presentedViewController != nil
        
        guard let item = item.wrappedValue,
              !isActivityPresented else {
            
            return
        }

        // https://github.com/psalzAppDev/PSActivityImageViewController/issues/1
        //let uiImage = item.image.snapshot()
        let uiImage = item.image
        var completeItems: [Any] = [uiImage]
        completeItems.append(contentsOf: item.items)
        
        let controller = ActivityImageViewController(
            image: uiImage,
            activityItems: completeItems,
            activities: item.activities,
            excludedTypes: item.excludedTypes,
            completion: { [weak self] activityType, success, items, error in
                
                self?.item.wrappedValue = nil
                self?.completion?(activityType, success, items, error)
            }
        )
        
        controller.popoverPresentationController?.permittedArrowDirections
            = permittedArrowDirections
        
        controller.popoverPresentationController?.sourceView = view
        
        present(
            controller,
            animated: true,
            completion: { [weak self] in

                // This fixes a loop where the controller is shown over and over
                // again if the controller is dismissed by swiping down instead
                // of tapping the X button or completing the share process.
                self?.item.wrappedValue = nil
            }
        )
    }
}

/*
@available(iOS 13, *)
extension View {
    
    func snapshot() -> UIImage {
        
        let controller = UIHostingController(rootView: self)
        let view = controller.view
        
        let targetSize = controller.view.intrinsicContentSize
        
        view?.bounds = CGRect(origin: .zero, size: targetSize)
        view?.backgroundColor = .clear
        
        let renderer = UIGraphicsImageRenderer(size: targetSize)
        
        return renderer.image { _ in
            
            view?.drawHierarchy(
                in: controller.view.bounds,
                afterScreenUpdates: true
            )
        }
    }
}
*/

#endif


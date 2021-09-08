//
//  ActivityItem.swift
//  PSActivityImageViewController
//
//  Created by Peter Salz on 08.09.21.
//

import UIKit

/// Represents an activity for presenting an `ActivityView` (share sheet) via the `activitySheet`
/// modifier.
@available(iOS 13, *)
public struct ActivityItem {
    
    internal var image: UIImage
    internal var items: [Any]
    internal var activities: [UIActivity]
    internal var excludedTypes: [UIActivity.ActivityType]
    
    public init(
        image: UIImage,
        items: Any...,
        activities: [UIActivity] = [],
        excludedTypes: [UIActivity.ActivityType] = []
    ) {
        
        self.image = image
        self.items = items
        self.activities = activities
        self.excludedTypes = excludedTypes
    }
}

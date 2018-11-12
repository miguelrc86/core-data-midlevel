//
//  ImageAttachment+CoreDataProperties.swift
//  UnCloudNotes
//
//  Created by Miguel D Rojas Cortés on 11/12/18.
//  Copyright © 2018 Ray Wenderlich. All rights reserved.
//
//

import Foundation
import CoreData
import UIKit

extension ImageAttachment {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ImageAttachment> {
        return NSFetchRequest<ImageAttachment>(entityName: "ImageAttachment")
    }

    @NSManaged public var height: Float
    @NSManaged public var width: Float
    @NSManaged public var caption: String?
    @NSManaged public var image: UIImage?

}

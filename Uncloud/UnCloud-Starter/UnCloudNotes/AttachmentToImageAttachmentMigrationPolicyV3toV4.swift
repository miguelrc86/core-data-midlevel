//
//  AttachmentToImageAttachmentMigrationPolicyV3toV4.swift
//  UnCloudNotes
//
//  Created by Miguel D Rojas Cortés on 11/12/18.
//  Copyright © 2018 Ray Wenderlich. All rights reserved.
//

import UIKit
import CoreData

class AttachmentToImageAttachmentMigrationPolicyV3toV4: NSEntityMigrationPolicy {
  
  let errorDomain = "Migration"
  
  // Core Data takes instances of managed objects from the old data model, and creates corresponding instances that work with the new data model.
  override func createDestinationInstances(forSource sInstance: NSManagedObject, in mapping: NSEntityMapping, manager: NSMigrationManager) throws {
    let newAttachment = ImageAttachment.init(entity: ImageAttachment.entity(), insertInto: manager.destinationContext)
    
    try traversePropertyMappings(mapping: mapping, block: { propertyMapping, destinationName in
      if let valueExpression = propertyMapping.valueExpression {
        let context: NSMutableDictionary = ["source": sInstance]
        guard let destinationValue = valueExpression.expressionValue(with: sInstance, context: context) else { return }
        newAttachment.setValue(destinationValue, forKey: destinationName)
        
        if let image = sInstance.value(forKey: "image") as? UIImage {
          newAttachment.setValue(image.size.width, forKey: "width")
          newAttachment.setValue(image.size.height, forKey: "height")
        }
        
        let body = sInstance.value(forKeyPath: "note.body") as? NSString ?? ""
        newAttachment.setValue(body.substring(to: 80), forKey: "caption")
        manager.associate(sourceInstance: sInstance, withDestinationInstance: newAttachment, for: mapping)
      }
    })
  }
  
  func traversePropertyMappings(mapping:NSEntityMapping, block: (NSPropertyMapping, String) -> ()) throws {
    if let attributeMappings = mapping.attributeMappings {
      for propertyMapping in attributeMappings {
        if let destinationName = propertyMapping.name {
          block(propertyMapping, destinationName)
        } else {
          let message = "Attribute destination not configured properly"
          let userInfo = [NSLocalizedFailureReasonErrorKey: message]
          throw NSError(domain: errorDomain, code: 0, userInfo: userInfo)
        }
      }
    } else {
      let message = "No Attribute Mappings found!"
      let userInfo = [NSLocalizedFailureReasonErrorKey: message]
      throw NSError(domain: errorDomain, code: 0, userInfo: userInfo)
    }
  }
  
}

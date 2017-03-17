//
//  CollectionCellDescriptable.swift
//  Pods
//
//  Created by Guihal Gwenn on 16/03/17.
//
//

import Foundation
import UIKit
import ObjectiveC

private struct AssociatedKeys {
    static var IndexPath = "vs_IndexPath"
}

public protocol CollectionCellDescriptable : class {
    var identifier: String { get }
    var className: String { get }
    var selectable: Bool { get }
    var adapter:CollectionAdapter { get }
    func size(_ collectionView: UICollectionView, sectionDescriptor: CollectionSectionDescriptable) -> CGSize
}

extension CollectionCellDescriptable {
    public var indexPath: IndexPath {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.IndexPath) as! IndexPath
        }
        set {
            objc_setAssociatedObject( self, &AssociatedKeys.IndexPath, newValue as IndexPath, .OBJC_ASSOCIATION_COPY)
        }
    }
}

func ==(lhs: CollectionCellDescriptable, rhs: CollectionCellDescriptable) -> Bool {
    return lhs.indexPath == rhs.indexPath
}

func !=(lhs: CollectionCellDescriptable, rhs: CollectionCellDescriptable) -> Bool {
    return lhs.indexPath != rhs.indexPath
}

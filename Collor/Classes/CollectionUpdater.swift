//
//  CollectionUpdater.swift
//  Pods
//
//  Created by Guihal Gwenn on 05/04/17.
//
//

import Foundation

public extension NSExceptionName {
    static let collorMissingSectionUID = NSExceptionName("collor.missingSectionUID")
    static let collorMissingItemUID = NSExceptionName("collor.missingItemUID")
    static let collorDuplicateItemUID = NSExceptionName("collor.duplicateItemUID")
    static let collorDuplicateSectionUID = NSExceptionName("collor.duplicateSectionUID")
    static let collorSectionIndexNil = NSExceptionName("collor.sectionIndexNil")
    static let collorSectionBuilderNil = NSExceptionName("collor.sectionBuilderNil")
}

final public class CollectionUpdater {
    
    var result:UpdateCollectionResult?
    
    unowned let collectionDatas:CollectionDatas
    
    init(collectionDatas:CollectionDatas) {
        self.collectionDatas = collectionDatas
    }
    
    public func append(cells:[CollectionCellDescribable], after cell:CollectionCellDescribable) {
        guard let indexPath = cell.indexPath else {
            return
        }
        guard let section = collectionDatas.sections[safe: indexPath.section] else {
            return
        }
        section.cells.insert(contentsOf: cells, at: indexPath.item + 1)
        collectionDatas.computeIndices()
        
        result?.insertedCellDescriptors.append(contentsOf: cells)
        result?.insertedIndexPaths.append(contentsOf: cells.map{ $0.indexPath! } ) // unwrapped because computeIndices() called before
    }
    
    public func append(cells:[CollectionCellDescribable], before cell:CollectionCellDescribable) {
        guard let indexPath = cell.indexPath else {
            return
        }
        guard let section = collectionDatas.sections[safe: indexPath.section] else {
            return
        }
        section.cells.insert(contentsOf: cells, at: indexPath.item)
        collectionDatas.computeIndices()
        
        result?.insertedCellDescriptors.append(contentsOf: cells)
        result?.insertedIndexPaths.append(contentsOf: cells.map{ $0.indexPath! } ) // unwrapped because computeIndices() called before
    }
    
    public func append(cells:[CollectionCellDescribable], in section:CollectionSectionDescribable) {
        section.cells.append(contentsOf: cells)
        collectionDatas.computeIndices()
        
        result?.insertedCellDescriptors.append(contentsOf: cells)
        result?.insertedIndexPaths.append(contentsOf: cells.map{ $0.indexPath! } ) // unwrapped because computeIndices() called before
    }
    
    public func remove(cells:[CollectionCellDescribable]) {
        var needTocomputeIndices = false
        cells.forEach { cellToDelete in
            guard let section = collectionDatas.sectionDescribable(for: cellToDelete) else {
                return
            }
            guard let indexPath = cellToDelete.indexPath else {
                return
            }
            guard let index = section.cells.index(where: {$0 === cellToDelete}) else {
                return
            }
            section.cells.remove(at: index)
            result?.deletedIndexPaths.append( indexPath )
            result?.deletedCellDescriptors.append(cellToDelete )
            needTocomputeIndices = true
        }
        if needTocomputeIndices {
            collectionDatas.computeIndices()
        }
    }
    
    public func reload(cells:[CollectionCellDescribable]) {
        let cellsToReload = cells.filter{ $0.indexPath != nil }
        result?.reloadedIndexPaths.append(contentsOf: cellsToReload.map { $0.indexPath! } )
        result?.reloadedCellDescriptors.append(contentsOf: cellsToReload)
    }
    
    public func append(sections:[CollectionSectionDescribable], after section:CollectionSectionDescribable) {
        guard let sectionIndex = section.index else {
            return
        }
        collectionDatas.sections.insert(contentsOf: sections, at: sectionIndex + 1)
        result?.insertedSectionsIndexSet.insert(integersIn: Range(uncheckedBounds: (lower: sectionIndex + 1, upper: sectionIndex + 1 + sections.count)))
        result?.insertedSectionDescriptors.append(contentsOf: sections)
        collectionDatas.computeIndices()
    }
    
    public func append(sections:[CollectionSectionDescribable], before section:CollectionSectionDescribable) {
        guard let sectionIndex = section.index else {
            return
        }
        collectionDatas.sections.insert(contentsOf: sections, at: sectionIndex)
        result?.insertedSectionsIndexSet.insert(integersIn: Range(uncheckedBounds: (lower: sectionIndex, upper: sectionIndex + sections.count)))
        result?.insertedSectionDescriptors.append(contentsOf: sections)
        collectionDatas.computeIndices()
    }
    
    public func append(sections:[CollectionSectionDescribable]) {
        let oldSectionsCount = collectionDatas.sections.count
        collectionDatas.sections.append(contentsOf: sections)
        result?.insertedSectionsIndexSet.insert(integersIn: Range(uncheckedBounds: (lower: oldSectionsCount, upper: oldSectionsCount + sections.count)))
        result?.insertedSectionDescriptors.append(contentsOf: sections)
        collectionDatas.computeIndices()
    }
    
    public func remove(sections:[CollectionSectionDescribable]) {
        var needTocomputeIndices = false
        sections.forEach { (sectionToDelete) in
            guard let index = collectionDatas.sections.index(where: {$0 === sectionToDelete} ) else  {
                return
            }
            collectionDatas.sections.remove(at: index)
            result?.deletedSectionsIndexSet.insert(index)
            result?.deletedSectionDescriptors.append(sectionToDelete)
            needTocomputeIndices = true
        }
        if needTocomputeIndices {
            collectionDatas.computeIndices()
        }
    }
    
    public func reload(sections:[CollectionSectionDescribable]) {
        sections.forEach { (sectionToReload) in
            guard let index = collectionDatas.sections.index(where: {$0 === sectionToReload} ) else {
                return
            }
            result?.reloadedSectionsIndexSet.insert(index)
            result?.reloadedSectionDescriptors.append(sectionToReload)
        }
    }
}

public struct UpdateCollectionResult {
    
    public var insertedIndexPaths = [IndexPath]()
    public var insertedCellDescriptors = [CollectionCellDescribable]()
    
    public var deletedIndexPaths = [IndexPath]()
    public var deletedCellDescriptors = [CollectionCellDescribable]()
    
    public var reloadedIndexPaths = [IndexPath]()
    public var reloadedCellDescriptors = [CollectionCellDescribable]()
    
    public var insertedSectionsIndexSet = IndexSet()
    public var insertedSectionDescriptors = [CollectionSectionDescribable]()
    
    public var deletedSectionsIndexSet = IndexSet()
    public var deletedSectionDescriptors = [CollectionSectionDescribable]()
    
    public var reloadedSectionsIndexSet = IndexSet()
    public var reloadedSectionDescriptors = [CollectionSectionDescribable]()
}

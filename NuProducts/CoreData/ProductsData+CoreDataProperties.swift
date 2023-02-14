//
//  ProductsData+CoreDataProperties.swift
//  NuProducts
//
//  Created by Nagendra Babu on 13/02/23.
//

import Foundation
import CoreData

public extension Items {
    @nonobjc class func fetchRequest() -> NSFetchRequest<Items> {
        return NSFetchRequest<Items>(entityName: "Items")
    }

    @NSManaged var brand: String?
    @NSManaged var price: String?
    @NSManaged var rating: String?
    @NSManaged var title: String?
    @NSManaged var productId: Int32
    @NSManaged var thumbnailImage: Data?
    @NSManaged var productImages: [String]?
    

    internal class func createOrUpdate(item: Product, with stack: CoreDataStack) {
        let newsItemID = item.id
        var currentNewsPost: Items? // Entity name
        let newsPostFetch: NSFetchRequest<Items> = Items.fetchRequest()
        if let newsItemID = newsItemID {
            let newsItemIDPredicate = NSPredicate(format: "%K == %i", #keyPath(Items.productId), newsItemID)
            newsPostFetch.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [newsItemIDPredicate])
        }
        do {
            let results = try stack.managedContext.fetch(newsPostFetch)
            if results.isEmpty {
                // News post not found, create a new.
                currentNewsPost = Items(context: stack.managedContext)
                if let postID = newsItemID {
                    currentNewsPost?.productId = Int32(postID)
                }
            } else {
                // News post found, use it.
                currentNewsPost = results.first
            }
            currentNewsPost?.update(item: item)
        } catch let error as NSError {
            print("Fetch error: \(error) description: \(error.userInfo)")
        }
    }

    internal func update(item: Product) {
        self.title = item.title
        self.brand = item.brand
        self.price = "\(item.price ?? 0)"
        self.rating = "\(item.rating ?? 0.0)"

        DispatchQueue.global(qos: .userInteractive).async {
            if let imageUrl = item.thumbnail {
                do {
                    let imageData = try Data(contentsOf: URL(string: imageUrl)!)
                    self.thumbnailImage = imageData
                } catch {
                    print("Unable to load data: \(error)")
                }
            }
            AppDelegate.sharedAppDelegate.coreDataStack.saveContext()
        }
    }
}

extension Items: Identifiable {}

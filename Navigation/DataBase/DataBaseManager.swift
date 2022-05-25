//
//  DataBaseManager.swift
//  Navigation
//
//  Created by Natali Malich
//

import Foundation
import CoreData
import UIKit

class DataBaseManager {
    static let shared = DataBaseManager()
    
    private lazy var managedObjectModel: NSManagedObjectModel = {
          guard let modelURL = Bundle.main.url(forResource: "PostModel", withExtension: "momd") else {
              fatalError("Unable to Find Data Model")
          }

          guard let managedObjectModel = NSManagedObjectModel(contentsOf: modelURL) else {
              fatalError("Unable to Load Data Model")
          }

          return managedObjectModel
      }()

    private lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
            let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)

            let storeName = "PostModel.sqlite"

            let documentsDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]

            let persistentStoreURL = documentsDirectoryURL.appendingPathComponent(storeName)
            do {
                try persistentStoreCoordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: persistentStoreURL, options: nil)
            } catch {
                fatalError("Unable to Load Persistent Store")
            }
            return persistentStoreCoordinator
        }()

    private(set) lazy var managedObjectContext: NSManagedObjectContext = {
        let managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = self.persistentStoreCoordinator
        return managedObjectContext
    }()
    
    func addFavoritePost(post: Post) {
        let fetchRequest = PostModel.fetchRequest()
        do {
            let posts = try managedObjectContext.fetch(fetchRequest)
            if posts.allSatisfy({ $0.id != post.id }) {
                if let newFavoritePost = NSEntityDescription.insertNewObject(forEntityName: "PostModel", into: managedObjectContext) as? PostModel {
                    newFavoritePost.id = post.id
                    newFavoritePost.author = post.author
                    newFavoritePost.body = post.description
                    newFavoritePost.image = post.image?.pngData()
                    newFavoritePost.likes = Int32(post.likes)
                    newFavoritePost.views = Int32(post.views)
                    
                    try managedObjectContext.save()
                }
            }
        } catch let error as NSError {
            print("Favorite post not added to database: %@", error)
        }
    }
    
    func removeFavoritePost(post: Post) {
        let fetchRequest = PostModel.fetchRequest()
        do {
            let posts = try managedObjectContext.fetch(fetchRequest)
            if let indexPost = posts.firstIndex(where: { $0.id == post.id }) {
                managedObjectContext.delete(posts[indexPost])
                try managedObjectContext.save()
            }
        } catch let error as NSError {
            print("Favorite post not added to database: %@", error)
        }
    }
    
    func removeAll() {
        let fetchRequest = PostModel.fetchRequest()
        do {
            let posts = try managedObjectContext.fetch(fetchRequest)
            for post in posts {
                managedObjectContext.delete(post)
            }
            try managedObjectContext.save()
        } catch let error as NSError {
            print("Favorite post not added to database: %@", error)
        }
    }
    
    func getFavoritePosts() -> [Post] {
        var favoritePosts = [Post]()
        let fetchRequest = PostModel.fetchRequest()
        
        do {
            let posts = try managedObjectContext.fetch(fetchRequest)
           
            for post in posts {
                let id = post.id
                let author = post.author ?? ""
                let body = post.body
                let image = UIImage(data: post.image ?? Data())
                let likes = post.likes
                let views = post.views
                
                let post = Post(id: id!, author: author , description: body, image: image, filter: nil, likes: Int(likes), views: Int(views))
                favoritePosts.append(post)
            }
            
        } catch let error as NSError {
            print("Database operation failed: %@", error)
        }
        return favoritePosts
    }
    
}

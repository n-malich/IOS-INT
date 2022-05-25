//
//  CoreDataStack.swift
//  Navigation
//
//  Created by Natali Malich
//

import CoreData
import UIKit

class CoreDataStack {
    static let shared = CoreDataStack()

    let persistentContainer: NSPersistentContainer
    let fetchRequest = PostModel.fetchRequest()
    
    lazy var mainContext: NSManagedObjectContext = {
        return persistentContainer.viewContext
    }()
    
    lazy var backgroundContext: NSManagedObjectContext = {
        let privateContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        privateContext.parent = mainContext
        return privateContext
    }()

    init() {
        let container = NSPersistentContainer(name: "PostModel")
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Unable to load persistent stores: \(error)")
            }
        }
        self.persistentContainer = container
    }

    func addFavoritePost(post: Post) {
        backgroundContext.perform { [weak self] in
            guard let self = self else { return }
            do {
                let posts = try self.backgroundContext.fetch(self.fetchRequest)
                if posts.allSatisfy({ $0.id != post.id }) {
                    if let newFavoritePost = NSEntityDescription.insertNewObject(forEntityName: "PostModel", into: self.backgroundContext) as? PostModel {
                        newFavoritePost.id = post.id
                        newFavoritePost.author = post.author
                        newFavoritePost.body = post.body
                        newFavoritePost.image = post.image?.pngData()
                        newFavoritePost.likes = Int32(post.likes)
                        newFavoritePost.views = Int32(post.views)

                        try self.backgroundContext.save()
                        print("This post added")
                        
                        self.mainContext.performAndWait {
                            do {
                                try self.mainContext.save()
                            } catch {
                                fatalError("Failure to save context: \(error)")
                            }
                        }
                    }
                } else {
                    print("This post has already been added")
                }
            } catch let error as NSError {
                print("Favorite post not added to database: %@", error)
            }
        }
    }

    func removeFavoritePost(post: PostModel) {
        backgroundContext.perform { [weak self] in
            guard let self = self else { return }
            do {
                let posts = try self.backgroundContext.fetch(self.fetchRequest)
                if let indexPost = posts.firstIndex(where: { $0.id == post.id }) {
                    self.backgroundContext.delete(posts[indexPost])
                    print(posts[indexPost])
                    print("This post deleted")
                }
                try self.backgroundContext.save()

                self.mainContext.performAndWait {
                    do {
                        try self.mainContext.save()
                    } catch {
                        fatalError("Failure to save context: \(error)")
                    }
                }

            } catch let error as NSError {
                print("Favorite post not deleted to database: %@", error)
            }
        }
    }

    func getFavoritePosts() -> [Post] {
        var favoritePosts = [Post]()
        do {
            let posts = try self.backgroundContext.fetch(self.fetchRequest)
            
            for post in posts {
                let id = post.id
                let author = post.author ?? ""
                let body = post.body
                let image = UIImage(data: post.image ?? Data())
                let likes = post.likes
                let views = post.views
                
                let post = Post(id: id!, author: author , body: body, image: image, filter: nil, likes: Int(likes), views: Int(views))
                favoritePosts.append(post)
            }
            
        } catch let error as NSError {
            print("Database operation failed: %@", error)
        }
        return favoritePosts
    }
}

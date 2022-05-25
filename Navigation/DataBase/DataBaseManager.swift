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
    
    private let persistentContainer: NSPersistentContainer
    private let fetchRequest = PostModel.fetchRequest()
    private lazy var context = persistentContainer.newBackgroundContext()

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
        context.perform { [weak self] in
            guard let self = self else { return }
            do {
                let posts = try self.context.fetch(self.fetchRequest)
                if posts.allSatisfy({ $0.id != post.id }) {
                    if let newFavoritePost = NSEntityDescription.insertNewObject(forEntityName: "PostModel", into: self.context) as? PostModel {
                        newFavoritePost.id = post.id
                        newFavoritePost.author = post.author
                        newFavoritePost.body = post.description
                        newFavoritePost.image = post.image?.pngData()
                        newFavoritePost.likes = Int32(post.likes)
                        newFavoritePost.views = Int32(post.views)
                        
                        try self.context.save()
                    }
                }
            } catch let error as NSError {
                print("Favorite post not added to database: %@", error)
            }
        }
    }
    
    func getCountPosts() -> Int {
        do {
            let posts = try context.count(for: fetchRequest)
            return posts
        } catch let error as NSError {
            print("Database operation failed: %@", error)
            return 0
        }
    }
    
    func getFavoritePosts() -> [Post] {
        var favoritePosts = [Post]()
        do {
            let posts = try context.fetch(fetchRequest)

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
    
    func getFavoritePostsWithPredicate(author: String?) -> [Post] {
        var favoritePostsOfAuthor = [Post]()
        if let author = author, !author.isEmpty {
//            fetchRequest.predicate = NSPredicate(format: "%K == %@", #keyPath(PostModel.author), author)
            fetchRequest.predicate = NSPredicate(format: "%K CONTAINS %@", #keyPath(PostModel.author), author)
        } else {
            fetchRequest.predicate = nil
        }

        do {
            let posts = try context.fetch(fetchRequest)

            for post in posts {
                let id = post.id
                let author = post.author ?? ""
                let body = post.body
                let image = UIImage(data: post.image ?? Data())
                let likes = post.likes
                let views = post.views

                let post = Post(id: id!, author: author , description: body, image: image, filter: nil, likes: Int(likes), views: Int(views))
                favoritePostsOfAuthor.append(post)
            }

        } catch let error as NSError {
            print("Database operation failed: %@", error)
        }
        return favoritePostsOfAuthor
    }
    
    func removeFavoritePost(post: Post) {
        do {
            let posts = try self.context.fetch(self.fetchRequest)
            if let indexPost = posts.firstIndex(where: { $0.id == post.id }) {
                self.context.delete(posts[indexPost])
                try self.context.save()
            }
        } catch let error as NSError {
            print("Favorite post not added to database: %@", error)
        }
    }
    
    func removeAll() {
        do {
            let posts = try self.context.fetch(self.fetchRequest)
            for post in posts {
                self.context.delete(post)
            }
            try self.context.save()
        } catch let error as NSError {
            print("Favorite post not added to database: %@", error)
        }
    }
}

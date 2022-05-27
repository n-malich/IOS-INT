//
//  FavoritePostsViewController.swift
//  Navigation
//
//  Created by Natali Malich
//

import UIKit
import CoreData

class FavoritePostsViewController: UIViewController {
    
//    var coordinator: FavoritePostsViewControllerCoordinatorDelegate?
    
    private let postID = String(describing: PostTableViewCell.self)
    
    private let coreDataStack = CoreDataStack()
    
    private lazy var fetchedResultsController: NSFetchedResultsController<PostModel> = {
        let fetchRequest: NSFetchRequest<PostModel> = PostModel.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "author", ascending: false)]

        let fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: coreDataStack.mainContext,
            sectionNameKeyPath: nil,
            cacheName: nil)
        fetchedResultsController.delegate = self
        return fetchedResultsController
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.barStyle = .default
        searchBar.placeholder = "Search by author"
        searchBar.sizeToFit()
        return searchBar
    }()
   
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super .viewDidLoad()
        setupViews()
        setupConstraints()
        
        tableView.register(PostTableViewCell.self, forCellReuseIdentifier: postID)
        tableView.dataSource = self
        tableView.delegate = self
        
        searchBar.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        coreDataStack.mainContext.perform {
            do {
                try self.fetchedResultsController.performFetch()
                self.tableView.reloadData()
            } catch let error as NSError {
                print("Fetching error: \(error), \(error.userInfo)")
            }
        }
    }
}

extension FavoritePostsViewController {
    private func setupViews() {
        view.addSubview(tableView)
    }
}

extension FavoritePostsViewController {
    private func setupConstraints() {
        [
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ]
        .forEach {$0.isActive = true}
    }
}

extension FavoritePostsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sectionInfo = fetchedResultsController.sections?[section] else { return 0 }
        return sectionInfo.numberOfObjects
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: PostTableViewCell = tableView.dequeueReusableCell(withIdentifier: postID, for: indexPath) as! PostTableViewCell
        
        let object = fetchedResultsController.object(at: indexPath)
        let id = object.id
        let author = object.author ?? ""
        let body = object.body
        let image = UIImage(data: object.image ?? Data())
        let likes = object.likes
        let views = object.views
        
        cell.post = Post(id: id!, author: author, body: body, image: image, filter: nil, likes: Int(likes), views: Int(views))
        
        cell.iconLikes.image = UIImage(systemName: "heart.fill")
        cell.iconLikes.tintColor = .red
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .destructive, title: "Удалить") { [weak self] (_, _, callback) in
            guard let self = self else { return }
            let post = self.fetchedResultsController.object(at: indexPath)
            self.coreDataStack.removeFavoritePost(post: post)
            callback(true)
        }
        let configuration = UISwipeActionsConfiguration(actions: [action])
        configuration.performsFirstActionWithFullSwipe = true
        return configuration
    }
}

extension FavoritePostsViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.text = ""
        searchBar.resignFirstResponder()
        fetchedResultsController.fetchRequest.predicate = nil
        do {
            try self.fetchedResultsController.performFetch()
            self.tableView.reloadData()
        } catch let error as NSError {
            print("Fetching error: \(error), \(error.userInfo)")
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        var predicate: NSPredicate? = nil
        if searchText != "" {
            predicate = NSPredicate(format: "%K CONTAINS %@", #keyPath(PostModel.author), searchText)
        }
        fetchedResultsController.fetchRequest.predicate = predicate
        do {
            try self.fetchedResultsController.performFetch()
            self.tableView.reloadData()
        } catch let error as NSError {
            print("Fetching error: \(error), \(error.userInfo)")
        }
    }
}

extension FavoritePostsViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            guard let newIndexPath = newIndexPath else { fallthrough }
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        case .delete:
            guard let indexPath = indexPath else { fallthrough }
            tableView.deleteRows(at: [indexPath], with: .automatic)
        case .update:
            guard let indexPath = indexPath else { fallthrough }
            tableView.reloadRows(at: [indexPath], with: .automatic)
        case .move:
            guard let indexPath = indexPath, let newIndexPath = newIndexPath else { fallthrough }
            tableView.moveRow(at: indexPath, to: newIndexPath)
        @unknown default:
            fatalError()
        }
    }
     
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
}

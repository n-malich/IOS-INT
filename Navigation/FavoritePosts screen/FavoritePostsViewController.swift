//
//  FavoritePostsViewController.swift
//  Navigation
//
//  Created by Natali Malich
//

import UIKit

class FavoritePostsViewController: UIViewController {
    
//    var coordinator: FavoritePostsViewControllerCoordinatorDelegate?
    
    private let postID = String(describing: PostTableViewCell.self)
    
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
        
//Удаление поста из избранного по двойному нажатию на пост
//        setUpGestureRecognizer()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
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
        return DataBaseManager.shared.getCountPosts()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: PostTableViewCell = tableView.dequeueReusableCell(withIdentifier: postID, for: indexPath) as! PostTableViewCell
        cell.post = DataBaseManager.shared.getFavoritePostsWithPredicate(author: searchBar.text)[indexPath.row]
        cell.iconLikes.image = UIImage(systemName: "heart.fill")
        cell.iconLikes.tintColor = .red
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        DataBaseManager.shared.removeFavoritePost(post: DataBaseManager.shared.getFavoritePostsWithPredicate(author: nil)[indexPath.row])
        tableView.reloadData()
    }
}

extension FavoritePostsViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.text = nil
        searchBar.resignFirstResponder()
        DataBaseManager.shared.getFavoritePostsWithPredicate(author: searchBar.text)
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        DataBaseManager.shared.getFavoritePostsWithPredicate(author: searchText)
        tableView.reloadData()
    }
}

//extension FavoritePostsViewController {
//    private func setUpGestureRecognizer() {
//        let doubleTapGestureOnCell = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap))
//        doubleTapGestureOnCell.numberOfTapsRequired = 2
//        tableView.addGestureRecognizer(doubleTapGestureOnCell)
//    }
//
//    @objc private func handleDoubleTap(_ tapGesture: UITapGestureRecognizer) {
//        if tapGesture.state == .ended {
//            let location = tapGesture.location(in: self.tableView)
//            if let indexPath = tableView.indexPathForRow(at: location), let cell = tableView.cellForRow(at: indexPath) as? PostTableViewCell, let post = cell.post {
//                DataBaseManager.shared.removeFavoritePost(post: post)
//                tableView.reloadData()
//                print("Post removed")
//            }
//        }
//    }
//}

//
//  ProfileViewController.swift
//  Navigation
//
//  Created by Natali Malich
//

import UIKit

protocol ProfileViewControllerCoordinatorDelegate: AnyObject {
    func navigateToNextPage()
    func navigateToPreviousPage()
}

 class ProfileViewController: UIViewController {
     
     var delegate: LoginViewControllerDelegate?
     var coordinator: ProfileViewControllerCoordinatorDelegate?
     
     private var user: User?
     private var arrayPosts: [Post] = []
     private let headerView = ProfileHeaderView()
     private let originalTransform = ProfileHeaderView().avatarImageView.transform
     
     private let postID = String(describing: PostTableViewCell.self)
     private let photosID = String(describing: PhotosTableViewCell.self)

     private lazy var tableView: UITableView = {
         let tableView = UITableView(frame: .zero, style: .grouped)
         tableView.translatesAutoresizingMaskIntoConstraints = false
         return tableView
     }()
    
     private lazy var closeButton: UIButton = {
         let button = UIButton()
         button.setBackgroundImage(UIImage (systemName: "xmark.circle.fill"), for: .normal)
         button.tintColor = .lightGray
         button.alpha = 0
         button.addTarget(self, action: #selector(closingAvatar), for: .touchUpInside)
         button.translatesAutoresizingMaskIntoConstraints = false
         return button
     }()
     
     private lazy var signOutButton: CustomButton = {
         let button = CustomButton(title: "Delete user", titleColor: .white, backgroundColor: nil, backgroundImage: UIImage(imageLiteralResourceName: "blue_pixel"), buttonAction: { [weak self] in
             self?.delegate?.signOut()
             CurrentUserService.shared.currentUser = nil
             self?.coordinator?.navigateToPreviousPage()
         })
         button.layer.cornerRadius = 10
         button.clipsToBounds = true
         return button
     }()

     init (user: User?) {
         self.user = user
         super.init(nibName: nil, bundle: nil)
     }
     
     required init?(coder: NSCoder) {
         fatalError("init(coder:) has not been implemented")
     }
     
     override func viewDidLoad() {
         super .viewDidLoad()
        #if DEBUG
         headerView.backgroundColor = .systemRed
        #else
         headerView.backgroundColor = .clear
        #endif
         
         setupViews()
         setupConstraints()
         showUser()
         setUpGestureRecognizer()
         setupHideKeyboardOnTap()
         
         tableView.register(PostTableViewCell.self, forCellReuseIdentifier: postID)
         tableView.register(PhotosTableViewCell.self, forCellReuseIdentifier: photosID)
         tableView.dataSource = self
         tableView.delegate = self
     }
     
     override func viewWillAppear(_ animated: Bool) {
         super.viewWillAppear(animated)
         tableView.reloadData()
     }
 }

 extension ProfileViewController {
     private func setupViews() {
         [tableView, signOutButton, closeButton].forEach { view.addSubview($0)}
     }
 }

extension ProfileViewController {
    private func showUser() {
        guard let firstName = user?.firstName else { return }
        guard let lastName = user?.lastName else { return }
//        guard let posts = user?.posts else { return }
        headerView.fullNameLabel.text = firstName + " " + lastName
        headerView.statusLabel.text = user?.status
//        headerView.avatarImageView.image = user?.image
//        headerView.userID = user?.id
        arrayPosts = Posts().postsArray
    }
}

 extension ProfileViewController {
     private func setupConstraints() {
         [
             tableView.topAnchor.constraint(equalTo: view.topAnchor),
             tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
             tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
             tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
             
             closeButton.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 10),
             closeButton.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
             closeButton.widthAnchor.constraint(equalToConstant: 25),
             closeButton.heightAnchor.constraint(equalToConstant: 25),
             
             signOutButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
             signOutButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
             signOutButton.heightAnchor.constraint(equalToConstant: 30)
         ]
         .forEach {$0.isActive = true}
     }
 }

 extension ProfileViewController: UITableViewDataSource {
     func numberOfSections(in tableView: UITableView) -> Int {
         return 1
     }
     
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return arrayPosts.count + 1
     }

     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         if indexPath.row == 0 {
             let cell: PhotosTableViewCell = tableView.dequeueReusableCell(withIdentifier: photosID, for: indexPath) as! PhotosTableViewCell
             return cell
         } else {
             let cell: PostTableViewCell = tableView.dequeueReusableCell(withIdentifier: postID, for: indexPath) as! PostTableViewCell
             cell.post = arrayPosts[indexPath.row - 1]
             
//             let posts = DataBaseManager.shared.getFavoritePosts()
             let posts = DataBaseManager.shared.getFavoritePostsWithPredicate(author: nil)
             if posts.firstIndex(where: { $0.id == cell.post?.id }) != nil {
                 cell.iconLikes.image = UIImage(systemName: "heart.fill")
                 cell.iconLikes.tintColor = .red
             } else {
                 cell.iconLikes.image = UIImage(systemName: "heart")
                 cell.iconLikes.tintColor = .systemGray
             }
             
             return cell
         }
     }
 }

 extension ProfileViewController: UITableViewDelegate {
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         if indexPath.row == 0 {
             self.coordinator?.navigateToNextPage()
             tableView.deselectRow(at: indexPath, animated: true)
         } else {
             tableView.deselectRow(at: indexPath, animated: true)
         }
     }
     
     func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
             guard section == 0 else { return nil }
             return headerView
     }
 }

extension ProfileViewController {
    //Обработка нажатий на avatar и post
    private func setUpGestureRecognizer() {
        let singleTapGestureOnAvatar = UITapGestureRecognizer(target: self, action: #selector(singleTapGestureOnAvatar))
        headerView.avatarImageView.isUserInteractionEnabled = true
        headerView.avatarImageView.addGestureRecognizer(singleTapGestureOnAvatar)
        
//        let singleTapGestureOnCell = UITapGestureRecognizer(target: self, action: #selector(handleSingleTap))
//        singleTapGesture.numberOfTapsRequired = 1
//        self.addGestureRecognizer(singleTapGestureOnCell)
        
        let doubleTapGestureOnCell = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap))
        doubleTapGestureOnCell.numberOfTapsRequired = 2
        tableView.addGestureRecognizer(doubleTapGestureOnCell)
        
//        singleTapGestureOnCell.require(toFail: doubleTapGestureOnCell)
    }
    
//    @objc private func handleSingleTap(_ tapGesture: UITapGestureRecognizer) {
//
//    }
    
    @objc private func handleDoubleTap(_ tapGesture: UITapGestureRecognizer) {
        if tapGesture.state == .ended {
            let location = tapGesture.location(in: self.tableView)
            if let indexPath = tableView.indexPathForRow(at: location), let cell = tableView.cellForRow(at: indexPath) as? PostTableViewCell, let post = cell.post {
                cell.iconLikes.image = UIImage(systemName: "heart.fill")
                cell.iconLikes.tintColor = .red
                DataBaseManager.shared.addFavoritePost(post: post)
                print("Post added")
            }
        }
    }
}

 extension ProfileViewController {
     //Открытие анимированного avatarImageView
     @objc private func singleTapGestureOnAvatar() {
         UIView.animateKeyframes(withDuration: 0.5, delay: 0, options: [.calculationModeCubicPaced], animations: {
             UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.3) {
                
                self.tableView.isScrollEnabled = false
                self.tableView.allowsSelection = false
                self.signOutButton.isHidden = true

                self.headerView.avatarImageView.center = self.view.center
                let scaleFactor = self.view.bounds.width / self.headerView.avatarImageView.bounds.width
                self.headerView.avatarImageView.transform = self.headerView.avatarImageView.transform.scaledBy(x: scaleFactor, y: scaleFactor)
                self.headerView.avatarImageView.layer.borderWidth = 0
                self.headerView.avatarImageView.layer.cornerRadius = 0
                
                self.headerView.animationView.transform = CGAffineTransform(scaleX: 1, y: 1)
                self.headerView.animationView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
                self.headerView.animationView.alpha = 0.75
             }
            UIView.addKeyframe(withRelativeStartTime: 0.3, relativeDuration: 0.2) {
                self.closeButton.alpha = 1
            }
         })
     }

    //Закрытие анимированного avatarImageView
    @objc private func closingAvatar() {
        UIView.animateKeyframes(withDuration: 0.5, delay: 0, options: [.calculationModeCubicPaced], animations: {
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.3) {
                self.closeButton.alpha = 0
            }
            UIView.addKeyframe(withRelativeStartTime: 0.3, relativeDuration: 0.2) {
                self.headerView.avatarImageView.transform = self.originalTransform
                self.headerView.avatarImageView.frame = CGRect(x: 16, y: 16, width: 110, height: 110)
                self.headerView.avatarImageView.layer.cornerRadius = 55
                self.headerView.avatarImageView.layer.borderWidth = 3
                
                self.headerView.animationView.frame = CGRect(x: 16, y: 16, width: 110, height: 110)
                self.headerView.animationView.transform = CGAffineTransform(scaleX: 1, y: 1)
                self.headerView.animationView.alpha = 0
                
                self.tableView.allowsSelection = true
                self.tableView.isScrollEnabled = true
                self.signOutButton.isHidden = false
            }
        })
    }
}

extension ProfileViewController {
    //Скрытие keyboard при нажатии за пределами TextField
    private func endEditingRecognizer() -> UIGestureRecognizer {
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(self.view.endEditing(_:)))
        tap.cancelsTouchesInView = false
        return tap
    }
    
    func setupHideKeyboardOnTap() {
        view.addGestureRecognizer(self.endEditingRecognizer())
        navigationController?.navigationBar.addGestureRecognizer(self.endEditingRecognizer())
    }
}

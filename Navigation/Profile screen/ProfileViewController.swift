//
//  ProfileViewController.swift
//  Navigation
//
//  Created by Natali Mizina on 15.07.2021.
//

 import UIKit

 class ProfileViewController: UIViewController {

     let tableView: UITableView = {
         let tableView = UITableView(frame: .zero, style: .grouped)
         tableView.translatesAutoresizingMaskIntoConstraints = false
         return tableView
     }()
     
     let headerView = ProfileHeaderView()
     
     let postID = String(describing: PostTableViewCell.self)
     let photosID = String(describing: PhotosTableViewCell.self)
     
     private var arrayOFPosts = PostsVK().postsArray
    
    let closeButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage (systemName: "xmark.circle.fill"), for: .normal)
        button.tintColor = .lightGray
        button.alpha = 0
        button.addTarget(self, action: #selector(tapOnСloseButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
     
     override func viewDidLoad() {
         super .viewDidLoad()
         
         view.backgroundColor = .white
         
         setupViews()
         setupConstraints()
         setupHideKeyboardOnTap()
         
         let tapOnAvatar = UITapGestureRecognizer(target: self, action: #selector(avatarOnTap))
         headerView.avatarImageView.isUserInteractionEnabled = true
         headerView.avatarImageView.addGestureRecognizer(tapOnAvatar)
         
        setupViewCloseButton()
        setupCloseButtonConstraints()
     }
 }

 extension ProfileViewController {
     private func setupViews() {
         
         view.addSubview(tableView)
         
         tableView.register(PostTableViewCell.self, forCellReuseIdentifier: postID)
         tableView.register(PhotosTableViewCell.self, forCellReuseIdentifier: photosID)
         
         tableView.dataSource = self
         tableView.delegate = self
     }
 }

 extension ProfileViewController {
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

 extension ProfileViewController: UITableViewDataSource {
     func numberOfSections(in tableView: UITableView) -> Int {
         return 1
     }
     
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return arrayOFPosts.count + 1
     }

     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         if indexPath.row == 0 {
             let cell: PhotosTableViewCell = tableView.dequeueReusableCell(withIdentifier: photosID, for: indexPath) as! PhotosTableViewCell
             return cell
         } else {
             let cell: PostTableViewCell = tableView.dequeueReusableCell(withIdentifier: postID, for: indexPath) as! PostTableViewCell
         cell.post = arrayOFPosts[indexPath.row - 1]
             return cell
         }
     }
 }

 extension ProfileViewController: UITableViewDelegate {
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         if indexPath.row == 0 {
             let photosVC = PhotosViewController()
             navigationController?.pushViewController(photosVC, animated: true)
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
     //Скрытие keyboard при нажатии за пределами TextField
     func setupHideKeyboardOnTap() {
         view.addGestureRecognizer(self.endEditingRecognizer())
         navigationController?.navigationBar.addGestureRecognizer(self.endEditingRecognizer())
     }

     private func endEditingRecognizer() -> UIGestureRecognizer {
         let tap = UITapGestureRecognizer(target: self.view, action: #selector(self.view.endEditing(_:)))
         tap.cancelsTouchesInView = false
         return tap
     }
 }

extension ProfileViewController {
    func setupViewCloseButton() {
        view.addSubview(closeButton)
    }
}

extension ProfileViewController {
    func setupCloseButtonConstraints() {
        [
            closeButton.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 10),
            closeButton.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            closeButton.widthAnchor.constraint(equalToConstant: 25),
            closeButton.heightAnchor.constraint(equalToConstant: 25)
        ]
        .forEach {$0.isActive = true}
    }
}

private let originalTransform = ProfileHeaderView().avatarImageView.transform

 extension ProfileViewController {
     //Анимация avatarImageView
     @objc func avatarOnTap() {
         UIView.animateKeyframes(withDuration: 0.5, delay: 0, options: [.calculationModeCubicPaced], animations: {
             UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.3) {
                
                self.tableView.isScrollEnabled = false
                self.tableView.allowsSelection = false

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
 }

extension ProfileViewController {
    //Закрытие анимированного avatarImageView
    @objc func tapOnСloseButton() {
        UIView.animateKeyframes(withDuration: 0.5, delay: 0, options: [.calculationModeCubicPaced], animations: {
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.3) {
                self.closeButton.alpha = 0
            }
            UIView.addKeyframe(withRelativeStartTime: 0.3, relativeDuration: 0.2) {
                self.headerView.avatarImageView.transform = originalTransform
                self.headerView.avatarImageView.frame = CGRect(x: 16, y: 16, width: 110, height: 110)
                self.headerView.avatarImageView.layer.cornerRadius = 55
                self.headerView.avatarImageView.layer.borderWidth = 3
                
                self.headerView.animationView.frame = CGRect(x: 16, y: 16, width: 110, height: 110)
                self.headerView.animationView.transform = CGAffineTransform(scaleX: 1, y: 1)
                self.headerView.animationView.alpha = 0
                
                self.tableView.allowsSelection = true
                self.tableView.isScrollEnabled = true
            }
        })
    }
}

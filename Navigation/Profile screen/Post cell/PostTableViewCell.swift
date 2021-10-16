//
//  PostTableViewCell.swift
//  Navigation
//
//  Created by Natali Mizina on 05.08.2021.
//

import UIKit

class PostTableViewCell: UITableViewCell {
    
    var post: PostVK? {
        didSet {
            if let post = post {
                authorPost.text = post.author
                descriptionPost.text = post.description
                imagePost.image = UIImage(named: post.image)
                
                switch post.likes {
                case 0..<1000:
                    likesPost.text = "Likes: \(post.likes)"
                case 1_000..<1000_000:
                    likesPost.text = "Likes: \(post.likes / 1_000)K"
                case 1_000_000... :
                    likesPost.text = "Likes: \(post.likes / 1_000_000)Kk"
                default:
                    break
                }
                
                switch post.views {
                case 0..<1000:
                    viewsPost.text = "Views: \(post.views)"
                case 1_000..<1000_000:
                    viewsPost.text = "Views: \(post.views / 1_000)K"
                case 1_000_000... :
                    viewsPost.text = "Views: \(post.views / 1_000_000)Kk"
                default:
                    break
                }
            }
        }
    }
    
    var authorPost: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.tintColor = .black
        label.numberOfLines = 2
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var descriptionPost: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .systemGray
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var imagePost: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.backgroundColor = .black
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    var likesPost: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = .black
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    var viewsPost: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = .black
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var baseInset: CGFloat { return 16 }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
        setupConstraints()
    }
}

extension PostTableViewCell {
    private func setupViews() {
        
        [authorPost, descriptionPost, imagePost, likesPost, viewsPost].forEach {contentView.addSubview ($0)}
    }
}

extension PostTableViewCell {
    private func setupConstraints() {
        [
            authorPost.topAnchor.constraint(equalTo: contentView.topAnchor, constant: baseInset),
            authorPost.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: baseInset),
            authorPost.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -baseInset),
            
            imagePost.topAnchor.constraint(equalTo: authorPost.bottomAnchor, constant: baseInset),
            imagePost.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imagePost.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imagePost.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            imagePost.heightAnchor.constraint(equalTo: imagePost.widthAnchor),
            
            descriptionPost.topAnchor.constraint(equalTo: imagePost.bottomAnchor, constant: baseInset),
            descriptionPost.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: baseInset),
            descriptionPost.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -baseInset),
            
            likesPost.topAnchor.constraint(equalTo: descriptionPost.bottomAnchor, constant: baseInset),
            likesPost.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: baseInset),
            likesPost.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -baseInset),
                    
            viewsPost.topAnchor.constraint(equalTo: descriptionPost.bottomAnchor, constant: baseInset),
            viewsPost.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -baseInset),
            viewsPost.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -baseInset),
        ]
        .forEach {$0.isActive = true}
    }
}

//
//  PostTableViewCell.swift
//  Navigation
//
//  Created by Natali Malich
//

import UIKit
import iOSIntPackage

class PostTableViewCell: UITableViewCell {
    
    private var imageProcessor = ImageProcessor()
    private var baseInset: CGFloat { return 16 }
    
    var post: Post? {
        didSet {
            if let post = post {
                id = post.id
                author.text = post.author
                body.text = post.body
                
//                guard let filter = post.filter else { return }
                let filter = post.filter
                
                if let image = post.image {
                    imageProcessor.processImage(sourceImage: image, filter: filter ?? .chrome) { image in
                        self.image.image = image
                    }
                }
//                if let image = UIImage(named: post.image) {
//                    imageProcessor.processImage(sourceImage: image, filter: filter) {
//                        image in imagePost.image = image
//                    }
//                }
                
                switch post.likes {
                case 0..<1000:
                    likes.text = " \(post.likes)"
                case 1_000..<1000_000:
                    likes.text = " \(post.likes / 1_000)K"
                case 1_000_000... :
                    likes.text = " \(post.likes / 1_000_000)Kk"
                default:
                    break
                }
                
                switch post.views {
                case 0..<1000:
                    views.text = " \(post.views)"
                case 1_000..<1000_000:
                    views.text = " \(post.views / 1_000)K"
                case 1_000_000... :
                    views.text = " \(post.views / 1_000_000)Kk"
                default:
                    break
                }
            }
        }
    }
    
    var id: UUID? = nil
    
    lazy var author: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.tintColor = .black
        label.numberOfLines = 2
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var body: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .systemGray
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var image: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.backgroundColor = .black
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    lazy var iconLikes: UIImageView = {
        let image = UIImageView()
//        image.image = UIImage(systemName: "heart")
//        image.tintColor = .systemGray
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    lazy var likes: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = .black
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var iconViews: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(systemName: "eye")
        image.tintColor = .systemGray
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    lazy var views: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = .black
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
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
        
        [author, body, image, iconLikes, likes, iconViews, views].forEach {contentView.addSubview ($0)}
    }
}

extension PostTableViewCell {
    private func setupConstraints() {
        [
            author.topAnchor.constraint(equalTo: contentView.topAnchor, constant: baseInset),
            author.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: baseInset),
            author.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -baseInset),
            
            image.topAnchor.constraint(equalTo: author.bottomAnchor, constant: baseInset),
            image.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            image.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            image.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            image.heightAnchor.constraint(equalTo: image.widthAnchor),
            
            body.topAnchor.constraint(equalTo: image.bottomAnchor, constant: baseInset),
            body.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: baseInset),
            body.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -baseInset),
            
            iconLikes.topAnchor.constraint(equalTo: body.bottomAnchor, constant: baseInset),
            iconLikes.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: baseInset),
            iconLikes.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -baseInset),
            
            likes.topAnchor.constraint(equalTo: body.bottomAnchor, constant: baseInset),
            likes.leadingAnchor.constraint(equalTo: iconLikes.trailingAnchor),
            likes.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -baseInset),
            
            views.topAnchor.constraint(equalTo: body.bottomAnchor, constant: baseInset),
            views.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -baseInset),
            views.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -baseInset),
            
            iconViews.topAnchor.constraint(equalTo: body.bottomAnchor, constant: baseInset),
            iconViews.trailingAnchor.constraint(equalTo: views.leadingAnchor),
            iconViews.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -baseInset)
        ]
        .forEach {$0.isActive = true}
    }
}

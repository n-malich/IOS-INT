//
//  PhotosCollectionViewCell.swift
//  Navigation
//
//  Created by Natali Malich
//

import UIKit

class PhotosCollectionViewCell: UICollectionViewCell {
    
    lazy var imagesPhotos: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(frame: CGRect) {
        super .init(frame: frame)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        nil
    }
}

extension PhotosCollectionViewCell {
    private func setupViews() {
        contentView.addSubview(imagesPhotos)
    }
}

extension PhotosCollectionViewCell {
    private func setupConstraints() {
        [
            imagesPhotos.topAnchor.constraint(equalTo: contentView.topAnchor),
            imagesPhotos.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imagesPhotos.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imagesPhotos.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ]
        .forEach {$0.isActive = true}
    }
}

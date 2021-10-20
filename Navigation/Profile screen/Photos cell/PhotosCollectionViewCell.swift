//
//  PhotosCollectionViewCell.swift
//  Navigation
//
//  Created by Natali Mizina on 09.08.2021.
//

import UIKit

class PhotosCollectionViewCell: UICollectionViewCell {
    
    var imagesPhotos: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    override func layoutSubviews() {
            super.layoutSubviews()

        setupViews()
        setupConstraints()
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

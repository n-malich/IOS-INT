//
//  PhotosTableViewCell.swift
//  Navigation
//
//  Created by Natali Mizina on 09.08.2021.
//

import UIKit

class PhotosTableViewCell: UITableViewCell {

    private var photos = PhotosVK().photosArray

    let titlePhotos: UILabel = {
        let label = UILabel()
        label.text = "Photos"
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let arrowRightPhotos: UIImageView = {
       let image = UIImageView(image: UIImage(systemName: "arrow.right"))
        image.tintColor = .black
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    let photosCollectionID = String(describing: PhotosCollectionViewCell.self)

    private var baseInset: CGFloat { return 12 }

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

extension PhotosTableViewCell {
    private func setupViews() {
        
        [titlePhotos, arrowRightPhotos, collectionView].forEach {contentView.addSubview($0)}
        
        collectionView.register(PhotosCollectionViewCell.self, forCellWithReuseIdentifier: photosCollectionID)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .white
    }
}

extension PhotosTableViewCell {
    private func setupConstraints() {
        [
            titlePhotos.topAnchor.constraint(equalTo: contentView.topAnchor, constant: baseInset),
            titlePhotos.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: baseInset),
            titlePhotos.trailingAnchor.constraint(equalTo: arrowRightPhotos.leadingAnchor, constant: -baseInset),

            arrowRightPhotos.centerYAnchor.constraint(equalTo: titlePhotos.centerYAnchor),
            arrowRightPhotos.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -baseInset),
            arrowRightPhotos.heightAnchor.constraint(equalToConstant: 25),
            arrowRightPhotos.widthAnchor.constraint(equalTo: arrowRightPhotos.heightAnchor),
            
            collectionView.topAnchor.constraint(equalTo: titlePhotos.bottomAnchor, constant: baseInset),
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: 100)
        ]
        .forEach {$0.isActive = true}
    }
}

extension PhotosTableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: PhotosCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: photosCollectionID, for: indexPath) as! PhotosCollectionViewCell
        cell.imagesPhotos.image = photos[indexPath.item]
        cell.imagesPhotos.layer.cornerRadius = 6
        return cell
    }
}

extension PhotosTableViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt IndexPath: IndexPath) -> CGSize {
        let width: CGFloat
        let height: CGFloat
        width = (collectionView.frame.width - baseInset * 2 - 8 * 3)/4
        height = collectionView.frame.height - baseInset * 2
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: baseInset, bottom: baseInset, right: baseInset)
    }
}

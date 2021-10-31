//
//  PhotosViewController.swift
//  Navigation
//
//  Created by Natali Malich
//

import UIKit
import iOSIntPackage

class PhotosViewController: UIViewController {
    
    private let imagePublisherFacade = ImagePublisherFacade()
    private var photosPublisher = [UIImage]()
    private let photos = PhotosVK.photosArray
    
    var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    let photosCollectionID = String(describing: PhotosCollectionViewCell.self)
    
    private var baseInset: CGFloat { return 8 }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.isNavigationBarHidden = false
        navigationItem.title = "Photo Gallery"
        navigationItem.backBarButtonItem?.style = .plain
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .white
        
        setupViews()
        setupConstraints()
        
        imagePublisherFacade.subscribe(self)
        imagePublisherFacade.addImagesWithTimer(time: 0.3, repeat: 30, userImages: photos as? [UIImage])
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.isNavigationBarHidden = true
        imagePublisherFacade.removeSubscription(for: self)
    }
}

extension PhotosViewController {
    private func setupViews() {
        
        view.backgroundColor = .white
        view.addSubview(collectionView)
        
        collectionView.register(PhotosCollectionViewCell.self, forCellWithReuseIdentifier: photosCollectionID)
    }
}

extension PhotosViewController {
    private func setupConstraints() {
        [
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ]
        .forEach {$0.isActive = true}
    }
}

extension PhotosViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photosPublisher.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: PhotosCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: photosCollectionID, for: indexPath) as! PhotosCollectionViewCell
        cell.imagesPhotos.image = photosPublisher[indexPath.item]
        return cell
    }
}

extension PhotosViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt IndexPath: IndexPath) -> CGSize {
        let width: CGFloat
        width = (collectionView.frame.width - baseInset * 4) / 3
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return baseInset
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return baseInset
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: baseInset, left: baseInset, bottom: baseInset, right: baseInset)
    }
}

extension PhotosViewController: ImageLibrarySubscriber {
    func receive(images: [UIImage]) {
        photosPublisher = images
        collectionView.reloadData()
    }
}

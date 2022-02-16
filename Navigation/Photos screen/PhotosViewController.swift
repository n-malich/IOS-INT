//
//  PhotosViewController.swift
//  Navigation
//
//  Created by Natali Malich
//

import UIKit

class PhotosViewController: UIViewController {
    
    private let photosCollectionID = String(describing: PhotosCollectionViewCell.self)
    private let photoProcessing = PhotoProcessing()
    private var timer = Timer()
    private var counter = 5
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()

    private var baseInset: CGFloat { return 8 }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = false
        navigationItem.backBarButtonItem?.style = .plain
       
        setupViews()
        setupConstraints()
        
        timerAction()
        updateFilterPhotos()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = true
        
        self.timer.invalidate()
    }
}

extension PhotosViewController {
    private func setupViews() {
        view.backgroundColor = .white
        view.addSubview(collectionView)
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
        return photoProcessing.processedPhotos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: PhotosCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: photosCollectionID, for: indexPath) as! PhotosCollectionViewCell
        cell.imagesPhotos.image = photoProcessing.processedPhotos[indexPath.item]
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

extension PhotosViewController {
    func timerAction() {
        self.timer = Timer.init(timeInterval: 1, repeats: true, block: { timer in
            self.timer.tolerance = 0.1
            self.counter -= 1
            self.navigationItem.title = "До обновления \(self.counter)"

            if self.counter == 0 {
                self.updateFilterPhotos()
                self.counter = 5
            }
        })
        RunLoop.current.add(self.timer, forMode: .common)
    }
}

extension PhotosViewController {
    func updateFilterPhotos() {
        self.photoProcessing.randomProcessing(completion: {
                self.collectionView.register(PhotosCollectionViewCell.self, forCellWithReuseIdentifier: self.photosCollectionID)
                self.collectionView.dataSource = self
                self.collectionView.delegate = self
                self.collectionView.backgroundColor = .white
                self.collectionView.reloadData()
        })
    }
}

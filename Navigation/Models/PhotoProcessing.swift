//
//  PhotoProcessing.swift
//  Navigation
//
//  Created by Natali Malich
//

import UIKit
import iOSIntPackage

class PhotoProcessing {
    
    static let shared = PhotoProcessing()
    private let imageProcessor = ImageProcessor()
    private var originalPhotos: [UIImage] = (CurrentUserService.shared.currentUser?.photos)!
    private let filters: [ColorFilter] = [.colorInvert, .transfer, .noir, .tonal, .process, .chrome, .fade,  .sepia(intensity: 0.8)]
    var processedPhotosFuncProcessing: [UIImage] = []
    var processedPhotosFuncRandomProcessing: [UIImage] = []

    //на фотографии накладывается один из фильтров
    func processing(completion: @escaping()->()) -> Void {
        let timer = CustomTimer()
        imageProcessor.processImagesOnThread(sourceImages: Array(originalPhotos.compactMap({$0}).prefix(8)), filter: .sepia(intensity: 0.8), qos: .userInteractive, completion: {images in
            DispatchQueue.main.async {
                for image in images {
                    guard let image = image else { return }
                    self.processedPhotosFuncProcessing.append(UIImage(cgImage: image))
                }
                completion()
                print("\(timer.stop()) seconds")
            }
        })
    }
    
    //на фотографии рандомно накладываются фильтры из массива filters
    func randomProcessing(completion: @escaping()->()) -> Void {
        if let randomFilter = filters.randomElement() {
            imageProcessor.processImagesOnThread(sourceImages: Array(originalPhotos.compactMap({$0}).prefix(18)), filter: randomFilter, qos: .userInteractive, completion: { images in
                DispatchQueue.main.async {
                    self.processedPhotosFuncRandomProcessing.removeAll()
                    for image in images {
                        guard let image = image else { return }
                        self.processedPhotosFuncRandomProcessing.append(UIImage(cgImage: image))
                    }
                    completion()
                }
            })
            print("Сейчас отобразится фильтр \(randomFilter)")
        }
    }
}

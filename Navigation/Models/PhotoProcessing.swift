//
//  PhotoProcessing.swift
//  Navigation
//
//  Created by Natali Malich
//

import UIKit
import iOSIntPackage

class PhotoProcessing {
    let imageProcessor = ImageProcessor()
    var originalPhotos = PhotosVK.photosArray
    var processedPhotos: [UIImage] = []
    var filters: [ColorFilter] = [.colorInvert, .transfer, .noir, .tonal, .process, .chrome, .fade,  .sepia(intensity: 0.8)]
    
    func processing(completion: @escaping()->()) -> Void {
        let timer = CustomTimer()
        imageProcessor.processImagesOnThread(sourceImages: Array(originalPhotos.compactMap({$0}).prefix(8)), filter: .sepia(intensity: 0.8), qos: .userInteractive, completion: {images in
            DispatchQueue.main.async {
                for image in images {
                    guard let image = image else { return }
                    self.processedPhotos.append(UIImage(cgImage: image))
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
                    self.processedPhotos.removeAll()
                    for image in images {
                        guard let image = image else { return }
                        self.processedPhotos.append(UIImage(cgImage: image))
                    }
                    completion()
                }
            })
            print("Сейчас отобразится фильтр \(randomFilter)")
        }
    }
}

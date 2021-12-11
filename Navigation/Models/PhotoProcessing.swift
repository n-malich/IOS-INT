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
  
    func processing(completion: @escaping()->()) -> Void {
        let timer = Timer()
        imageProcessor.processImagesOnThread(sourceImages: Array(originalPhotos.compactMap({$0}).prefix(8)), filter: .tonal, qos: .default, completion: {images in
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
}

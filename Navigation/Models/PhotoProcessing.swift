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
    var originalPhotos = PhotosVK.photosArray.prefix(8)
    var processedPhotos: [UIImage] = []
    
    /*
     filter: .chrome, qos: .background -> 12.546137928962708 seconds
     filter: .chrome, qos: .userInteractive -> 2.7297719717025757 seconds
     filter: .chrome, qos: .default -> 2.7210789918899536 seconds
     
     filter: .monochrome(color: .green, intensity: 0.8), qos: .background -> 12.729411959648132 seconds
     filter: .monochrome(color: .green, intensity: 0.8), qos: .userInteractive -> 2.7378679513931274 seconds
     filter: .monochrome(color: .green, intensity: 0.8), qos: .default -> 2.7029320001602173 seconds
     */
    
    func processing(completion: @escaping()->()) -> Void {
        let timer = Timer()
        imageProcessor.processImagesOnThread(sourceImages: originalPhotos.compactMap({ $0 }), filter: .tonal, qos: .default, completion: {images in
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

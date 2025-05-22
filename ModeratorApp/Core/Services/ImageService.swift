//
//  ImageService.swift
//  AppsHeroModPanel
//
//  Created by Ildar Khabibullin on 22.05.2025.
//

import Foundation
import UIKit
import PhotosUI
import SwiftUI

protocol ImageServiceProtocol {
    func selectImage(from controller: UIViewController, completion: @escaping (Data?) -> Void)
}

class ImageService: ImageServiceProtocol {
    func selectImage(from controller: UIViewController, completion: @escaping (Data?) -> Void) {
        var configuration = PHPickerConfiguration()
        configuration.filter = .images
        configuration.selectionLimit = 1
        
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = ImagePickerDelegate(completion: completion)
        controller.present(picker, animated: true)
    }
    
    private class ImagePickerDelegate: NSObject, PHPickerViewControllerDelegate {
        private let completion: (Data?) -> Void
        
        init(completion: @escaping (Data?) -> Void) {
            self.completion = completion
            super.init()
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            picker.dismiss(animated: true)
            
            guard let result = results.first else {
                completion(nil)
                return
            }
            
            result.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
                guard let self = self, let image = image as? UIImage else {
                    DispatchQueue.main.async {
                        self?.completion(nil)
                    }
                    return
                }
                
                let data = image.jpegData(compressionQuality: 0.7)
                DispatchQueue.main.async {
                    self.completion(data)
                }
            }
        }
    }
}

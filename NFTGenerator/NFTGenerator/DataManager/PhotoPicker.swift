//
//  PhotoPicker.swift
//  NFTGenerator
//
//  Created by Apps4World on 1/11/22.
//

import SwiftUI
import PhotosUI

/// Custom photo picker to allow multiple images
struct PhotoPicker: UIViewControllerRepresentable {
    
    let didSelect: (_ images: [UIImage]) -> Void
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<PhotoPicker>) -> PHPickerViewController {
        var config = PHPickerConfiguration(photoLibrary: PHPhotoLibrary.shared())
        config.selectionLimit = 0
        config.filter = .images
        config.preferredAssetRepresentationMode = .current
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: UIViewControllerRepresentableContext<PhotoPicker>) { }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    final class Coordinator: NSObject, PHPickerViewControllerDelegate {
        var parent: PhotoPicker
        
        init(_ parent: PhotoPicker) {
            self.parent = parent
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            var selectedImages = [UIImage]()
            
            for index in 0..<results.count {
                let result = results[index]
                result.itemProvider.loadObject(ofClass: UIImage.self, completionHandler: { (object, error) in
                    DispatchQueue.main.async {
                        if let errorMessage = error?.localizedDescription {
                            presentAlert(title: "Oops", message: errorMessage)
                        } else {
                            if let image = object as? UIImage {
                                selectedImages.append(image)
                            }
                        }
                        if index == results.count - 1 {
                            picker.dismiss(animated: true) {
                                self.parent.didSelect(selectedImages)
                            }
                        }
                    }
                })
            }
            
            if results.count == 0 {
                picker.dismiss(animated: true, completion: nil)
            }
        }
    }
}

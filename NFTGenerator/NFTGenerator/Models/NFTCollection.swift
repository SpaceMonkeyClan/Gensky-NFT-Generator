//
//  NFTCollection.swift
//  NFTGenerator
//
//  Created by Apps4World on 1/10/22.
//

import UIKit
import SwiftUI
import Foundation

/// A base model for the NFT
class NFTCollection: NSObject {
    /// The name for your actual NFT collection (Ex: Fox)
    var name: String = ""
    
    /// The layers in the specific order (Ex: Face layer, Eyes layer, Mouth, etc)
    var layers: [NFTLayer] = [NFTLayer]()
    
    /// The background colors for your NFT. With extra code, you can support images as background as well
    var backgrounds: [Color] = [Color]()
    
    /// Custom initializer
    init(name: String, layers: [NFTLayer], backgrounds: [Color]) {
        self.name = name
        self.layers = layers
        self.backgrounds = backgrounds
    }
    
    /// Calculate total number of NFTs possible to create based on the number of layers
    var totalCount: Int {
        layers.map { $0.thumbnails.count }.reduce(1, *)
    }
}

/// NFT layer representing a transparent set of images
class NFTLayer: NSObject {
    /// The name of your layer (Ex: eyes)
    var name: String = ""
    var collectionName: String = ""
    private var selectedImages: [UIImage] = [UIImage]()
    private var resizedImages: [UIImage] = [UIImage]()
    
    /// Custom initializer for local NFT collections
    init(name: String, collectionName: String) {
        self.name = name
        self.collectionName = collectionName
    }
    
    /// Custom initializer for builder flow
    init(name: String, collectionName: String, images: [UIImage]) {
        self.name = name
        self.selectedImages = images
    }
    
    /// An array of smaller images generated based on the layer name and number of options, OR use the selected images from gallery
    /// Ex: _ fox_eyes1, fox_eyes2, fox_eyesN - Always start your assets/layers with 1 then increment the number
    var thumbnails: [UIImage] {
        if resizedImages.count == 0 {
            if selectedImages.count > 0 {
                resizedImages = selectedImages.map { $0.resize(targetSize: AppConfig.thumbnailSize) }
            } else {
                for index in 0..<Int.max {
                    if let image = UIImage(named: "\(layerAssetName)\(index+1)")?.resize(targetSize: AppConfig.thumbnailSize) {
                        resizedImages.append(image)
                    } else { break }
                }
            }
        }
        return resizedImages
    }
    
    /// Get the actual NFT image instead of a thumbnail
    /// - Parameter index: image/thumbnail index
    /// - Returns: returns the full image
    func originalImage(atIndex index: Int) -> UIImage {
        if selectedImages.count > index {
            return selectedImages[index]
        }
        return UIImage(named: "\(layerAssetName)\(index+1)") ?? thumbnails[index]
    }
    
    /// Asset/Layer image name based on the layer name and the collection name
    private var layerAssetName: String {
        "\(collectionName.lowercased())_\(name.lowercased())"
    }
}

// MARK: - UImage extensions
extension UIImage {
    func resize(targetSize: CGSize) -> UIImage {
        UIGraphicsImageRenderer(size: targetSize).image { _ in
            draw(in: CGRect(origin: .zero, size: targetSize))
        }
    }
}

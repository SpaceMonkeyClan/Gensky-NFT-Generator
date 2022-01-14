//
//  DataManager.swift
//  NFTGenerator
//
//  Created by Apps4World on 1/10/22.
//

import SwiftUI
import Foundation

/// Full Screen flow
enum FullScreenMode: Int, Identifiable {
    case editor, photoPicker, subscriptions, settings, layers, tutorial
    var id: Int { hashValue }
}

/// Main data manager
class DataManager: NSObject, ObservableObject {
    /// Dynamic properties that the UI will react to
    @Published var showLoading: Bool = false
    @Published var fullScreenMode: FullScreenMode?
    @Published var selectedCollection: NFTCollection? {
        didSet { setupSelectedCollectionLayers() }
    }
    
    @Published var collectionName: String = ""
    @Published var layersName: String = ""
    @Published var layers: [NFTLayer] = [NFTLayer]()
    @Published var currentLayerIndex: Int = 0
    @Published var selectedImages: [UIImage] = [UIImage]()
    
    /// Dynamic properties that the UI will react to AND store values in UserDefaults
    @AppStorage("isPremiumUser") var isPremiumUser: Bool = false

    /// Private properties that the UI will not react to whenever these are changing
    internal var defaultCollections: [DefaultNFTCollection] = DefaultNFTCollection.allCases
    internal var defaultCollectionModels: [DefaultNFTCollection : NFTCollection] = [DefaultNFTCollection : NFTCollection]()
    internal var selectedCollectionLayers: [NFTLayer] = [NFTLayer]()
    internal var saveEntireNFTCollection: Bool = false
    
    /// AdMob Ads
    internal var adMob: Interstitial = Interstitial()
    
    /// Default initializer
    override init() {
        super.init()
        defaultCollections.forEach { defaultCollectionModels[$0] = $0.collectionModel }
    }
    
    /// Configure selected collection layers
    private func setupSelectedCollectionLayers() {
        guard let layers = selectedCollection?.layers else { return }
        selectedCollectionLayers = layers
        saveEntireNFTCollection = false
    }
}

// MARK: - NFT Builder features
extension DataManager {
    /// Build the NFT layers with given group of images
    /// - Parameter images: array of images for a specific NFT layer category (Ex: eyes, mouths, etc)
    func buildLayers(withImages images: [UIImage]) {
        if images.count > 0 {
            layersName = ""
            selectedImages = images
            fullScreenMode = .layers
        } else {
            presentAlert(title: "Oops!", message: "Looks like you didn't select any images")
        }
    }

    /// Save selected NFT layers
    func saveNFTLayers() {
        let existingLayers = layers.compactMap { $0.name.lowercased() }
        if existingLayers.contains(layersName.lowercased()) {
            presentAlert(title: "Oops!", message: "Looks like a group of layers with this name already exists")
        } else if layersName.trimmingCharacters(in: .whitespaces).isEmpty {
            presentAlert(title: "Oops!", message: "The layer name can not be empty")
        } else {
            layers.append(NFTLayer(name: layersName, collectionName: collectionName, images: selectedImages))
            if currentLayerIndex < AppConfig.builderMaxLayers - 1 {
                currentLayerIndex += 1
            }
            fullScreenMode = nil
        }
    }
    
    /// Reset all NFT layers for the NFT builder view
    func resetNFTBuilder() {
        presentAlert(title: "Reset NFT", message: "This will reset all NFT layers and you will start over", primaryAction: UIAlertAction(title: "Reset", style: .destructive, handler: { _ in
            self.layers.removeAll()
            self.collectionName = ""
            self.currentLayerIndex = 0
            self.layersName = ""
        }), secondaryAction: .cancel)
    }
    
    /// Build the custom NFT collection
    func buildCollection() {
        selectedCollection = NFTCollection(name: collectionName, layers: layers, backgrounds: AppConfig.nftBackgroundColors)
        fullScreenMode = .editor
    }
}

// MARK: - NFT Editor features
extension DataManager {
    /// Get thumbnails for a selected collection's layer
    /// - Parameter name: name for the layer category (Ex.: eyes)
    /// - Returns: returns an array of thumbnails
    func thumbnails(forLayerName name: String) -> [UIImage] {
        guard let layer = selectedCollectionLayers.filter({ $0.name == name }).first else { return [] }
        return layer.thumbnails
    }
    
    /// Save only current NFT item based on selected configurations
    /// - Parameter config: NFT item configurations
    func saveCurrentNFT(config: NFTItemViewConfig) {
        saveEntireNFTCollection = false
        let nftImage = NFTItemView(itemModel: selectedCollection!, exportMode: true, itemConfig: config).image(size: CGSize(width: AppConfig.exportSize, height: AppConfig.exportSize))
        UIImageWriteToSavedPhotosAlbum(nftImage, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    /// Save all possible NFTs from current selected collection
    func saveAllNFTCollectionItems() {
        showLoading = true
        saveEntireNFTCollection = true
        
        let allNFTLayerNames = selectedCollectionLayers.compactMap { $0.name }
        var savedLayerOptions = [String]()
        var randomizedCount = 0
        
        func saveRandomizedNFT() {
            let config = NFTItemViewConfig()
            var layerOptions = [String: Int]()
            config.backgroundIndex = Int.random(in: 0..<AppConfig.nftBackgroundColors.count)
            allNFTLayerNames.forEach {
                let thumbnailsCount = thumbnails(forLayerName: $0).count
                layerOptions[$0] = thumbnailsCount == 1 ? 0 : Int.random(in: 0..<thumbnailsCount)
            }
            config.layerOptionIndex = layerOptions
            let stringConfig = layerOptions.sorted(by: { $0.0 < $1.0 }).description
            if savedLayerOptions.contains(stringConfig) {
                randomizedCount += 1
                if savedLayerOptions.count == selectedCollection!.totalCount {
                    showLoading = false
                    presentAlert(title: "NFT Collection Save", message: "Your entire NFT Collection has been saved into the Photos app")
                } else {
                    saveRandomizedNFT()
                }
            } else {
                savedLayerOptions.append(stringConfig)
                let nftImage = NFTItemView(itemModel: selectedCollection!, exportMode: true, itemConfig: config).image(size: CGSize(width: AppConfig.exportSize, height: AppConfig.exportSize))
                UIImageWriteToSavedPhotosAlbum(nftImage, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
            }
        }
        
        NotificationCenter.default.addObserver(forName: Notification.Name("didSaveNFT"), object: nil, queue: nil) { _ in
            saveRandomizedNFT()
        }
        
        saveRandomizedNFT()
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if saveEntireNFTCollection {
            NotificationCenter.default.post(name: Notification.Name("didSaveNFT"), object: nil)
        } else {
            if let errorMessage = error?.localizedDescription {
                presentAlert(title: "Oops!", message: errorMessage)
            } else {
                presentAlert(title: "NFT Saved", message: "Your NFT has been saved into the Photos app")
            }
        }
    }
}

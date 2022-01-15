//
//  AppConfig.swift
//  NFTGenerator
//
//  Created by Apps4World on 1/10/22.
//

import SwiftUI
import Foundation

/// Generic configurations for the app
class AppConfig {
    
    /// This is the AdMob Interstitial ad id
    /// Test App ID: ca-app-pub-3940256099942544~1458002511
    static let adMobAdId: String = "ca-app-pub-4998868944035881/7251290161"
    static let adMobFrequency: Int = 2 /// every 2 nft collection previews
    
    // MARK: - Terms and Privacy
    static let privacyURL: URL = URL(string: "https://space-monkey.online/privacy-policy")!
    static let termsAndConditionsURL: URL = URL(string: "https://space-monkey.online/")!
    
    // MARK: - In App Purchases
    static let premiumVersion: String = "NFTGenerator.Premium"
    static let freeCollections: [DefaultNFTCollection] = [.greenMonster, .hero]
    
    /// Your email for support
    static let emailSupport = "rene.b.dena@gmail.com"
    static let yourAppURL: URL = URL(string: "https://apps.apple.com/us/app/gensky-nft-generator/id1605272757")!
    
    // MARK: - NFT Configurations
    /// Thumbnail size for each NFT layer. Must be as low as possible and always 1:1 aspect ratio
    static let thumbnailSize: CGSize = CGSize(width: 100, height: 100)
    static let nftBackgroundColors: [Color] = [Color(#colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)), Color(#colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)), Color(#colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)), Color(#colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)), Color(#colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1)), Color(#colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1)), Color(#colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)), Color(#colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1)), Color(#colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)), Color(#colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1)), Color(#colorLiteral(red: 0.9411764741, green: 0.4980392158, blue: 0.3529411852, alpha: 1)), Color(#colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1)), Color(#colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)), Color(#colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1)), Color(#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)), Color(#colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)), Color(#colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1)), Color(#colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)), Color(#colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)), Color(#colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)), Color(#colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 1)), Color(#colorLiteral(red: 0.1764705926, green: 0.01176470611, blue: 0.5607843399, alpha: 1)), Color(#colorLiteral(red: 0.1764705926, green: 0.01176470611, blue: 0.5607843399, alpha: 1)), Color(#colorLiteral(red: 0.09019608051, green: 0, blue: 0.3019607961, alpha: 1)), Color(#colorLiteral(red: 0.5725490451, green: 0, blue: 0.2313725501, alpha: 1)), Color(#colorLiteral(red: 0.4392156899, green: 0.01176470611, blue: 0.1921568662, alpha: 1)), Color(#colorLiteral(red: 0.3098039329, green: 0.01568627544, blue: 0.1294117719, alpha: 1)), Color(#colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)), Color(#colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)), Color(#colorLiteral(red: 0.521568656, green: 0.1098039225, blue: 0.05098039284, alpha: 1)), Color(#colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)), Color(#colorLiteral(red: 0.7254902124, green: 0.4784313738, blue: 0.09803921729, alpha: 1)), Color(#colorLiteral(red: 0.5058823824, green: 0.3372549117, blue: 0.06666667014, alpha: 1)), Color(#colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)), Color(#colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)), Color(#colorLiteral(red: 0.1960784346, green: 0.3411764801, blue: 0.1019607857, alpha: 1)), Color(#colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)), Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))]
    static let builderMaxLayers: Int = 5
    
    // MARK: - Image export size at 2x
    static let exportSize: CGFloat = 500 /// this will export the image at 1000x1000 resolution
}

// MARK: - Basic app NFT collection assets
/// This represents the default NFT collections that comes with the app
enum DefaultNFTCollection: String, CaseIterable, Identifiable {
    case corgi = "Corgi"
    case fox = "Fox"
    case eggMonster = "Egg Monster"
    case greenMonster = "Green Monster"
    case hero = "Hero"
    case skull = "Skull"
    
    /// Hashable identifier
    var id: Int { hashValue }
    
    /// NFT Collection model
    var collectionModel: NFTCollection {
        switch self {
        case .corgi:
            /// 1) Creating the NFT model with the name of your collection. In this case "Corgi"
            /// 2) Creating the layers, starting from the back layer. In this case "body"
            /// 3) Creating any other layers that will be on top of the first layer
            return NFTCollection(name: self.rawValue, layers: [
                NFTLayer(name: "body", collectionName: self.rawValue),
                NFTLayer(name: "face", collectionName: self.rawValue),
                NFTLayer(name: "eye", collectionName: self.rawValue),
                NFTLayer(name: "mouth", collectionName: self.rawValue)
            ], backgrounds: AppConfig.nftBackgroundColors)
        
        case .eggMonster:
            return NFTCollection(name: self.rawValue, layers: [
                NFTLayer(name: "horns", collectionName: self.rawValue),
                NFTLayer(name: "face", collectionName: self.rawValue),
                NFTLayer(name: "eye", collectionName: self.rawValue),
                NFTLayer(name: "mouth", collectionName: self.rawValue)
            ], backgrounds: AppConfig.nftBackgroundColors)
        
        case .fox:
            return NFTCollection(name: self.rawValue, layers: [
                NFTLayer(name: "face", collectionName: self.rawValue),
                NFTLayer(name: "eyes", collectionName: self.rawValue),
                NFTLayer(name: "mouth", collectionName: self.rawValue)
            ], backgrounds: AppConfig.nftBackgroundColors)
        
        case .greenMonster:
            return NFTCollection(name: self.rawValue, layers: [
                NFTLayer(name: "face", collectionName: self.rawValue),
                NFTLayer(name: "eye", collectionName: self.rawValue),
                NFTLayer(name: "mouth", collectionName: self.rawValue)
            ], backgrounds: AppConfig.nftBackgroundColors)
            
        case .hero:
            return NFTCollection(name: self.rawValue, layers: [
                NFTLayer(name: "face", collectionName: self.rawValue),
                NFTLayer(name: "body", collectionName: self.rawValue),
                NFTLayer(name: "mask", collectionName: self.rawValue)
            ], backgrounds: AppConfig.nftBackgroundColors)
        
        case .skull:
            return NFTCollection(name: self.rawValue, layers: [
                NFTLayer(name: "face", collectionName: self.rawValue),
                NFTLayer(name: "headwear", collectionName: self.rawValue),
                NFTLayer(name: "beard", collectionName: self.rawValue)
            ], backgrounds: AppConfig.nftBackgroundColors)
        }
    }
    
    /// Default configuration
    var configuration: NFTItemViewConfig {
        switch self {
        case .corgi:
            return NFTItemViewConfig(backgroundIndex: 0, layerOptionIndex: [:])
        case .fox:
            return NFTItemViewConfig(backgroundIndex: 1, layerOptionIndex: [:])
        case .eggMonster:
            return NFTItemViewConfig(backgroundIndex: 9, layerOptionIndex: [:])
        case .greenMonster:
            return NFTItemViewConfig(backgroundIndex: 7, layerOptionIndex: [:])
        case .hero:
            return NFTItemViewConfig(backgroundIndex: 16, layerOptionIndex: [:])
        case .skull:
            return NFTItemViewConfig(backgroundIndex: 18, layerOptionIndex: [:])
        }
    }
}

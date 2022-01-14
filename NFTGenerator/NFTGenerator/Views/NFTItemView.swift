//
//  NFTItemView.swift
//  NFTGenerator
//
//  Created by Apps4World on 1/10/22.
//

import SwiftUI

/// NFT Item view configuration
class NFTItemViewConfig: ObservableObject {
    @Published var backgroundIndex: Int = 0
    @Published var layerOptionIndex: [String: Int] = [:]
    
    /// Custom initializer to set the configs
    convenience init(backgroundIndex: Int, layerOptionIndex: [String: Int]) {
        self.init()
        self.backgroundIndex = backgroundIndex
        self.layerOptionIndex = layerOptionIndex
    }
}

/// Builds the NFT item based on the NFT Collection assets
struct NFTItemView: View {
    
    @State var itemModel: NFTCollection
    @State var exportMode: Bool = false
    @ObservedObject var itemConfig: NFTItemViewConfig
    
    // MARK: - Main rendering function
    var body: some View {
        ZStack {
            itemModel.backgrounds[itemConfig.backgroundIndex]
                .ignoresSafeArea().layoutPriority(0)
            ForEach(0..<itemModel.layers.count, id: \.self) { index in
                NFTLayerImage(atIndex: index).layoutPriority(1)
            }
        }
    }
    
    /// Create NFT layer image
    private func NFTLayerImage(atIndex index: Int) -> some View {
        let layer = itemModel.layers[index]
        let layerOptionIndex = itemConfig.layerOptionIndex[layer.name] ?? 0
        let layerImage = exportMode ? layer.originalImage(atIndex: layerOptionIndex) : layer.thumbnails[layerOptionIndex]
        return Image(uiImage: layerImage).resizable().aspectRatio(contentMode: .fit)
    }
}

// MARK: - Preview UI
struct NFTItemView_Previews: PreviewProvider {
    static var previews: some View {
        NFTItemView(itemModel: DefaultNFTCollection.fox.collectionModel, itemConfig: NFTItemViewConfig())
            .previewLayout(.sizeThatFits)
    }
}

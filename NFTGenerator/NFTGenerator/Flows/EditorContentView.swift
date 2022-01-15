//
//  EditorContentView.swift
//  NFTGenerator
//
//  Created by Apps4World on 1/10/22.
//

import SwiftUI

/// NFT Editor main flow
struct EditorContentView: View {
    
    @EnvironmentObject var manager: DataManager
    @StateObject private var config: NFTItemViewConfig = NFTItemViewConfig()
    @State private var selectedLayer: String = ""
    @State private var horizontalPadding: CGFloat = 100
    
    // MARK: - Main rendering function
    var body: some View {
        ZStack {
            Color("Primary").ignoresSafeArea()
            VStack {
                /// Header title + Settings icon
                HeaderView
                
                /// NFT Preview
                ZStack {
                    NFTItemPreview.blur(radius: 30).opacity(0.7)
                    NFTItemPreview
                }.onTapGesture {
                    withAnimation {
                        horizontalPadding = horizontalPadding != 50 ? 50 : 100
                    }
                }
                
                /// NFT Layers configuration
                NFTLayersBottomView
            }
            
            /// Show loading view while saving NFTs
            LoadingView(isLoading: $manager.showLoading)
        }
        
        /// Automatically select the first layer group
        .onAppear {
            if selectedLayer.isEmpty {
                let layers = manager.selectedCollectionLayers
                selectedLayer = layers[0].name
                layers.forEach { config.layerOptionIndex[$0.name] = 0 }
                manager.adMob.showInterstitialAds()
            }
        }
    }
    
    /// Header view
    private var HeaderView: some View {
        ZStack {
            HStack {
                Spacer()
                Button {
                    manager.fullScreenMode = nil
                } label: {
                    Image(systemName: "xmark").font(.system(size: 20, weight: .bold))
                }
            }.padding(.horizontal)
            
            Text(manager.selectedCollection!.name)
                .font(.system(size: 22, weight: .semibold))
            
        }.foregroundColor(Color("Light"))
    }
    
    /// NFT item preview
    private var NFTItemPreview: some View {
        NFTItemView(itemModel: manager.selectedCollection!, itemConfig: config)
            .cornerRadius(30)
            .padding(.horizontal, horizontalPadding).padding(.top, 20)
    }
    
    /// NFT Layers configuration
    private var NFTLayersBottomView: some View {
        ZStack {
            RoundedCorner(radius: 20, corners: [.topLeft, .topRight])
                .foregroundColor(Color("Secondary")).edgesIgnoringSafeArea(.bottom)
                .shadow(color: Color.black.opacity(0.1), radius: 20)
            VStack(spacing: 0) {
                BackgroundsSection
                Color("Primary").frame(height: 1)
                    .padding([.top, .horizontal]).opacity(0.3)
                ScrollView(.vertical, showsIndicators: false) {
                    Spacer(minLength: 15)
                    LayersSection
                    Spacer(minLength: 80)
                }
            }
            NFTSaveActions
        }.padding(.top, 30)
    }
    
    /// NFT Generator & Save actions
    private var NFTSaveActions: some View {
        VStack {
            Spacer()
            HStack(spacing: 20) {
                
                /// Save current NFT
                Button {
                    manager.saveCurrentNFT(config: config)
                } label: {
                    ZStack {
                        Color("Secondary").cornerRadius(30)
                        Image(systemName: "square.and.arrow.down.fill")
                            .font(.system(size: 22, weight: .medium))
                            .foregroundColor(Color("Text"))
                    }
                }.frame(width: 50, height: 50)
                
                /// Generate a random NFT
                Button {
                    config.backgroundIndex = Int.random(in: 0..<AppConfig.nftBackgroundColors.count)
                    manager.selectedCollectionLayers.forEach { layer in
                        config.layerOptionIndex[layer.name] = Int.random(in: 0..<manager.thumbnails(forLayerName: layer.name).count)
                    }
                } label: {
                    ZStack {
                        Color("Secondary").cornerRadius(30)
                        Image(systemName: "dice.fill")
                            .font(.system(size: 22, weight: .medium))
                            .foregroundColor(Color("Text"))
                    }
                }.frame(width: 50, height: 50)
                
                /// Generate all nfts
                Button {
                    if manager.isPremiumUser {
                        manager.saveAllNFTCollectionItems()
                    } else {
                        manager.saveAllNFTCollectionItems()
                        //manager.fullScreenMode = .subscriptions
                    }
                } label: {
                    ZStack {
                        Color("Action").cornerRadius(30)
                        Text("Generate \(manager.selectedCollection!.totalCount) NFTs")
                            .fixedSize(horizontal: true, vertical: false)
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(.white)
                    }
                }.frame(height: 50)
                
            }.padding(.horizontal).padding(.top).background(
                RoundedCorner(radius: 20, corners: [.topLeft, .topRight])
                    .foregroundColor(Color("Primary")).edgesIgnoringSafeArea(.bottom)
                    .shadow(color: Color.black.opacity(0.1), radius: 20)
            )
        }
    }
    
    /// NFT Backgrounds section
    private var BackgroundsSection: some View {
        VStack(spacing: 10) {
            HStack {
                Text("Background").font(.system(size: 18, weight: .regular))
                Spacer()
            }.padding(.horizontal).padding(.top)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 15) {
                    Spacer(minLength: 2)
                    
                    /// Random color picker button
                    Button {
                        config.backgroundIndex = Int.random(in: 0..<AppConfig.nftBackgroundColors.count)
                    } label: {
                        ZStack {
                            Color("Primary").cornerRadius(10)
                            Image(systemName: "dice.fill").font(.system(size: 20))
                        }.foregroundColor(.white)
                    }.frame(width: 45, height: 45, alignment: .center)
                    
                    /// Colors scroll view
                    ForEach(0..<AppConfig.nftBackgroundColors.count, id: \.self) { index in
                        Button {
                            config.backgroundIndex = index
                        } label: {
                            AppConfig.nftBackgroundColors[index].cornerRadius(10)
                        }
                        .frame(width: 45, height: 45, alignment: .center)
                        .opacity(config.backgroundIndex == index ? 1 : 0.3)
                    }
                    Spacer(minLength: 2)
                }
            }
        }.foregroundColor(Color("Text"))
    }
    
    /// NFT Layers section
    private var LayersSection: some View {
        VStack(spacing: 10) {
            HStack {
                Text("NFT Layers").font(.system(size: 18, weight: .regular))
                Spacer()
            }.padding(.horizontal)
            
            /// Layers scroll view
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 15) {
                    Spacer(minLength: 2)
                    ForEach(0..<manager.selectedCollectionLayers.count, id: \.self) { index in
                        layerCategory(atIndex: index)
                    }
                    Spacer(minLength: 2)
                }
            }
            
            /// Layer options grid view
            LazyVGrid(columns: Array(repeating: GridItem(spacing: 10), count: 3)) {
                ForEach(0..<manager.thumbnails(forLayerName: selectedLayer).count, id: \.self) { index in
                    layerThumbnail(atIndex: index)
                }
            }.padding(.horizontal)
            
        }.foregroundColor(Color("Text"))
    }
    
    private func layerCategory(atIndex index: Int) -> some View {
        let layerName = manager.selectedCollectionLayers[index].name
        return Button {
            selectedLayer = layerName
        } label: {
            VStack(spacing: 5) {
                Text(layerName.capitalized)
                    .font(.system(size: 20, weight: .medium))
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5).background(
                        Color("Text").cornerRadius(10)
                            .opacity(selectedLayer == layerName ? 1 : 0)
                    ).foregroundColor(selectedLayer != layerName ? Color("Text") : Color("Secondary"))
            }
        }
    }
    
    private func layerThumbnail(atIndex index: Int) -> some View {
        let layers = manager.selectedCollectionLayers
        func layerName(_ layerIndex: Int) -> String {
            layers[layerIndex].name
        }
        return ZStack {
            Color("Primary").cornerRadius(15).opacity(0.03)
            RoundedRectangle(cornerRadius: 15)
                .stroke(style: StrokeStyle(lineWidth: 5, dash: [5]))
                .foregroundColor(Color("Text"))
                .opacity(config.layerOptionIndex[selectedLayer] == index ? 1 : 0)
            ForEach(0..<layers.count, id: \.self) { layerIndex in
                Image(uiImage: manager.thumbnails(forLayerName: layerName(layerIndex))[layerName(layerIndex) == selectedLayer ? index : 0])
                    .resizable().aspectRatio(contentMode: .fit)
                    .opacity(layerName(layerIndex) == selectedLayer ? 1 : 0.2)
            }
        }.cornerRadius(15).onTapGesture {
            config.layerOptionIndex[selectedLayer] = index
        }
    }
}

// MARK: - Preview UI
struct EditorContentView_Previews: PreviewProvider {
    static var previews: some View {
        let manager = DataManager()
        manager.selectedCollection = DefaultNFTCollection.corgi.collectionModel
        return EditorContentView()
            .environmentObject(manager)
            .preferredColorScheme(.light)
    }
}

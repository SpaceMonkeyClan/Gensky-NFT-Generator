//
//  NFTBuilderView.swift
//  NFTGenerator
//
//  Created by Apps4World on 1/10/22.
//

import SwiftUI

/// The NFT custom builder at the top of the dashboard
struct NFTBuilderView: View {
    
    @EnvironmentObject var manager: DataManager
    @State private var didShowKeyboard: Bool = false
    
    // MARK: - Main rendering function
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack {
                NFTCollectionNameSection
                AddLayersSection
                GenerateCollectionSection
            }
        }
        .padding(.bottom)
        .onAppear {
            NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: nil) { _ in
                DispatchQueue.main.async { withAnimation { didShowKeyboard = true } }
            }
            NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: nil) { _ in
                DispatchQueue.main.async { withAnimation { didShowKeyboard = false } }
            }
        }
    }
    
    /// NFT Collection name section
    private var NFTCollectionNameSection: some View {
        TextField("Your NFT Collection name", text: $manager.collectionName)
            .font(.system(size: 18)).foregroundColor(Color("Text"))
            .padding(.horizontal, 15).padding(.vertical, 12)
            .background(Color("Secondary").cornerRadius(12))
            .overlay(
                HStack {
                    Spacer()
                    Button {
                        hideKeyboard()
                    } label: {
                        ZStack {
                            Color("Action").cornerRadius(10)
                            Text("Done").bold().foregroundColor(.white)
                        }
                    }
                    .frame(width: 70, height: 40).padding(5)
                    .opacity(didShowKeyboard ? 1 : 0)
                }
            ).padding(.horizontal)
    }
    
    /// Add layers section
    private var AddLayersSection: some View {
        VStack(alignment: .leading, spacing: 5) {
            Spacer()
            HStack {
                Text("Add Your NFT Layers")
                Spacer()
                Button {
                    manager.resetNFTBuilder()
                } label: {
                    Text("Reset").bold()
                }
            }.font(.system(size: 15)).padding(.horizontal)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    Spacer(minLength: 0)
                    ForEach(0..<AppConfig.builderMaxLayers, id: \.self) { index in
                        AddLayerButton(atIndex: index)
                    }
                    Spacer(minLength: 0)
                }
            }
        }.foregroundColor(Color("Light")).padding(.vertical, 8)
    }
    
    private func AddLayerButton(atIndex index: Int) -> some View {
        Button {
            manager.currentLayerIndex = index
            manager.fullScreenMode = .photoPicker
        } label: {
            ZStack {
                Color.clear
                if manager.layers.count > index,
                   let layerImage = manager.layers[index].thumbnails.first {
                    Image(systemName: "square.fill")
                        .font(.system(size: 70, weight: .thin))
                    Image(uiImage: layerImage).resizable().aspectRatio(contentMode: .fit)
                        .frame(width: 50, height: 50, alignment: .center)
                } else {
                    Image(systemName: "square.dashed")
                        .font(.system(size: 70, weight: .thin))
                    Image(systemName: "plus")
                        .font(.system(size: 25, weight: .semibold))
                }
            }
        }
        .disabled(manager.currentLayerIndex != index)
        .opacity(manager.currentLayerIndex != index ? 0.2 : 1)
    }
    
    /// Generate collection section
    private var GenerateCollectionSection: some View {
        Button {
            manager.buildCollection()
        } label: {
            ZStack {
                Color("Action").cornerRadius(30)
                Text("Generate").font(.system(size: 18, weight: .medium))
                    .foregroundColor(.white)
            }
        }
        .frame(height: 50)
        .padding(.horizontal)
        .disabled(!isCollectionValid)
        .opacity(isCollectionValid ? 1 : 0.7)
    }
    
    /// Validate the collection
    /// 1) We must have at least 2 NFT layers
    /// 2) We must have a collection name typed
    private var isCollectionValid: Bool {
        manager.layers.count > 1 && !manager.collectionName.trimmingCharacters(in: .whitespaces).isEmpty
    }
}

// MARK: - Preview UI
struct NFTBuilderView_Previews: PreviewProvider {
    static var previews: some View {
        let manager = DataManager()
        manager.layers = [NFTLayer(name: "body", collectionName: "hero")]
        return NFTBuilderView().environmentObject(manager)
    }
}

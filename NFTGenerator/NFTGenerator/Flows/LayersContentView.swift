//
//  LayersContentView.swift
//  NFTGenerator
//
//  Created by Apps4World on 1/11/22.
//

import SwiftUI

/// Shows a list of layers selected by the user
struct LayersContentView: View {
    
    @EnvironmentObject var manager: DataManager
    @State private var didShowKeyboard: Bool = false
    
    // MARK: - Main rendering function
    var body: some View {
        ZStack {
            Color("Primary").ignoresSafeArea()
            VStack {
                HeaderView
                NFTLayersNameSection
                ScrollView(.vertical, showsIndicators: false) {
                    VStack {
                        LazyVGrid(columns: Array(repeating: GridItem(spacing: 10), count: 3)) {
                            ForEach(0..<manager.selectedImages.count, id: \.self) { index in
                                Image(uiImage: manager.selectedImages[index].resize(targetSize: AppConfig.thumbnailSize))
                                    .resizable().aspectRatio(contentMode: .fit)
                                    .background(Color.white).cornerRadius(15)
                            }
                        }
                    }.padding(.horizontal)
                }
            }
        }
        .onAppear {
            NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: nil) { _ in
                DispatchQueue.main.async { withAnimation { didShowKeyboard = true } }
            }
            NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: nil) { _ in
                DispatchQueue.main.async { withAnimation { didShowKeyboard = false } }
            }
        }
    }
    
    /// Header view
    private var HeaderView: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading) {
                HStack {
                    Text("NFT Layers").font(.system(size: 30, weight: .bold))
                    Spacer()
                    Button {
                        manager.saveNFTLayers()
                    } label: {
                        Text("Done").font(.system(size: 20, weight: .semibold))
                    }
                }
                Text("What's the name for these layers?").font(.system(size: 18))
            }.foregroundColor(Color("Light"))
            Spacer()
        }.padding(.horizontal)
    }
    
    /// NFT layers name section
    private var NFTLayersNameSection: some View {
        TextField("Your NFT Layers name", text: $manager.layersName)
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
            ).padding(.horizontal).padding(.bottom)
    }
}

// MARK: - Preview UI
struct LayersContentView_Previews: PreviewProvider {
    static var previews: some View {
        LayersContentView().environmentObject(DataManager())
    }
}

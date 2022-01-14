//
//  NFTCollectionsView.swift
//  NFTGenerator
//
//  Created by Apps4World on 1/10/22.
//

import SwiftUI

/// A grid of default NFT collections for the dashboard screen
struct NFTCollectionsView: View {
    
    @EnvironmentObject var manager: DataManager
    
    // MARK: - Main rendering function
    var body: some View {
        ZStack {
            RoundedCorner(radius: 20, corners: [.topLeft, .topRight])
                .foregroundColor(Color("Secondary")).edgesIgnoringSafeArea(.bottom)
                .shadow(color: Color.black.opacity(0.1), radius: 20)
            ScrollView(.vertical, showsIndicators: false) {
                VStack {
                    HeaderView
                    LazyVGrid(columns: Array(repeating: GridItem(spacing: 10), count: 2)) {
                        ForEach(0..<manager.defaultCollections.count, id: \.self) { index in
                            NFTCollectionView(withItem: manager.defaultCollections[index])
                        }
                    }
                }.padding(.horizontal, 20).padding(.top, 20)
                
                /// Attribution footer view
                HStack(spacing: 0) {
                    Text("Designed by ")
                    Button("Freepik") {
                        UIApplication.shared.open(URL(string: "https://www.freepik.com/")!, options: [:], completionHandler: nil)
                    }
                }
                .font(.system(size: 12, weight: .thin))
                .opacity(0.4).foregroundColor(Color("Text"))
                .padding(.top, 10)
            }
        }
    }
    
    /// Header view
    private var HeaderView: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("NFT Collections").font(.title3).bold()
                Text("Choose a collection to generate NFTs").font(.subheadline)
            }.foregroundColor(Color("Text"))
            Spacer()
        }
    }
    
    /// Create a default NFT Collection item view
    private func NFTCollectionView(withItem item: DefaultNFTCollection) -> some View {
        let allItemsCount = DefaultNFTCollection.allCases.count
        let isTopLeftItem = item == DefaultNFTCollection.allCases[0]
        let isTopRightItem = item == DefaultNFTCollection.allCases[1]
        let isBottomLeftItem = item == DefaultNFTCollection.allCases[allItemsCount-2]
        let isBottomRightItem = item == DefaultNFTCollection.allCases[allItemsCount-1]
        
        var corner: UIRectCorner = .allCorners
        if isTopRightItem { corner = .topRight }
        else if isTopLeftItem { corner = .topLeft }
        else if isBottomLeftItem { corner = .bottomLeft }
        else if isBottomRightItem { corner = .bottomRight }
        
        let model = manager.defaultCollectionModels[item]!
        
        return ZStack {
            NFTItemView(itemModel: model, itemConfig: item.configuration)
            NFTCollectionBadgeView(forItem: item)
        }.mask(RoundedCorner(radius: corner == .allCorners ? 0 : 20, corners: corner))
    }
    
    /// NFT Collection badge
    private func NFTCollectionBadgeView(forItem item: DefaultNFTCollection) -> some View {
        let isPremiumItem = !manager.isPremiumUser && !AppConfig.freeCollections.contains(item)
        let model = manager.defaultCollectionModels[item]!
        return ZStack {
            Color.black.opacity(isPremiumItem ? 0.5 : 0)
            VStack {
                Spacer()
                HStack {
                    Text("\(model.totalCount) NFTs")
                        .font(.system(size: 14, weight: .medium))
                        .padding(.horizontal, 10).padding(.vertical, 5)
                        .foregroundColor(.black)
                        .background(
                            Color.white.cornerRadius(40)
                                .shadow(color: Color.black.opacity(0.2), radius: 10)
                        )
                    Spacer()
                    if isPremiumItem {
                        Image(systemName: "lock.circle.fill")
                            .font(.system(size: 22)).foregroundColor(.white)
                            .background(
                                Circle().foregroundColor(.black).padding(2)
                                    .shadow(color: Color.black.opacity(0.2), radius: 10)
                            )
                    }
                }
            }.padding(10)
        }.contentShape(Rectangle())
        
        /// Handle NFT Collection tap gesture
        .onTapGesture {
            if isPremiumItem { manager.fullScreenMode = .subscriptions } else {
                manager.selectedCollection = model
                manager.fullScreenMode = .editor
            }
        }
    }
}

// MARK: - Preview UI
struct NFTCollectionsView_Previews: PreviewProvider {
    static var previews: some View {
        NFTCollectionsView().environmentObject(DataManager())
    }
}

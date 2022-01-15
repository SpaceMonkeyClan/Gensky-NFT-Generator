//
//  DashboardContentView.swift
//  NFTGenerator
//
//  Created by Apps4World on 1/10/22.
//

import SwiftUI

/// Main dashboard for the app
struct DashboardContentView: View {
    
    @EnvironmentObject var manager: DataManager
    private let collectionsHeight: CGFloat = UIScreen.main.bounds.height/2
    private let headerHeight: CGFloat = 70
    
    // MARK: - Main rendering function
    var body: some View {
        ZStack {
            Color("Primary").ignoresSafeArea()
            
            /// NFT Builder top view
            NFTBuilderView()
                .padding(.top, headerHeight)
                .environmentObject(manager)
            
            /// NFT Collections bottom view
            VStack {
                Spacer()
                NFTCollectionsView()
                    .frame(height: collectionsHeight)
                    .environmentObject(manager)
            }.ignoresSafeArea(.keyboard)
            
            /// Header title + Settings icon
            HeaderView
        }
        
        /// Full screen flow presentation
        .fullScreenCover(item: $manager.fullScreenMode) { type in
            switch type {
            case .settings:
                SettingsContentView().environmentObject(manager)
            case .subscriptions:
                PremiumContentView(title: "Premium Version", subtitle: "Upgrade Today", features: ["Remove ads", "Unlock NFT Collections", "Unlock auto-generator"], productIds: [AppConfig.premiumVersion]) { _, status, _ in
                    DispatchQueue.main.async {
                        if status == .success || status == .restored {
                            manager.isPremiumUser = true
                        }
                        manager.fullScreenMode = nil
                    }
                }
            case .editor:
                EditorContentView().environmentObject(manager)
            case .photoPicker:
                PhotoPicker { images in
                    manager.buildLayers(withImages: images)
                }
            case .layers:
                LayersContentView().environmentObject(manager)
            case .tutorial:
                TutorialContentView().environmentObject(manager)
            }
        }
    }
    
    /// Header view
    private var HeaderView: some View {
        VStack {
            VStack(alignment: .leading) {
                HStack {
                    Text("Gensky Generator").font(.system(size: 30, weight: .bold))
                    Spacer()
                    Button {
                        manager.fullScreenMode = .settings
                    } label: {
                        Image(systemName: "gearshape.fill")
                            .font(.system(size: 20))
                    }
                }
                Text("Generate NFTs from layers").font(.system(size: 18))
            }.foregroundColor(Color("Light")).padding(.horizontal)
            Spacer()
        }
    }
}

// MARK: - Preview UI
struct DashboardContentView_Previews: PreviewProvider {
    static var previews: some View {
        let manager = DataManager()
        manager.layers = [NFTLayer(name: "body", collectionName: "hero")]
        return DashboardContentView().environmentObject(manager)
    }
}

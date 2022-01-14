//
//  TutorialContentView.swift
//  NFTGenerator
//
//  Created by Apps4World on 1/11/22.
//

import SwiftUI

/// Tutorial item
struct TutorialItem {
    let title: String
    let subtitle: String
    let image: String?
}

/// Tutorial view for the app
struct TutorialContentView: View {
    
    @EnvironmentObject var manager: DataManager
    
    // MARK: - Main rendering function
    var body: some View {
        ZStack {
            Color("Primary").ignoresSafeArea()
            VStack {
                /// Header title + Settings icon
                HeaderView
                
                /// Tutorial items
                ScrollView(.vertical, showsIndicators: false) {
                    ForEach(0..<tutorialItems.count, id: \.self) { index in
                        VStack {
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(tutorialItems[index].title).font(.title3).bold()
                                    Text(tutorialItems[index].subtitle).opacity(0.7)
                                }.foregroundColor(Color("Light"))
                                Spacer()
                            }
                            if let imageName = tutorialItems[index].image,
                                let image = UIImage(named: imageName) {
                                Image(uiImage: image).resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .cornerRadius(10).overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(Color.white, lineWidth: 2)
                                            .opacity(0.5)
                                    )
                            }
                            Color.white.frame(height: 1).padding(.vertical)
                        }
                    }.padding(.horizontal)
                }
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
            Text("Tutorial").font(.system(size: 22, weight: .semibold))
        }.foregroundColor(Color("Light"))
    }
}

// MARK: - Preview UI
struct TutorialContentView_Previews: PreviewProvider {
    static var previews: some View {
        TutorialContentView().environmentObject(DataManager())
    }
}

// MARK: - Tutorial items
let tutorialItems = [
    TutorialItem(title: "NFT Collection", subtitle: "On the dashboard screen, if you create your own NFT Collection, start by typing the collection name", image: "tutorial-nft-name"),
    TutorialItem(title: "NFT Layers", subtitle: "When adding an NFT layer, you must add them in the order that they belong, from the back item, to the front item. For example, a body layer will come first, then any clothing/accessories after that", image: nil),
    TutorialItem(title: "Layers Group", subtitle: "Each NFT Layer group, must include at least 1 option (ex.: 1 pair of eyes) and at least 2 groups (ex.: face and eyes).", image: "tutorial-nft-group"),
    TutorialItem(title: "Layer Size", subtitle: "All NFT Layers must have exactly the same size, it's recommended to use 1000x1000 pixels, and always use a square aspect ratio", image: nil)
]

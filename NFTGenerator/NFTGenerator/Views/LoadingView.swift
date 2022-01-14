//
//  LoadingView.swift
//  NFTGenerator
//
//  Created by Apps4World on 1/11/22.
//

import SwiftUI

/// Show a loading indicator view
struct LoadingView: View {
    
    @Binding var isLoading: Bool
    
    // MARK: - Main rendering function
    var body: some View {
        ZStack {
            if isLoading {
                Color.black.edgesIgnoringSafeArea(.all).opacity(0.4)
                ProgressView("please wait...")
                    .scaleEffect(1.1, anchor: .center)
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    .foregroundColor(.white).padding()
                    .background(RoundedRectangle(cornerRadius: 10).opacity(0.7))
            }
        }.colorScheme(.light)
    }
}

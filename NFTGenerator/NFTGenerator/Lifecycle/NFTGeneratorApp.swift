//
//  NFTGeneratorApp.swift
//  NFTGenerator
//
//  Created by Apps4World on 1/10/22.
//

import SwiftUI
import PurchaseKit
import GoogleMobileAds

@main
struct NFTGeneratorApp: App {
    
    @StateObject private var manager: DataManager = DataManager()
    

    
    init() {
        PKManager.loadProducts(identifiers: [AppConfig.premiumVersion])
        GADMobileAds.sharedInstance().start(completionHandler: nil)
    }
    
    // MARK: - Main rendering function
    var body: some Scene {
        WindowGroup {
            DashboardContentView().environmentObject(manager)
        }
    }
}

/// Create a shape with specific rounded corners
struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

extension View {
    func hideKeyboard() {
        DispatchQueue.main.async {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
    }
}

extension View {
    func image(size: CGSize? = nil) -> UIImage {
        func generateScreenshot(_ controller: UIHostingController<AnyView>) -> UIImage {
            let view = controller.view
            let targetSize = controller.view.intrinsicContentSize
            view?.bounds = CGRect(origin: .zero, size: targetSize)
            let format = UIGraphicsImageRendererFormat()
            format.scale = size?.width == AppConfig.exportSize ? 2 : 1
            let renderer = UIGraphicsImageRenderer(size: targetSize, format: format)
            return renderer.image { _ in
                view?.drawHierarchy(in: controller.view.bounds, afterScreenUpdates: true)
            }
        }

        if let exportSize = size {
            return generateScreenshot(UIHostingController(rootView: AnyView(self.frame(width: exportSize.width, height: exportSize.height).ignoresSafeArea().fixedSize(horizontal: true, vertical: true))))
        }
        
        return generateScreenshot(UIHostingController(rootView: AnyView(self.ignoresSafeArea().fixedSize(horizontal: true, vertical: true))))
    }
}

// MARK: - Present an alert from anywhere in the app
func presentAlert(title: String, message: String, primaryAction: UIAlertAction = .ok, secondaryAction: UIAlertAction? = nil) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    alert.addAction(primaryAction)
    if let secondary = secondaryAction { alert.addAction(secondary) }
    rootController?.present(alert, animated: true, completion: nil)
}

extension UIAlertAction {
    static var cancel: UIAlertAction {
        UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
    }
    
    static var ok: UIAlertAction {
        UIAlertAction(title: "OK", style: .cancel, handler: nil)
    }
}

var rootController: UIViewController? {
    var root = UIApplication.shared.windows.first?.rootViewController
    if let presenter = root?.presentedViewController { root = presenter }
    return root
}

// MARK: - Google AdMob Interstitial - Support class
class Interstitial: NSObject, GADFullScreenContentDelegate {
    @AppStorage("isPremiumUser") var isPremiumUser: Bool = false
    private var interstitial: GADInterstitialAd?
    private var presentedCount: Int = 0
    
    /// Default initializer of interstitial class
    override init() {
        super.init()
        loadInterstitial()
    }
    
    /// Request AdMob Interstitial ads
    func loadInterstitial() {
        let request = GADRequest()
        GADInterstitialAd.load(withAdUnitID: AppConfig.adMobAdId, request: request, completionHandler: { [self] ad, error in
            if ad != nil { interstitial = ad }
            interstitial?.fullScreenContentDelegate = self
        })
    }
    
    func showInterstitialAds() {
        presentedCount += 1
        if self.interstitial != nil, presentedCount % AppConfig.adMobFrequency == 0, !isPremiumUser {
            var root = UIApplication.shared.windows.first?.rootViewController
            if let presenter = root?.presentedViewController { root = presenter }
            self.interstitial?.present(fromRootViewController: root!)
        }
    }
    
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        loadInterstitial()
    }
}

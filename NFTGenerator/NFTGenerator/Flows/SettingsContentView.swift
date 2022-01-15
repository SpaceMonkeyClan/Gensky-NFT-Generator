//
//  SettingsContentView.swift
//  NFTGenerator
//
//  Created by Apps4World on 1/11/22.
//

import SwiftUI
import StoreKit
import MessageUI
import PurchaseKit

/// Main settings view
struct SettingsContentView: View {
    
    @EnvironmentObject private var manager: DataManager
    @State private var showLoadingView: Bool = false
    
    // MARK: - Main rendering function
    var body: some View {
        ZStack {
            Color("Primary").ignoresSafeArea()
            
            VStack(spacing: 10) {
                HeaderTitleView
                ScrollView(.vertical, showsIndicators: false, content: {
                    Spacer(minLength: 10)
                    VStack {
                        CustomHeader(title: "TUTORIAL")
                        TutorialItemView
                        CustomHeader(title: "SPREAD THE WORD")
                        RatingShareView
                        CustomHeader(title: "SUPPORT & PRIVACY")
                        PrivacySupportView
                    }.padding([.leading, .trailing], 20)
                    Spacer(minLength: 20)
                }).padding(.top, 5)
            }
            
            /// Show loading view
            LoadingView(isLoading: $showLoadingView)
                .mask(RoundedCorner(radius: 30, corners: [.topLeft, .topRight]))
        }
    }
    
    /// Header title view
    private var HeaderTitleView: some View {
        HStack(alignment: .top) {
            Text("Settings").font(.system(size: 30, weight: .bold))
            Spacer()
            Button {
                manager.fullScreenMode = nil
            } label: {
                Image(systemName: "xmark").font(.system(size: 22, weight: .semibold))
            }
        }
        .foregroundColor(.white)
        .padding(.horizontal, 20)
        .padding(.top)
    }
    
    /// Create custom header view
    private func CustomHeader(title: String, subtitle: String? = nil) -> some View {
        HStack {
            VStack(alignment: .leading) {
                Text(title).font(.system(size: 18, weight: .medium))
                if let subtitleText = subtitle {
                    Text(subtitleText)
                }
            }
            Spacer()
        }.foregroundColor(.white)
    }
    
    /// Tutorial option
    private var TutorialItemView: some View {
        VStack {
            SettingsItem(title: "How Does It Work?", icon: "questionmark.circle") {
                manager.fullScreenMode = .tutorial
            }
        }.padding([.top, .bottom], 5).background(
            Color("Secondary").cornerRadius(15)
                .shadow(color: Color.black.opacity(0.07), radius: 10)
        ).padding(.bottom, 40)
    }
    
    /// Custom settings item
    private func SettingsItem(title: String, icon: String, action: @escaping() -> Void) -> some View {
        Button(action: {
            UIImpactFeedbackGenerator().impactOccurred()
            action()
        }, label: {
            HStack {
                Image(systemName: icon).resizable().aspectRatio(contentMode: .fit)
                    .frame(width: 22, height: 22, alignment: .center)
                Text(title).font(.system(size: 18))
                Spacer()
                Image(systemName: "chevron.right")
            }.foregroundColor(Color("Text")).padding()
        })
    }
    
    // MARK: - In App Purchases
    private var InAppPurchasesView: some View {
        VStack {
            SettingsItem(title: "Upgrade Premium", icon: "crown") {
                manager.fullScreenMode = .subscriptions
            }
            Color("Text").frame(height: 1).opacity(0.2)
            SettingsItem(title: "Restore Purchases", icon: "arrow.clockwise") {
                showLoadingView = true
                PKManager.restorePurchases { _, status, _ in
                    DispatchQueue.main.async {
                        showLoadingView = false
                        if status == .restored { manager.isPremiumUser = true }
                    }
                }
            }
        }.padding([.top, .bottom], 5).background(
            Color("Secondary").cornerRadius(15)
                .shadow(color: Color.black.opacity(0.07), radius: 10)
        ).padding(.bottom, 40)
    }
    
    private var InAppPurchasesPromoBannerView: some View {
        ZStack {
            if manager.isPremiumUser == false {
                ZStack {
                    LinearGradient(gradient: Gradient(colors: [Color.white.opacity(0.2), Color.white.opacity(0.1)]), startPoint: .topLeading, endPoint: .bottom)
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Premium Version").bold().font(.system(size: 20))
                            Text("- Unlock NFT Collections").font(.system(size: 15)).opacity(0.7)
                            Text("- Unlock auto-generator").font(.system(size: 15)).opacity(0.7)
                            Text("- Remove ads").font(.system(size: 15)).opacity(0.7)
                        }
                        Spacer()
                        Image(systemName: "crown.fill").font(.system(size: 45))
                    }.foregroundColor(.white).padding([.leading, .trailing], 20)
                }.frame(height: 110).cornerRadius(15).padding(.bottom, 5)
            }
        }
    }
    
    // MARK: - Rating and Share
    private var RatingShareView: some View {
        VStack {
            SettingsItem(title: "Rate App", icon: "star") {
                if let scene = UIApplication.shared.windows.first?.windowScene {
                    SKStoreReviewController.requestReview(in: scene)
                }
            }
            Color("Text").frame(height: 1).opacity(0.2)
            SettingsItem(title: "Share App", icon: "square.and.arrow.up") {
                let shareController = UIActivityViewController(activityItems: [AppConfig.yourAppURL], applicationActivities: nil)
                RootViewController()?.present(shareController, animated: true, completion: nil)
            }
        }.padding([.top, .bottom], 5).background(
            Color("Secondary").cornerRadius(15)
                .shadow(color: Color.black.opacity(0.07), radius: 10)
        ).padding(.bottom, 40)
    }
    
    // MARK: - Support & Privacy
    private var PrivacySupportView: some View {
        VStack {
            SettingsItem(title: "E-Mail Me", icon: "envelope.badge") {
                EmailPresenter.shared.present()
            }
            Color("Text").frame(height: 1).opacity(0.2)
            SettingsItem(title: "Privacy Policy", icon: "hand.raised") {
                UIApplication.shared.open(AppConfig.privacyURL, options: [:], completionHandler: nil)
            }
            Color("Text").frame(height: 1).opacity(0.2)
            SettingsItem(title: "Developer Website", icon: "doc.text") {
                UIApplication.shared.open(AppConfig.termsAndConditionsURL, options: [:], completionHandler: nil)
            }
        }.padding([.top, .bottom], 5).background(
            Color("Secondary").cornerRadius(15)
                .shadow(color: Color.black.opacity(0.07), radius: 10)
        )
    }
}


// MARK: - Preview UI
struct SettingsContentView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsContentView().environmentObject(DataManager())
    }
}


// MARK: - Mail presenter for SwiftUI
class EmailPresenter: NSObject, MFMailComposeViewControllerDelegate {
    public static let shared = EmailPresenter()
    private override init() { }
    
    func present() {
        if !MFMailComposeViewController.canSendMail() {
            let alert = UIAlertController(title: "Email Simulator", message: "Email is not supported on the simulator. This will work on a physical device only.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            RootViewController()?.present(alert, animated: true, completion: nil)
            return
        }
        let picker = MFMailComposeViewController()
        picker.setToRecipients([AppConfig.emailSupport])
        picker.mailComposeDelegate = self
        RootViewController()?.present(picker, animated: true, completion: nil)
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        RootViewController()?.dismiss(animated: true, completion: nil)
    }
}

func RootViewController() -> UIViewController? {
    rootController
}

// MARK: - Present an alert from anywhere in the app
func presentAlert(title: String, message: String, primaryAction: UIAlertAction,
                  secondaryAction: UIAlertAction? = nil, autoDismiss: Bool = true) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    if autoDismiss == true {
        alert.addAction(primaryAction)
        if let secondary = secondaryAction { alert.addAction(secondary) }
    }
    
    RootViewController()?.present(alert, animated: true, completion: nil)
    
    /// Auto dismiss the alert
    if autoDismiss {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute:
            { alert.dismiss(animated: true, completion: nil) })
    }
}



//
//  BrowserView.swift
//  Checkers
//
//  Created by Dima Zhiltsov on 14.06.2025.
//

import SwiftUI
import MultipeerConnectivity

struct BrowserView: UIViewControllerRepresentable {
    let checkersSession: MultipeerManager
    
    func makeUIViewController(context: Context) -> MCBrowserViewController {
        let browser = MCBrowserViewController(serviceType: "checkers", session: checkersSession.session)
        browser.delegate = context.coordinator
        return browser
    }
    
    func updateUIViewController(_ uiViewController: MCBrowserViewController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, MCBrowserViewControllerDelegate {
        let parent: BrowserView
        
        init(_ parent: BrowserView) {
            self.parent = parent
        }
        
        func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
            browserViewController.dismiss(animated: true)
            parent.checkersSession.stopBrowsing()
        }
        
        func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
            browserViewController.dismiss(animated: true)
            parent.checkersSession.stopBrowsing()
        }
    }
    
}

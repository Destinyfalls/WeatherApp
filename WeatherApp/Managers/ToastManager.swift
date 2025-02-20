//
//  ToastView.swift
//  WeatherApp
//
//  Created by Igor Belobrov on 19.02.2025.
//

import SwiftUI

class ToastManager: ObservableObject {
    static let shared = ToastManager()
    
    @Published var message: String = ""
    @Published var isShowing: Bool = false
    
    private init() {}
    
    func showToast(message: String, duration: TimeInterval = 2.0) {
        self.message = message
        self.isShowing = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            withAnimation {
                self.isShowing = false
            }
        }
    }
}

struct ToastView: View {
    @ObservedObject var toastManager = ToastManager.shared
    
    var body: some View {
        if toastManager.isShowing {
            Text(toastManager.message)
                .padding()
                .background(Color.black.opacity(0.8))
                .foregroundColor(.white)
                .cornerRadius(10)
                .padding(.horizontal, 20)
                .transition(.move(edge: .top).combined(with: .opacity))
                .animation(.easeInOut, value: toastManager.isShowing)
        }
    }
}

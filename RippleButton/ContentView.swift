//
//  ContentView.swift
//  RippleButton
//
//  Created by Karthick Selvaraj on 07/06/20.
//  Copyright © 2020 Mallow Technologies Private Limited. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    @State var animate: Bool = false
    @State var shouldScaleButton: Bool = false
    @State var point: CGSize = CGSize.zero
    
    var body: some View {
        ZStack {
            Background { location in
                self.animate = false
                let p = CGSize(width: location.x - 100, height: location.y - 50)
                print(p)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0) {
                    withAnimation(nil) {
                        self.point = p
                    }
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    self.animate = true
                    self.shouldScaleButton = true
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    self.shouldScaleButton = false
                }
            }
            .background(Color.clear)
            .zIndex(1)
            .frame(width: 200, height: 100)
            Button(action: {
                print("Button action")
            }) {
                Text("Tap me")
                    .bold()
                    .padding()
                    .foregroundColor(.white)
                    .font(.title)
                    .frame(width: 200, height: 100)
                    .background(Color.blue)
                    .overlay(
                        Circle()
                            .stroke(Color.blue, lineWidth: 20)
                            .opacity(self.animate ? 0 : 1)
                            .frame(width: 1, height: 1)
                            .shadow(color: Color.white.opacity(0.3), radius: 20)
                            .scaleEffect(self.animate ? 20 : 0)
                            .animation(self.animate ? Animation.easeOut(duration: 1) : nil)
                            .offset(point)
                            .animation(nil)
                )
                    .mask(
                        RoundedRectangle(cornerRadius: 10)
                            .frame(width: 200, height: 100)
                )
            }
        }
        .scaleEffect(self.shouldScaleButton ? 0.8 : 1)
        .animation(Animation.spring(response: 1, dampingFraction: 1, blendDuration: 0.1))
        
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


// Credit: https://stackoverflow.com/a/56518293/6355922

struct Background: UIViewRepresentable {
    
    var tappedCallback: ((CGPoint) -> Void)
    
    
    // MARK: - UIViewRepresentable methods
    
    func makeCoordinator() -> Background.Coordinator {
        Coordinator(tappedCallback:self.tappedCallback)
    }
    
    func makeUIView(context: UIViewRepresentableContext<Background>) -> UIView {
        let view = UIView(frame: .zero)
        let gesture = UITapGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.tapped))
        view.addGestureRecognizer(gesture)
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<Background>) {
        // Do nothing
    }
    
    
    // MARK: - Coordinator
    
    class Coordinator: NSObject {
        
        var tappedCallback: ((CGPoint) -> Void)
        
        
        // MARK: - Initialiser
        
        init(tappedCallback: @escaping ((CGPoint) -> Void)) {
            self.tappedCallback = tappedCallback
        }
        
        // MARK: - Custom methods
        
        @objc func tapped(gesture:UITapGestureRecognizer) {
            let point = gesture.location(in: gesture.view)
            self.tappedCallback(point)
        }
        
    }
    
}

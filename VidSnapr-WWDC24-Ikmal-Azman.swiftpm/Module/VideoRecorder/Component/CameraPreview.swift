//
//  CameraPreview.swift
//  SwiftUI-VideoPlayer
//
//  Created by esikmalazman on 08/02/2024.
//

import SwiftUI
import AVFoundation

/// SwiftUI View wrapper for AVCaptureVideoPreviewLayer to display camera feed
struct CameraPreview : UIViewRepresentable {
  @Binding var session : AVCaptureSession
  
  func makeUIView(context: Context) -> some UIView {
    let view = UIView()
    
    let previewLayer = AVCaptureVideoPreviewLayer(session: session)
    previewLayer.videoGravity = .resizeAspectFill
    view.layer.addSublayer(previewLayer)
    return view
  }
  
  func updateUIView(_ uiView: UIViewType, context: Context) {
    if let layer = uiView.layer.sublayers?.first as? AVCaptureVideoPreviewLayer {
      layer.session = session
      layer.frame = uiView.bounds
    }
  }
}


#Preview {
  CameraPreview(session: .constant(AVCaptureSession()))
}

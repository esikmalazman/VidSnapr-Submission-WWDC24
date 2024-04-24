//
//  VideoPlaybackView.swift
//  SwiftUI-VideoPlayer
//
//  Created by esikmalazman on 09/02/2024.
//

import SwiftUI
import AVKit

struct VideoPlaybackView : UIViewControllerRepresentable {
  let player : AVPlayer
  
  func makeUIViewController(context: Context) -> some AVPlayerViewController {
    let view  = AVPlayerViewController()
    view.player = player
    view.videoGravity = .resizeAspect
    view.showsPlaybackControls = false
    /// Disable speed in playback controls
    view.speeds = []
    /// Disable picture in picture in playback controls
    view.allowsPictureInPicturePlayback = false
    
#if !targetEnvironment(macCatalyst)
    /// Disable live text interaction
    view.allowsVideoFrameAnalysis = false
#endif
    
    return view
  }
  
  func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
}

#Preview {
  VideoPlaybackView(player: .init(url: .sampleVideoURL))
}

//
//  SliderPlayback.swift
//  SwiftUI-VideoPlayer
//
//  Created by esikmalazman on 27/01/2024.
//

import SwiftUI
import AVKit
#warning("Add UI for image captured preview")

struct VideoSliderScreen: View {
  @EnvironmentObject private var router : Router<Path>
  @State private var seekTime : Double = 0
  @State private var capturedImages : [UIImage] = []
  
  @State var player : AVPlayer
  
  var videoDuration : Double {
    player.currentItem?.asset.duration.seconds ?? 0
  }
  
  var body: some View {
    ZStack {
      VideoPlaybackView(player: player)
        .ignoresSafeArea()
        .overlay(alignment: .bottom) {
          VStack(spacing : 10) {
            saveImageButton
            videoSlider
          }
          .padding(.horizontal)
        }
    }
    .background(Color.black.ignoresSafeArea())
    .safeAreaInset(edge: .bottom, alignment: .trailing) { continueButton }
  }
}

extension VideoSliderScreen {
  var videoSlider : some View {
    Slider(
      value: $seekTime,
      in: 0.0...1.0
    ) {} minimumValueLabel: {
      Text("\(player.currentTime().seconds.toMinuteAndSecond)")
    } maximumValueLabel: {
      Text("\(videoDuration.toMinuteAndSecond)")
    }
    .padding(.vertical, 5)
    .padding(.horizontal, 10)
    .background(.regularMaterial)
    .tint(.pink)
    .clipShape(.capsule)
    .onChange(of: seekTime) { value in
      let seekTime = currentSeekTime() ?? .zero
      player.seek(to: seekTime)
    }
    .foregroundColor(.white)
  }
  
  var continueButton : some View {
    Button{
      let thumbnails = capturedImages.compactMap { image in
        Thumbnail(originalImage: image)
      }
      router.push(.photosEditor(images: thumbnails))
    } label: {
      Text("Continue")
        .frame(height: 30)
      
    }
    .buttonStyle(.borderedProminent)
    .tint(.indigo)
    .padding(.trailing)
    .disabled(capturedImages.isEmpty)
  }
  
  var saveImageButton : some View {
    Button {
      let hapticGenerator = UINotificationFeedbackGenerator()
      hapticGenerator.notificationOccurred(.success)
      
      captureImageFromVideo()
    } label: {
      Label("Capture Image", systemImage: "camera.shutter.button")
        .labelStyle(.iconOnly)
        .foregroundStyle(.white)
        .padding()
        .background(
          Color.indigo
            .clipShape(.circle)
        )
    }
    
    
  }
  
  func currentSeekTime() -> CMTime? {
    guard let item = player.currentItem else {return nil}
    let totalSeconds = CMTimeGetSeconds(item.duration)
    // Calculate time we need to seek based on slider value and duration of the video
    // https://www.youtube.com/watch?v=HX1aYzaHex8
    let value = Float64(seekTime) * totalSeconds
    let seekTime = CMTime(value: Int64(value), timescale: 1)
    
    return seekTime
  }
  
  func captureImageFromVideo()  {
    Task { @MainActor in
      let cmTime = currentSeekTime() ?? .zero
      guard let currentVideo = player.currentItem?.asset else {return}
      
      let assetImage = AVAssetImageGenerator(asset: currentVideo)
      assetImage.appliesPreferredTrackTransform = true
      assetImage.apertureMode = .cleanAperture
      if let videoTrack = try await currentVideo.loadTracks(withMediaType: .video).first {
        let originalSize = videoTrack.naturalSize
        assetImage.maximumSize = .init(width: originalSize.width, height: originalSize.height)
      }
      
      do {
        let capturedImage = try await assetImage.image(at: cmTime).image
        let uiImage = UIImage(cgImage: capturedImage)
        print("Image Size : \(String(describing: uiImage.size))")
        
        self.capturedImages.append(uiImage)
      } catch {
        print(error.localizedDescription)
      }
    }
  }
}

#Preview {
  VideoSliderScreen(player: .init(url: .sampleVideoURL))
}


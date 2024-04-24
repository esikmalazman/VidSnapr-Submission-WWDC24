//
//  ChooseMediaView.swift
//  SwiftUI-VideoPlayer
//
//  Created by esikmalazman on 28/01/2024.
//

import SwiftUI
import PhotosUI

struct ChooseVideoScreen: View {
  @EnvironmentObject var router : Router<Path>
  @ObservedObject var assetLoader : AssetLoader = AssetLoader()
  @State var selectedVideo : PhotosPickerItem?
  @State var shouldShowNotCompatible : Bool = false
  
  init() {
    UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor : UIColor.systemIndigo]
  }
  
  var body: some View {
    ZStack {
      
      VStack {
        instructionView
        
        HStack {
          selectAlbumButton
          recordButton
        }
      }
    }
    .onChange(of: assetLoader.movie) { video in
      guard let videoURL = video?.url else {return}
      router.push(.videoSlider(url: videoURL))
    }
    .progressView(isShowing: $assetLoader.shouldProgressView, "Load video from album")
    .toast(isShowing: $assetLoader.shouldShowErrorToast, kind: .failure, message: assetLoader.errorMessage)
    .alert( "This app is not supported in simulator, please use physical device", isPresented: $shouldShowNotCompatible, actions: {})
    .navigationTitle("VidSnapr")
    .navigationBarTitleDisplayMode(.large)
  }
  
  var selectAlbumButton : some View {
    PhotosPicker(selection: $selectedVideo, matching: .videos) {
      Label("Selected Video", systemImage: "photo")
        .padding()
        .overlay(
          RoundedRectangle(cornerRadius: 10)
            .stroke(.indigo, lineWidth: 1)
        )
        .foregroundStyle(.indigo)
        .frame(maxWidth: .infinity)
    }
    .onChange(of: selectedVideo, perform: { newValue in
      guard let selectedVideo = selectedVideo else {return}
      assetLoader.loadVideo(from: selectedVideo)
    })
  }
  
  var recordButton : some View {
    Button {
#if !targetEnvironment(simulator)
      router.push(.videoRecorder)
#else
      shouldShowNotCompatible = true
#endif
      
    } label: {
      Label("Record Video", systemImage: "video.fill")
        .padding()
        .background(.red)
        .clipShape(.rect(cornerRadius: 10))
        .foregroundStyle(.white)
        .frame(maxWidth: .infinity)
    }
  }
  
  var instructionView : some View {
    InstructionView()
  }
}

#Preview {
  ChooseVideoScreen()
}

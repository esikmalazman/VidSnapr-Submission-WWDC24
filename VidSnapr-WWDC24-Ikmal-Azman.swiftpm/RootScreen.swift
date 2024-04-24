//
//  RootScreen.swift
//  SwiftUI-VideoPlayer
//
//  Created by esikmalazman on 09/02/2024.
//

import SwiftUI

struct RootScreen: View {
  @StateObject var router = Router<Path>()
  
  var body: some View {
    NavigationStack(path: $router.paths) {
      ChooseVideoScreen()
        .navigationDestination(for: Path.self) { path in
          switch path {
          case .chooseMedia :
            ChooseVideoScreen()
          case .videoRecorder :
            VideoRecorderScreen()
          case .videoSlider(let url) :
            VideoSliderScreen(player: .init(url: url))
          case .photosEditor(let thumbnails) :
            PhotosEditorScreen(thumbnails: thumbnails)
          }
        }
    }
    .environmentObject(router)
  }
}

#Preview {
  RootScreen()
}

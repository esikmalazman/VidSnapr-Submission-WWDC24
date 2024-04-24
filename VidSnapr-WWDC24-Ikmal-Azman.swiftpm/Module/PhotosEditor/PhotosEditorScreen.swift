//
//  PhotosEditorView.swift
//  SwiftUI-VideoPlayer
//
//  Created by esikmalazman on 01/02/2024.
//

import SwiftUI

struct PhotosEditorScreen: View {
  @EnvironmentObject var router : Router<Path>
  @ObservedObject var imageEngine : ImageSuperResEngine = ImageSuperResEngine()

  @State var selectedThumbnail : Thumbnail?
  @State var thumbnails : [Thumbnail] = []
  @State var shouldShowPreview : Bool = false
  
  var body: some View {
    VStack {
      upscaleButtonView
      imagePreviewView
      galleryView
      bottomActionView
    }
    .background(
      Color.black
        .ignoresSafeArea()
    )
    .progressView(isShowing: $imageEngine.shouldShowLoading, "Fine tuning the image")
    .toast(
      isShowing: $imageEngine.shouldShowErrorToast,
      kind: .failure,
      message: imageEngine.message
    )
    .toast(
      isShowing: $imageEngine.shouldShowSuccessToast,
      kind: .success,
      message: imageEngine.message,
      completion :router.popToRoot
    )
    .onChange(of: imageEngine.resultImage) { value in
      guard let _ = value else {return}
      shouldShowPreview = true
    }
    .onChange(of: thumbnails.isEmpty) { _ in
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
        self.router.pop()
      }
    }
    .onAppear { self.selectedThumbnail = thumbnails.first }
    .onDisappear(perform: clearUIState)
    .sheet(isPresented: $shouldShowPreview) {
      UpscalePreviewScreen(
        editedImage: $imageEngine.resultImage,
        originalImage: $imageEngine.originalImage,
        action: handleUpscaleSheetAction
      )
    }
    .navigationBarBackButtonHidden()
  }
  
  var imagePreviewView : some View {
    ImagePreview(selectedThumbnail: $selectedThumbnail)
  }
  
  var upscaleButtonView : some View {
    UpscaleButton(action: beginEnchancingImage)
      .opacity(selectedThumbnail?.isUpscaled ?? false ? 0 : 1)
  }
  
  var galleryView : some View {
    CarousellView(thumbnails: thumbnails) { thumbnail in
      self.selectedThumbnail = thumbnail
    }
  }
  
  var bottomActionView : some View {
    BottomActionView(removeAction: removeImageFromEditor, doneAction: exportImageToAlbum)
  }
  
  func beginEnchancingImage() {
#warning("Change this to Prod once its ready")
    if let selectedThumbnail = selectedThumbnail {
      imageEngine.requestImageEnchancement(selectedThumbnail.originalImage, for: .prod)
    }
  }
  
  func clearUIState() {
    thumbnails = []
    selectedThumbnail = nil
  }
  
  func removeImageFromEditor() {
    if let index = thumbnails.firstIndex(where: { $0.id == selectedThumbnail?.id}) {
      thumbnails.remove(at: index)
    } else {
      guard !thumbnails.isEmpty else {return}
      
      thumbnails.removeFirst()
    }
    selectedThumbnail = thumbnails.first
  }
  
  func exportImageToAlbum() {
    let images = thumbnails.map { $0.originalImage }
    imageEngine.saveImageToAlbum(images)
  }
  
  func handleUpscaleSheetAction(_ action : UpscalePreviewScreen.Action) {
    switch action {
    case .dismiss:
      shouldShowPreview = false
      selectedThumbnail?.isUpscaled = false
      
    case .apply(let image):
      guard let image = image else {return}
      selectedThumbnail?.originalImage = image
      selectedThumbnail?.isUpscaled = true
      if let candidateIndex = thumbnails.firstIndex(where: { $0.id == selectedThumbnail?.id}) {
        thumbnails[candidateIndex].isUpscaled = true
        thumbnails[candidateIndex].originalImage = image
      }
      shouldShowPreview = false
    }
  }
}

#Preview {
  PhotosEditorScreen(thumbnails: .samples)
}

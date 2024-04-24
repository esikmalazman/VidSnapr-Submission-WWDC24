//
//  UpscaleSheetView.swift
//  SwiftUI-VideoPlayer
//
//  Created by esikmalazman on 03/02/2024.
//

import SwiftUI

enum ImageState : String, CaseIterable, Identifiable {
  case original
  case edited
  
  var id: Self {self}
}

struct UpscalePreviewScreen: View {
  
  enum Action {
    case dismiss
    case apply(image : UIImage?)
  }
  
  @Binding var editedImage : UIImage?
  @Binding var originalImage : UIImage?
  
  @State private var imageStatus : ImageState = .edited
  var action : (Action) -> Void?
  
  var body: some View {
    VStack {
      HStack {
        Spacer()
        
        Text("Image Preview")
          .font(.title3)
          .fontWeight(.bold)
        
        Spacer()
        
      }
      .padding(.vertical)
      
      Picker("", selection: $imageStatus) {
        ForEach(ImageState.allCases) { state in
          Text(state.rawValue.capitalized)
        }
      }
      .pickerStyle(.segmented)
      
      PhotoView(
        image: imageStatus == .original ? $originalImage : $editedImage,
        height: .infinity,
        width: .infinity
      )
      .padding(.vertical)
      
      Label(
        "You cannot undo this step after upscaling the image",
        systemImage: "exclamationmark.triangle.fill"
      )
      .font(.caption)
      .lineLimit(2)
      .padding(.bottom)
      .foregroundStyle(.orange)
      
      HStack {
        Button {
          action(.dismiss)
        } label: {
          Label("Cancel", systemImage: "xmark")
            .padding(5)
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(.bordered)
        .tint(.pink.opacity(0.8))
        
        Button {
          action(.apply(image: editedImage))
        } label: {
          Label("Apply", systemImage: "checkmark")
            .padding(5)
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(.borderedProminent)
        .tint(.indigo)
      }
      .padding(.vertical)
    }
    .padding(.horizontal)
  }
}

struct TimerCardView_Previews: PreviewProvider {
  static var previews: some View {
    UpscalePreviewScreen(editedImage: .constant(UIImage(systemName: "photo")!), originalImage: .constant(UIImage(systemName: "photo.fill"))) { _ in}
      .previewLayout(.sizeThatFits)
  }
}

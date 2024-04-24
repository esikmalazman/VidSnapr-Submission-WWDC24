//
//  AssetLoader.swift
//  SwiftUI-VideoPlayer
//
//  Created by esikmalazman on 16/02/2024.
//

import Foundation
import PhotosUI
import SwiftUI

@MainActor
final class AssetLoader : ObservableObject {
  @Published var image : CIImage?
  @Published var movie : Movie?
  @Published var errorMessage : String = ""
  @Published var shouldShowErrorToast : Bool = false
  @Published var shouldProgressView : Bool = false
  
  @discardableResult
  func loadImage(from pickerItem : PhotosPickerItem) async -> CIImage {
    let data = try? await pickerItem.loadTransferable(type: Data.self)
    return CIImage(data: data!)!
  }
  
  func loadVideo(from pickerItem : PhotosPickerItem)  {
    self.shouldProgressView = true
    Task {
      do {
        let data = try await pickerItem.loadTransferable(type: Movie.self)
        self.movie = data
        self.shouldProgressView = false
        print("Movie import succesfully!!")
      } catch {
        shouldShowErrorToast = true
        self.errorMessage = "Fail to import selected video : \(error.localizedDescription)"
      }
    }
  }
}

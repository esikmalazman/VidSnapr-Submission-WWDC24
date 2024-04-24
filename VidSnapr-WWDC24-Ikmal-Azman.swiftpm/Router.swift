//
//  Router.swift
//  SwiftUI-VideoPlayer
//
//  Created by esikmalazman on 09/02/2024.
//

import Foundation

enum Path : Hashable {
  case chooseMedia
  case videoRecorder
  case videoSlider(url : URL)
  case photosEditor(images : [Thumbnail])
}

@MainActor
final class Router<T:Hashable> : ObservableObject {
  /// Collection of Path for NavigationStack
  @Published var paths : [T] = []
  
  /// Method to push new screen by appending path into paths collection
  /// - Parameter path: new screen to push
  func push(_ path : T) {
      paths.append(path)
  }
  
  /// Method to pop the current screen to previous screen by remove 1 element in paths collection
  func pop() {
      paths.removeLast(1)
  }
  
  /// Method to pop current screen to specified previous screen by find index of screen and remove the element in paths collection until it found the screen
  /// - Parameter path: previous screen to pop into
  func pop(to path : T) {
      ///
      guard let pathIndex = paths.firstIndex(where: { $0 == path }) else {
          return
      }
      
      let numberToPop = (pathIndex..<paths.endIndex).count - 1
      paths.removeLast(numberToPop)
  }
  
  /// Method to pop current screen to the root
  func popToRoot() {
      paths.removeAll()
  }
}

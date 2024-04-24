//
//  Movie.swift
//  SwiftUI-VideoPlayer
//
//  Created by esikmalazman on 09/02/2024.
//

import Foundation
import CoreTransferable

/// https://www.hackingwithswift.com/quick-start/swiftui/how-to-let-users-import-videos-using-photospicker
/// Custom Movie object to tell SwiftUI how to import video data.
/// - Sending video data with Transferable by converting it to SentTransferredFile which allow us to get copy of the video into the the app
struct Movie : Transferable, Equatable {
  
  let url : URL
  
  static var transferRepresentation: some TransferRepresentation {
    /// FileRepresentation, allow to transfer types that involve a large amount of data
    FileRepresentation(contentType: .movie) { movie in
      /// Export copy of video from gallery
      SentTransferredFile(movie.url)
    } importing: { received in
      /// Received copy of the video url to our app directory as 'movie.mp4'
      let copyOfMovie = URL.documentsDirectory.appending(path: "movie.mp4")
      
      /// Remove any existing file
      if FileManager.default.fileExists(atPath: copyOfMovie.path) {
        try FileManager.default.removeItem(at: copyOfMovie)
      }
      
      try FileManager.default.copyItem(at: received.file, to: copyOfMovie)
      return Self.init(url: copyOfMovie)
    }
  }
}

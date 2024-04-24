//
//  VideoRecordingEngine.swift
//  SwiftUI-VideoPlayer
//
//  Created by esikmalazman on 08/02/2024.
//

import Foundation
import AVFoundation
import PhotosUI

/// https://www.kodeco.com/books/swiftui-cookbook/v1.0/chapters/5-recording-audio-video-in-swiftui
/// Custom Recorder object that manage AVCaptureSession and Recording state
/// - Handle adding Audio & Video input to session
/// - Start & Stop video recording
/// - Save recorded video in Photo Library
final class VideoRecordingEngine : NSObject, ObservableObject {
  enum CameraPosition {
    case front, back
    
    var position : AVCaptureDevice.Position {
      switch self {
      case .front:
        return .front
      case .back:
        return .back
      }
    }
  }
  
  @Published var session = AVCaptureSession()
  @Published var isRecording : Bool = false
  @Published var errorMessage : String = ""
  @Published var outputFileURL : URL?
  @Published var cameraPosition : CameraPosition = .back
  
  private let movieOutput = AVCaptureMovieFileOutput()
  
  override init() {
    super.init()
    addVideoInput()
    addAudioInput()
    addMovieOutput()
    
    DispatchQueue.global(qos: .userInitiated).async { [weak self] in
      self?.session.sessionPreset = .hd4K3840x2160
      self?.session.startRunning()
    }
  }
  
  // https://stackoverflow.com/questions/31879819/switch-front-back-camera-with-avcapturesession
  func toggleCamera() {
    if cameraPosition == .back {
      cameraPosition = .front
    } else if cameraPosition == .front {
      cameraPosition = .back
    }
    
    guard let currentInput = session.inputs.first as? AVCaptureDeviceInput else {return}
    
    session.beginConfiguration()
    
    session.removeInput(currentInput)
    addVideoInput(withPosition: cameraPosition)
    
    session.commitConfiguration()
  }
  
  /// Method to start  video recording
  /// - Check if recording is in progress. Otherwise remove any existing file at the `output URL` and begin recording and set `isRecording` flag to `true`
  func startRecording() {
    
    let videoName = "V\(UUID().uuidString)"
    guard let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("\(videoName)").appendingPathExtension("mov") else {return}
    
    if movieOutput.isRecording == false {
      if FileManager.default.fileExists(atPath: url.path) {
        try? FileManager.default.removeItem(at: url)
      }
      
      movieOutput.startRecording(to: url, recordingDelegate: self)
      isRecording = true
    }
  }
  
  /// Method to stop video recording
  /// - Stop all the in-progress recording and `isRecording` flag to `true` and begin writing video file
  func stopRecording() {
    if movieOutput.isRecording == true {
      movieOutput.stopRecording()
      isRecording = false
    }
  }
}

extension VideoRecordingEngine : AVCaptureFileOutputRecordingDelegate {
  func fileOutput(_ output: AVCaptureFileOutput, didStartRecordingTo fileURL: URL, from connections: [AVCaptureConnection]) {
    /// Handle action when recording starts, we can change the state of the UI here for instance
  }
  
  func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
    /// Handle action when recording ends
    if let error = error {
      errorMessage = "Error to finish recording : \(error.localizedDescription)"
      print("Error recording : \(error.localizedDescription)")
      return
    }
    
    /// Save video to Photos Library
    PHPhotoLibrary.shared().performChanges {
      /// Request to add video into Photos Library with specified file url
      PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: outputFileURL)
      
    } completionHandler: { isVideoSaved, error in
      if let error = error {
        self.errorMessage = "Error save recorded video file : \(error.localizedDescription)"
        print("Error save recorded video file : \(error.localizedDescription)")
        return
      }
      
      
      
      guard isVideoSaved else {return}
      
      DispatchQueue.main.async { [weak self] in
        self?.outputFileURL = outputFileURL
      }
      print("Success save recorded video file")
    }
  }
}

private extension VideoRecordingEngine {
  /// Add video capture device and input into session
  private func addVideoInput(withPosition position : CameraPosition = .back) {
    guard let device = AVCaptureDevice.default(.builtInWideAngleCamera,for: .video, position: cameraPosition.position) else {return}
    
    try? device.lockForConfiguration()
    /// Enable smooth autofocus when capture video
    if device.isSmoothAutoFocusSupported {
      device.isSmoothAutoFocusEnabled = true
    }
    device.unlockForConfiguration()
    
    guard let input = try? AVCaptureDeviceInput(device: device) else {return}
    
    if session.canAddInput(input) {
      session.addInput(input)
    }
  }
  
  /// Add audio capture device and input into session
  private func addAudioInput() {
    guard let device = AVCaptureDevice.default(for: .audio) else {return}
    guard let input = try? AVCaptureDeviceInput(device: device) else {return}
    
    if session.canAddInput(input) {
      session.addInput(input)
    }
  }
  
  /// Add capture output that record video and audio into session
  private func addMovieOutput() {
    if session.canAddOutput(movieOutput) {
      session.addOutput(movieOutput)
    }
    
    let connection = movieOutput.connection(with: .video)
    /// Enable best stablization mode during video recording
    connection?.preferredVideoStabilizationMode = .cinematicExtended
  }
}

//
//  ImageEnhancer.swift
//  SwiftUI-VideoPlayer
//
//  Created by esikmalazman on 04/02/2024.
//

import Foundation
import UIKit.UIImage
import Vision

final class ImageSuperResEngine : NSObject, ObservableObject {
  enum State : Equatable {
    case unknown, loading, error, complete, saved
  }
  
  enum Mode {
    case dev, prod
  }
  
  @Published var message : String = ""
  @Published var shouldShowLoading : Bool = false
  @Published var shouldShowErrorToast : Bool = false
  @Published var shouldShowSuccessToast : Bool = false
  @Published var shouldShowPreview : Bool = false
  
  @Published var state : State = .unknown {
    didSet {
      self.shouldShowLoading = state == .loading
      self.shouldShowErrorToast = state == .error
      self.shouldShowSuccessToast = state == .saved
    }
  }
  
  @Published var resultImage : UIImage?
  @Published var originalImage : UIImage?
  
  let ciContext : CIContext = CIContext()
  
  func saveImageToAlbum(_ images : [UIImage]) {
    for image in images {
      UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    state = .saved
    message = "Images Saved Successfully"
  }
  

  @objc
  private func image(_ image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: UnsafeMutableRawPointer?) {
    if let error = error {
      state = .error
      message = "Error saving image to album : \(error.localizedDescription)"
    }
  }
  
  func requestImageEnchancement(_ image : UIImage?,for mode : Mode = .prod) {
    
    guard mode == .prod else {
      self.originalImage = image
      self.resultImage = UIImage(named: "resultMock")
      return
    }
  
    guard let image = image, let cgImage = image.cgImage else {return}
    self.originalImage = image
    
    let ciImage = CIImage(cgImage: cgImage)
    
    
    self.state = .loading
    
    DispatchQueue.global(qos: .userInitiated).async {
      let bsrgan = try? realesrgan512_fp8(configuration: MLModelConfiguration())
      
      
      guard let superResModel = try? VNCoreMLModel(for: bsrgan!.model) else {
        self.state = .error
        self.message = "Error to initialise ML Model"

        return
      }
      
      let request = VNCoreMLRequest(model: superResModel, completionHandler: self.processResults)
      
      do {
        let handler = VNImageRequestHandler(ciImage: ciImage)
        try handler.perform([request])
      } catch {
        self.state = .error
        self.message = "Could not perform request : \(error.localizedDescription)"
      }
    }
  }
  
  private func processResults(for request : VNRequest, _ error : Error?) {
    if let error = error {
      print("Error make request")
      self.state = .error
      self.message = "Error make request : \(error)"
      return
    }
    
    guard let results = request.results as? [VNPixelBufferObservation] else {
      print("Could not get any VNPixelBufferObservation results")

      self.state = .error
      self.message = "Could not get any VNPixelBufferObservation results"
      return
    }
    
    guard let observation = results.first else {
      print("No observation first result available")
      self.state = .error
      self.message = "No observation first result available"
      return
    }
    
    /// To make CIImage show correctly with UIImage, we need to convert it to CGImage first via CIContext, otherswise result will show blank
    let ciImage = CIImage(cvPixelBuffer: observation.pixelBuffer)
    let cgImage = ciContext.createCGImage(ciImage, from: ciImage.extent)
    
    let resultImage = UIImage(cgImage: cgImage!)
    
    DispatchQueue.main.async {
      self.state = .complete
      self.resultImage = resultImage
    }
  }
}

//
//  ImageDownloader.swift
//  ImageDownloader
//
//  Created by Artem Mysik on 25.06.18.
//  Copyright © 2018 artemmysik. All rights reserved.
//

import Foundation
import UIKit

struct ImageDownloader {
  
  enum ImageDownloadResult {
    case success(url: URL, image: UIImage)
    case error(String, url: URL)
  }
  
  fileprivate static let imageExtensions = ["png", "jpg", "gif"]
  
  static func downloadImage(url: URL, completion: @escaping (ImageDownloadResult) -> Void) {
    if url.pathExtension != String(),
      !imageExtensions.contains(url.pathExtension) {
      completion(.error(TextConstants.Errors.fileIsNotImage, url: url))
      
      return
    }
    
    if let image = getImageFromStorageURL(url) {
      completion(.success(url: url, image: image))
      
      return
    }
    
    URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
      guard let data = data,
        let mainURL = response?.url,
        error == nil else {
          DispatchQueue.main.async {
            completion(.error(TextConstants.Errors.downloadingError, url: url))
          }
          
        return
      }
      
      if let image = UIImage(data: data) {
        saveImage(image: image, url: mainURL)
        
        DispatchQueue.main.async {
          completion(.success(url: mainURL, image: image))
        }
      } else {
        DispatchQueue.main.async {
          completion(.error(TextConstants.Errors.unableToCreateImage, url: mainURL))
        }
      }
    }).resume()
  }
  
  private static func saveImage(image: UIImage, url: URL) {
    if let data = UIImagePNGRepresentation(image) {
      let filename = getDocumentsDirectory().appendingPathComponent(String(url.hashValue))
      try? data.write(to: filename)
    }
  }
  
  private static func getImageFromStorageURL(_ url: URL) -> UIImage? {
    let imageURL = getDocumentsDirectory().appendingPathComponent(String(url.hashValue))
    
    if let image = UIImage(contentsOfFile: imageURL.path) {
      return image
    }
    
    return nil
  }
  
  private static func getDocumentsDirectory() -> URL {
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    let documentsDirectory = paths[0]
    return documentsDirectory
  }
  
}

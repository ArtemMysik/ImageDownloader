//
//  ImageDownloadPresenter.swift
//  ImageDownloader
//
//  Created by Artem Mysik on 25.06.2018.
//  Copyright © 2018 artemmysik. All rights reserved.
//

import Foundation
import UIKit

protocol ImageDownloadViewOutput {
  func triggerDownloadTouch(textFieldString: String)
}

class ImageDownloadPresenter: ImageDownloadViewOutput {
  
  //MARK: - Properties
  weak var view: ImageDownloadViewInput!
  fileprivate var currentDownloadingURL: URL?
  
  //MARK: - Life Cycle
  required init(view: ImageDownloadViewInput) {
    self.view = view
  }
  
  //MARK: - ImageDownloadViewOutput
  func triggerDownloadTouch(textFieldString: String) {
    downloadDataFrom(string: textFieldString)
  }
  
  //MARK: - Private Methods
  fileprivate func downloadDataFrom(string: String) {
    if let url = URL(string: string), UIApplication.shared.canOpenURL(url) {
      currentDownloadingURL = url
      
      view.changeActivityIndicatorStatus(isAnimating: true)
      ImageDownloader.downloadImage(url: url) { [weak self] (result) in
        self?.handleImageDownloadResult(result: result)
        self?.view.changeActivityIndicatorStatus(isAnimating: false)
      }
    } else {
      currentDownloadingURL = nil
      view.showMessage(TextConstants.Errors.wrongURL)
    }
  }
  
  fileprivate func handleImageDownloadResult(result: ImageDownloader.ImageDownloadResult) {
    switch result {
    case .success(let url, let image):
      if currentDownloadingURL == url {
        view.displayImage(image)
      }
      
    case .error(let error, let url):
      if currentDownloadingURL == url {
        view.showMessage(error)
      }
    }
  }
  
}

//
//  ImageDownloadViewController.swift
//  ImageDownloader
//
//  Created by Artem Mysik on 25.06.18.
//  Copyright © 2018 artemmysik. All rights reserved.
//

import UIKit

protocol ImageDownloadViewInput: class {
  func changeActivityIndicatorStatus(isAnimating: Bool)
  func showMessage(_ message: String)
  func displayImage(_ image: UIImage)
  func hideImage()
}

class ImageDownloadViewController: UIViewController, AlertMessageShowing {
  
  //MARK: - Properties
  @IBOutlet fileprivate weak var textField: UITextField!
  @IBOutlet fileprivate weak var imageView: UIImageView!
  @IBOutlet fileprivate weak var activityIndicator: UIActivityIndicatorView!
  fileprivate var presenter: ImageDownloadViewOutput!
  
  //MARK: - Life Cycle
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    presenter = ImageDownloadPresenter(view: self)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupTextField()
  }
  
  //MARK: - Private Methods
  fileprivate func setupTextField() {
    hideKeyboardWhenTappedAround()
    textField.becomeFirstResponder()
    textField.delegate = self
  }
  
  //MARK: - Interface Handlers
  @IBAction func didTouchDownloadButton(_ sender: Any) {
    textField.resignFirstResponder()
    presenter.triggerDownloadTouch(textFieldString: textField.text ?? String())
  }
  
}

//MARK: - Extension

//MARK: - ImageDownloadViewInput
extension ImageDownloadViewController: ImageDownloadViewInput {
  
  func changeActivityIndicatorStatus(isAnimating: Bool) {
    if isAnimating {
      activityIndicator.startAnimating()
    } else {
      activityIndicator.stopAnimating()
    }
  }
  
  func showMessage(_ message: String) {
    showAlert(message: message, handler: nil)
  }
  
  func displayImage(_ image: UIImage) {
    imageView.image = image
  }
  
  func hideImage() {
    imageView.image = nil
  }
  
}

//MARK: - UITextFieldDelegate
extension ImageDownloadViewController: UITextFieldDelegate {
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    presenter.triggerDownloadTouch(textFieldString: textField.text ?? String())
    textField.resignFirstResponder()
    
    return true
  }
  
}

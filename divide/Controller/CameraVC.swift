//
//  CameraVC.swift
//  divide
//
//  Created by Adil Jiwani on 2017-11-28.
//  Copyright © 2017 Adil Jiwani. All rights reserved.
//

import UIKit
import AVFoundation
import TesseractOCR

class CameraVC: UIViewController {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var takePhotoBtn: RoundedButton!
    
    @IBOutlet weak var textView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.isHidden = true
        takePhotoBtn.setTitle("Take Photo / Upload Image", for: .normal)
    }
    
    func performImageRecognition(_ image: UIImage) {
        var date = Date()
        if let tesseract = G8Tesseract(language: "eng") {
            tesseract.engineMode = .tesseractCubeCombined
            tesseract.pageSegmentationMode = .auto
            tesseract.image = image.g8_blackAndWhite()
            tesseract.recognize()
            textView.text = tesseract.recognizedText
            var fullText = tesseract.recognizedText.lowercased()
            print(fullText.contains("total"))
            let types: NSTextCheckingResult.CheckingType = [.date ]
            let detector = try? NSDataDetector(types: types.rawValue)
            let result = detector?.firstMatch(in: fullText, range: NSMakeRange(0,fullText.utf16.count))
            if result?.resultType == .date {
                date = (result?.date)!
            }
        }
        guard let addBillVC = storyboard?.instantiateViewController(withIdentifier: "AddBillVC") as? AddBillVC else {return}
        addBillVC.initData(date: date, amount: 0.0)
        presentDetail(addBillVC)
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
        takePhotoBtn.setTitle("Take Photo / Upload Image", for: .normal)
    }
    
    @IBAction func takePhoto(_ sender: Any) {
        presentImagePicker()
    }
}

extension CameraVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func presentImagePicker() {
        let imagePickerActionSheet = UIAlertController(title: "Take Photo/Upload Image",
                                                       message: nil, preferredStyle: .actionSheet)
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let cameraButton = UIAlertAction(title: "Take Photo",
                                             style: .default) { (alert) -> Void in
                                                let imagePicker = UIImagePickerController()
                                                imagePicker.delegate = self
                                                imagePicker.sourceType = .camera
                                                self.present(imagePicker, animated: true)
            }
            imagePickerActionSheet.addAction(cameraButton)
        }
        // 1
        let libraryButton = UIAlertAction(title: "Choose from Camera Roll",
                                          style: .default) { (alert) -> Void in
                                            let imagePicker = UIImagePickerController()
                                            imagePicker.delegate = self
                                            imagePicker.sourceType = .photoLibrary
                                            self.present(imagePicker, animated: true)
        }
        imagePickerActionSheet.addAction(libraryButton)
        // 2
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel)
        imagePickerActionSheet.addAction(cancelButton)
        // 3
        present(imagePickerActionSheet, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : Any]) {
        if let selectedPhoto = info[UIImagePickerControllerOriginalImage] as? UIImage,
            let scaledImage = selectedPhoto.scaleImage(640) {
            activityIndicator.startAnimating()
            activityIndicator.isHidden = false
            takePhotoBtn.setTitle("", for: .normal)
            dismiss(animated: true, completion: {
                self.performImageRecognition(scaledImage)
            })
        }
    }
}

extension UIImage {
    func scaleImage(_ maxDimension: CGFloat) -> UIImage? {
        var scaledSize = CGSize(width: maxDimension, height: maxDimension)
        
        if size.width > size.height {
            let scaleFactor = size.height / size.width
            scaledSize.height = scaledSize.width * scaleFactor
        } else {
            let scaleFactor = size.width / size.height
            scaledSize.width = scaledSize.height * scaleFactor
        }
        
        UIGraphicsBeginImageContext(scaledSize)
        draw(in: CGRect(origin: .zero, size: scaledSize))
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return scaledImage
    }
}


//
//  ImageRecogViewController.swift
//  SmartCycleV2
//
//  Created by lekc on 5/21/19.
//  Copyright © 2019 lekc. All rights reserved.
//

import UIKit
import Vision
import CoreML
import ImageIO
class ImageRecogViewController: UIViewController {
    
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var classificationResults: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    lazy var classificationRequest : VNCoreMLRequest = {
        do{
            let model = try VNCoreMLModel(for: MobileNet().model)
            let request = VNCoreMLRequest(model: model, completionHandler: ({ [weak self] request, error in
                self?.processClassifications(for: request, error: error)
                } as! VNRequestCompletionHandler))
            request.imageCropAndScaleOption = .centerCrop
            return request
        }catch{
            fatalError("Model could not be loaded or found. Please try again")
        }
    }()
    
    func processClassifications(for request: VNCoreMLRequest, error: Error?){
        DispatchQueue.main.async {
            guard let results = request.results else{
                 self.classificationResults.text = "Unable to classify image.\n\(error!.localizedDescription)"
                return;
            }
            let classifications = results as! [VNClassificationObservation]
            if (classifications.isEmpty){
                self.classificationResults.text = "No Classifications Available"
            }else{
                let topClassification = classifications.prefix(2)
                let descriptions = topClassification.map { classifications in
                    return String(format: "  (%.2f) %@", classifications.confidence, classifications.identifier)
                }
                self.classificationResults.text = "Classification Results \n" + descriptions.joined(separator: "\n")
            }
        }
        
    }
    func updateClassifications(for image: UIImage){
        self.classificationResults.text = "Processing the Classification"
        DispatchQueue.global()
    }
   

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

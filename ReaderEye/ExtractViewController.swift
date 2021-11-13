//
//  ExtractViewController.swift
//  ReaderEye
//
//  Created by MacMini on 7.10.2021.
//

import UIKit
import Vision
import NaturalLanguage


protocol WordExtractale {
    func extractWords( _ words : [String])
}

class ExtractViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textView: UITextView!
    var image : UIImage?
    var extractedTexts = [String]()
    
    
    var delegate : WordExtractale?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let image = image {
            self.imageView.image = image
            
            if #available(iOS 13.0, *) {
                self.extractTextfrom(image)
            } else {
                // Fallback on earlier versions
            }
            
            
            
        }

        // Do any additional setup after loading the view.
    }
    
    
    
    @IBAction func extractFinal(_ sender: Any) {
        
        
        delegate?.extractWords(self.extractedTexts)
        self.navigationController?.popViewController(animated: true)
        
        
    }
    


    @available(iOS 13.0, *)
    fileprivate func extractTextfrom(_ image : UIImage) {
        
       
        
        guard let cgImage = image.cgImage else { return}
        
        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        
        let request = VNRecognizeTextRequest { request, error in
            guard    let observations = request.results as? [VNRecognizedTextObservation]  else { return}
            
            let wordArray = observations.compactMap { observation in
                
                
                return observation.topCandidates(1).first!.string.split(separator : " ")
            }
            
           let x = wordArray.joined()
            self.extractedTexts = x.compactMap({ "\($0)"})
            self.extractedTexts =  self.extractedTexts.filter({ self.recognizableString(string: $0)})
            DispatchQueue.main.async {
                self.textView.text = self.extractedTexts.joined(separator: "\n")
            }
        }
        
        
        do {
            try handler.perform([request])
        } catch let err {
            print(err)
        }
        
        
        
    }
    
    
    
    @available(iOS 12.0, *)
    func recognizableString(string : String) -> Bool {
        let recognizer = NLLanguageRecognizer()

        recognizer.processString(string)
        
        if let language = recognizer.dominantLanguage {
            if language == NLLanguage("en") {
                return true
            } else {
                return false
            }
        } else {
            return false
        }
        
    }
    
    

}

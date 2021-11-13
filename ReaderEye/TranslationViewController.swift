//
//  TranslationViewController.swift
//  ReaderEye
//
//  Created by MacMini on 7.10.2021.
//

import UIKit

class TranslationViewController: UIViewController {

    @IBOutlet weak var wordLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var translatedLabel: UILabel!
    
    var word : String?
    @IBOutlet weak var translatedView: CommonView!
    
    var apiResult : ApiResult?
    
    var examples : [Example] = []
    
    let activityIndicator = UIActivityIndicatorView()
    
    var savedResults = [ApiResult]()
    
    
    @IBAction func saveResult(_ sender: UIButton) {
        
        if let apiResult = apiResult {
            savedResults.append(apiResult)
            
            let encoded = try! prencoder.encode(savedResults)
            try! encoded.write(to: saveURL)
            
            
            let alert = UIAlertController(title: "Translation has been saved", message: "", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
            
            
        }
    }
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(self.apiResult)
        
        if let data = try? Data(contentsOf: saveURL) {
            self.savedResults = try! prdecoder.decode([ApiResult].self, from: data)
        }
        
        translatedView.addSubview(activityIndicator)
        if #available(iOS 13.0, *) {
            activityIndicator.backgroundColor = UIColor.systemGray6
        } else {
            // Fallback on earlier versions
        }
        activityIndicator.color = .systemOrange
        activityIndicator.startAnimating()
        activityIndicator.hidesWhenStopped = true
       
     
        
        
        if let successResult = apiResult {
            DispatchQueue.main.async {
             print(successResult)
                self.translatedLabel.text = successResult.results.first?.lexicalEntries.first?.entries.first?.senses.first?.translations?.first?.text ?? ""
                print(successResult.results.first?.lexicalEntries.first?.entries.first?.senses.first?.translations?.first?.text ?? "empty")
                self.examples = successResult.results.first?.lexicalEntries.first?.entries.first?.senses.first?.examples ?? []
                self.tableView.reloadData()
                self.activityIndicator.stopAnimating()
            }
            
            return
            
        }
        
        wordLabel.text = word ?? ""
        guard let word = word else {
            return
        }

        TranslationAPI.call(word: word) { result in
            switch result {
            case .success(let successResult) :
                DispatchQueue.main.async {
                    self.apiResult = successResult
                    self.translatedLabel.text = successResult.results.first?.lexicalEntries.first?.entries.first?.senses.first?.translations?.first?.text ?? ""
                    self.examples = successResult.results.first?.lexicalEntries.first?.entries.first?.senses.first?.examples ?? []
                    self.tableView.reloadData()
                    self.activityIndicator.stopAnimating()
                }
            case .failure(let error) :
                print(error)
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    
                    let alert = UIAlertController(title: "No Translation", message: "There is no translation found for this word.", preferredStyle: .alert)
                    let action = UIAlertAction(title: "OK", style: .default) { _ in
                        self.dismiss(animated: true, completion: nil)
                    }
                    alert.addAction(action)
                    self.present(alert, animated: true, completion: nil)
                    
                }
            }
        }
        
        

        // Do any additional setup after loading the view.
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        activityIndicator.frame  = translatedView.bounds
    }

    
    

}


extension TranslationViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        examples.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "example")!
        
        if #available(iOS 14.0, *) {
            var config = cell.defaultContentConfiguration()
            config.text = examples[indexPath.row].text
            config.secondaryText = examples[indexPath.row].translations.first?.text ?? ""
            
            cell.contentConfiguration = config
        } else {
            // Fallback on earlier versions
        }
        
       
        
        return cell
    }
    
    
    
    
    
    
}

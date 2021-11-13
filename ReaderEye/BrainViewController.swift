//
//  BrainViewController.swift
//  ReaderEye
//
//  Created by MacMini on 8.10.2021.
//

import UIKit

class BrainViewController: UIViewController , UITableViewDelegate, UITableViewDataSource {


    
    @IBOutlet weak var emptyMockView: UIView!
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var apiResult : ApiResult?
    
    var savedWords = [ApiResult]()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        if let data = try? Data(contentsOf: saveURL) {
            savedWords = try! prdecoder.decode([ApiResult].self, from: data)
            
            emptyMockView.isHidden = savedWords.count != 0
        }

        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "finalise" {
            let vc = segue.destination as! TranslationViewController
            vc.apiResult = self.apiResult
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        savedWords.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "my")!
        
        if #available(iOS 14.0, *) {
            var congi = cell.defaultContentConfiguration()
            congi.text = savedWords[indexPath.row].results.first?.id ?? ""
            congi.secondaryText = savedWords[indexPath.row].results.first?.lexicalEntries.first?.entries.first?.senses.first?.translations?.first?.text ?? ""
            
            cell.contentConfiguration = congi
        } else {
            // Fallback on earlier versions
        }
     
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        apiResult = savedWords[indexPath.row]
        
        performSegue(withIdentifier: "finalise", sender: Any.self)
    }
    

}



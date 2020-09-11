//
//  LanguageTableViewController.swift
//  Translator
//
//  Created by Alex on 8/29/20.
//  Copyright © 2020 Weekend. All rights reserved.
//

import UIKit

enum SelectedLangauge {
    case English
    case Hindi
    case French
}

class LanguageTableViewController: UITableViewController {

    // MARK: - Properties
    
    private let translateOptions = ["  English", "  French", "  Hindi"]
    private let translateImages = [UIImage(named: "usaFlag"), UIImage(named: "frenchFlag"), UIImage(named: "indiaFlag")]
    
    public var translateVC: ViewController?
    public var isTranslateFrom: Bool = true
    
    // MARK: - Outlets
    
    
    
    // MARK: - VC Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - Setup UI
    
    private func setupUI(){
        
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return translateOptions.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! LanguageTableViewCell
        
        cell.langTitleLbl.text = translateOptions[indexPath.row]
        cell.langIconImageView.image = translateImages[indexPath.row]

        return cell
    }
        
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedLang = translateOptions[indexPath.row]
        let selectedImage = translateImages[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)

//        if selectedLang.lowercased() == "english" {
//            translateVC?.selectedLanguage = .English
//        } else if selectedLang.lowercased() == "hindi" {
//            translateVC?.selectedLanguage = .Hindi
//        } else if selectedLang.lowercased() == "french" {
//            translateVC?.selectedLanguage = .French
//        }
        
        if isTranslateFrom {
            translateVC?.translateFromBtn.setTitle(selectedLang, for: .normal)
            translateVC?.translateFromBtn.setImage(selectedImage, for: .normal)
        } else {
            translateVC?.translateToBtn.setTitle(selectedLang, for: .normal)
            translateVC?.translateToBtn.setImage(selectedImage, for: .normal)
        }
        self.dismiss(animated: true, completion: nil)
    }
}

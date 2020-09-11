//
//  ViewController.swift
//  Translator
//
//  Created by Alex on 8/29/20.
//  Copyright © 2020 Weekend. All rights reserved.
//

import UIKit
import Speech

class ViewController: UIViewController, SFSpeechRecognizerDelegate {

    // MARK: - Properties
    
    private var isRecording: Bool = false
    private var translateOptionsVC: LanguageTableViewController?
    public var toLanguage: String?
    public var fromLanguage: String?

    // MARK: - Instances
    
    private let networkController = NetworkController()
    
    // MARK: - Outlets
    
    @IBOutlet weak var translateToBtn: UIButton!
    @IBOutlet weak var translateFromBtn: UIButton!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var translateBtn: UIButton!
    @IBOutlet weak var textView: UITextView!
    
    // MARK: - Actions
    
    @IBAction func translateBtnPressed(_ sender: UIButton) {
        isRecording.toggle()
        
        networkController.sendTextToTranslate(text: "This is so cool", toLanguage: toLanguage?.uppercased() ?? "ENGLISH", fromLanguage: fromLanguage?.uppercased() ?? "FRENCH")
        
        if isRecording {
            titleLbl.text = "Listening..."
            buttonPress(sender: sender, pressedColor: Colors.pressedColor, bool: isRecording)
        } else {
            titleLbl.text = "Ready to Translate"
            buttonPress(sender: sender, pressedColor: Colors.normalColor, bool: isRecording)
        }
    }
    
    @IBAction func translateFromBtnPressed(_ sender: UIButton) {
        translateOptionsVC?.isTranslateFrom = true
    }
    
    @IBAction func translateToBtnPressed(_ sender: UIButton) {
        translateOptionsVC?.isTranslateFrom = false
    }
    
    // MARK: - VC Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let translateTableView = segue.destination as? LanguageTableViewController {
            translateTableView.translateVC = self
            translateOptionsVC = translateTableView
        }
    }

    // MARK: - Setup UI
    
    private func setupUI(){
        // Translate Button
        translateBtn.backgroundColor = Colors.normalColor
        translateBtn.layer.cornerRadius = translateBtn.frame.height / 2
        translateBtn.layer.masksToBounds = true
        translateBtn.setTitle("", for: .normal)
        translateBtn.setImage(UIImage(named: "micIcon"), for: .normal)
        
        // Title Label
        titleLbl.text = "Ready to Translate"
        
        // Translate To Button
        translateToBtn.setTitle("  Hindi", for: .normal)
        translateToBtn.setImage (UIImage(named: "indiaFlag"), for: .normal)
        translateToBtn.translatesAutoresizingMaskIntoConstraints = false
        translateToBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true

        // Translate From Button
        translateFromBtn.setTitle("  English", for: .normal)
        translateFromBtn.setImage(UIImage(named: "usaFlag"), for: .normal)
        translateFromBtn.translatesAutoresizingMaskIntoConstraints = false
        translateFromBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    private func buttonPress(sender: UIButton, pressedColor: UIColor, bool: Bool){
        UIView.animate(withDuration: 0.15, animations: {
            sender.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)

            if !bool { // Switch to normal
                sender.backgroundColor = Colors.normalColor
                sender.setImage(UIImage(named: "micIcon"), for: .normal)
            } else { // Pressed
                sender.backgroundColor = pressedColor
                sender.setImage(UIImage(named: "stopIcon"), for: .normal)
            }
            
        }) { (_) in
            UIView.animate(withDuration: 0.15) {
                sender.transform = .identity
            }
        }
    }

}


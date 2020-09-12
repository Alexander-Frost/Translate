//
//  ViewController.swift
//  Translator
//
//  Created by Alex on 8/29/20.
//  Copyright © 2020 Weekend. All rights reserved.
//

import UIKit
import Speech
import AVKit

class ViewController: UIViewController, SFSpeechRecognizerDelegate {

    // MARK: - Properties
    
    private var isRecording: Bool = false
    private var translateOptionsVC: LanguageTableViewController?
    public var toLanguage: String?
    public var fromLanguage: String?

    private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    
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
                
        if isRecording {
            titleLbl.text = "Listening..."
            buttonPress(sender: sender, pressedColor: Colors.pressedColor, bool: isRecording)
            
            // Speech to text
            startRecording()
        } else {
            titleLbl.text = "Ready to Translate"
            buttonPress(sender: sender, pressedColor: Colors.normalColor, bool: isRecording)
            
            networkController.sendTextToTranslate(text: textView.text, toLanguage: toLanguage?.uppercased() ?? "ENGLISH", fromLanguage: fromLanguage?.uppercased() ?? "FRENCH")
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
        setupSpeech()
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
    
    // MARK: - Speech
    
    private func startRecording() {
        if recognitionTask != nil {
            recognitionTask?.cancel()
            recognitionTask = nil
        }

        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSession.Category.record)
            try audioSession.setMode(AVAudioSession.Mode.measurement)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            print("audioSession properties weren't set because of an error.")
        }
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        let inputNode = audioEngine.inputNode

        guard let recognitionRequest = recognitionRequest else {fatalError("Unable to create an SFSpeechAudioBufferRecognitionRequest object")}
        recognitionRequest.shouldReportPartialResults = true

        recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest, resultHandler: { (result, error) in
            var isFinal = false
            if result != nil {
                self.textView.text = result?.bestTranscription.formattedString
                isFinal = (result?.isFinal)!
            }
            if error != nil || isFinal {
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)
                self.recognitionRequest = nil
                self.recognitionTask = nil
//                self.startStopBtn.isEnabled = true
            }
        })

        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, when) in
            self.recognitionRequest?.append(buffer)
        }
        audioEngine.prepare()
        do {
            try audioEngine.start()
        } catch {
            print("audioEngine couldn't start because of an error.")
        }
        textView.text = "Say something, I'm listening!"
    }
    
    private func setupSpeech() {
        speechRecognizer?.delegate = self
        SFSpeechRecognizer.requestAuthorization { (authStatus) in
            switch authStatus {
            case .authorized:
//                isButtonEnabled = true
                print("Authorized")
            case .denied:
//                isButtonEnabled = false
                print("User denied access to speech recognition")
            case .restricted:
//                isButtonEnabled = false
                print("Speech recognition restricted on this device")
            case .notDetermined:
//                isButtonEnabled = false
                print("Speech recognition not yet authorized")
            @unknown default: break
            }
        }
    }

}


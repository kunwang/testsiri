//
//  ViewController.swift
//  TestSiriProject
//
//  Created by hao.wang on 2021/5/14.
//

import UIKit
import Intents
import IntentsUI
import AVFoundation

class ViewController: UIViewController {

    public static weak var shared: ViewController?
    
    public static let activityId = "com.abs.TestSiriProject.activityId"
    private static let musicUrl = "boom"
    
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var addShortCutButton: UIButton!
    
    private var audioPlayer: AVAudioPlayer?

    override func viewDidLoad() {
        super.viewDidLoad()
        ViewController.shared = self
        INPreferences.requestSiriAuthorization { [weak self](status) in
            guard let strong = self else {return}
            if status == .authorized {
                strong.addShortCutButton.isHidden = false
            } else {
                strong.addShortCutButton.isHidden = true
            }
        }
    }

    @IBAction func playClick(_ sender: Any) {
        play()
    }
    
    @IBAction func stopClick(_ sender: Any) {
        stop()
    }
    
    
    @IBAction func addShortCutClick(_ sender: Any) {
        let activity = createShortCut()
        let shortcut = INShortcut(userActivity: activity)
        let vc = INUIAddVoiceShortcutViewController(shortcut: shortcut)
        vc.delegate = self
        present(vc, animated: true, completion: nil)
    }
    
    func createShortCut() -> NSUserActivity {
        let activity = NSUserActivity(activityType: ViewController.activityId)
        activity.persistentIdentifier = NSUserActivityPersistentIdentifier(ViewController.activityId)
        activity.isEligibleForSearch = true
        activity.isEligibleForPrediction = true
        activity.title = "Play music"
        activity.suggestedInvocationPhrase = "ask TestProject to play music"
        return activity
    }
    
}

extension ViewController: INUIAddVoiceShortcutViewControllerDelegate {
    
  func addVoiceShortcutViewController(_ controller: INUIAddVoiceShortcutViewController,
                                      didFinishWith voiceShortcut: INVoiceShortcut?,
                                      error: Error?) {
    dismiss(animated: true, completion: nil)
  }
  
  func addVoiceShortcutViewControllerDidCancel(_ controller: INUIAddVoiceShortcutViewController) {
    dismiss(animated: true, completion: nil)
  }
}

/**
 play music methods and delegate
 */
extension ViewController: AVAudioPlayerDelegate {
    
    func play() {
        stop()
        guard let theBundleResourcePath = Bundle.main.path(forResource: ViewController.musicUrl, ofType: "mp3") else {
            return
        }
        do {
            self.audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: theBundleResourcePath))
        } catch let error as NSError {
            print("play music error, \(error.localizedDescription)")
            return
        }
        if let player = self.audioPlayer {
            player.delegate = self
            player.play()
        }
    }
    
    func stop() {
        self.audioPlayer?.pause()
        self.audioPlayer = nil
    }
    
    /**
     delegate
     */
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        if let e = error {
            print("play music error, \(e.localizedDescription)")
        }
        stop()
    }
    
    /**
     delegate
     */
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        stop()
    }
    
}


//
//  RecordSoundsViewController.swift
//  PitchPerfect
//
//  Created by Phillip Valdez on 2/16/18.
//  Copyright © 2018 Phillip Valdez. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    
    var soundImage: [UIImage] = []
    

    @IBOutlet weak var soundImageView: UIImageView!
    
    var audioRecorder: AVAudioRecorder!

    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopRecordingButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stopRecordingButton.isEnabled = false
        stopRecordingButton.isHidden = true
        soundImage = createImageArray(total: 23, imagePrefix: "sound")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    //creating an array of images for animation
    func createImageArray(total: Int, imagePrefix: String) -> [UIImage] {
        
        var imageArray: [UIImage] = []
        for imageCount in 1..<total {
            let imageName = "\(imagePrefix)-\(imageCount).tiff"
            let image = UIImage(named: imageName)!
            imageArray.append(image)
        }
        
        
        return imageArray
    }
    
    //func for array animation
    
    func animate(imageView: UIImageView, images: [UIImage]) {
    imageView.animationImages = images
    //flipping through images in 1 second
    imageView.animationDuration = 1.0
    //looping 50 times
    imageView.animationRepeatCount = 50
    imageView.startAnimating()
    }
    

    @IBAction func recordAudio(_ sender: Any) {
        recordingLabel.text = "Recording in Progress"
        stopRecordingButton.isEnabled = true
        stopRecordingButton.isHidden = false
        recordButton.isEnabled = false
        recordButton.isHidden = true
        animate(imageView: soundImageView, images: soundImage)
        
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true) [0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord, with: .defaultToSpeaker)
        
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    @IBAction func stopAudio(_ sender: Any) {
        recordButton.isHidden = false
        recordButton.isEnabled = true
        stopRecordingButton.isEnabled = false
        stopRecordingButton.isHidden = true
        recordingLabel.text = "Tap to Record"
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
        } else {
            print("recording was not successful")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecording" {
            let playSoundsVC = segue.destination as! PlaySoundsViewController
            let recordedAudioURL = sender as! URL
            playSoundsVC.recordedAudioURL = recordedAudioURL
        }
    }
}


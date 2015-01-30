//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Harry Eng on 1/19/15.
//  Copyright (c) 2015 Harry Eng. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    @IBOutlet weak var recordMessage: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var pauseButton: UIButton!
    
    var audioRecorder: AVAudioRecorder!
    
    var recordedAudio: RecordedAudio!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        stopButton.hidden = true
        pauseButton.hidden = true
        
        // Reset text instruction
        self.recordMessage.text = "Tap to Record"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // Record Button
    @IBAction func recordAudio(sender: UIButton) {        
        recordButton.enabled = false
        
        self.recordMessage.text = "recording in progress"
        
        // Only create a new recording if the recording state is NOT paused
        if (pauseButton.hidden == true) {
            let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        
            let currentDateTime = NSDate()
            let formatter = NSDateFormatter()
            formatter.dateFormat = "ddMMyyyy-HHmmss"
            let recordingName = formatter.stringFromDate(currentDateTime)+".wav"
            let pathArray = [dirPath, recordingName]
            let filePath = NSURL.fileURLWithPathComponents(pathArray)
            println(filePath)
        
            var session = AVAudioSession.sharedInstance()
            session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
        
            audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
            audioRecorder.delegate = self
            audioRecorder.meteringEnabled = true
            audioRecorder.prepareToRecord()
        
            pauseButton.hidden = false
            stopButton.hidden = false
        }
        
        pauseButton.enabled = true
        audioRecorder.record()
    }
    
    // Pause Button
    @IBAction func pauseAudio(sender: UIButton) {
        self.recordMessage.text = "Tap to Resume"
        audioRecorder.pause()
        pauseButton.enabled = false
        recordButton.enabled = true
    }
    
    // Stop Button
    @IBAction func stopRecordAudio(sender: UIButton) {
        recordButton.enabled = true
        pauseButton.hidden = true
        stopButton.hidden = true
        
        audioRecorder.stop()
        var audioSession = AVAudioSession.sharedInstance()
        audioSession.setActive(false, error: nil)
    }
    
    // Finish recording and write to the file system
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        if (flag) {
            recordedAudio = RecordedAudio(title: recorder.url.lastPathComponent!,url:  recorder.url)
        
            self.performSegueWithIdentifier("stopRecording", sender: recordedAudio)
        } else {
            println("Recording was not successful")
            recordButton.enabled = true
            pauseButton.hidden = true
            stopButton.hidden = true
        }
    }
    
    // Prepair to send the recorded file to the PlaySoundsViewController
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "stopRecording") {
            let playSoundsVC:PlaySoundsViewController = segue.destinationViewController as PlaySoundsViewController
            let data = sender as RecordedAudio
            playSoundsVC.receivedAudio = data
        }
    }
}


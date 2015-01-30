//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Harry Eng on 1/23/15.
//  Copyright (c) 2015 Harry Eng. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController, AVAudioPlayerDelegate {
    
    var audioPlayer: AVAudioPlayer!
    var echoPlayer: AVAudioPlayer!
    var audioEngine: AVAudioEngine!
    var audioFile: AVAudioFile!
    
    var receivedAudio: RecordedAudio!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Used for changing the playback pitch
        audioEngine = AVAudioEngine()
        audioFile = AVAudioFile(forReading: receivedAudio.filePathUrl, error: nil)
        
        // Used for changing the playback rate
        audioPlayer = AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl, error: nil)
        audioPlayer.enableRate = true
        
        // Used for adding an echo to the playback
        echoPlayer = AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl, error: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // Snail Button
    // Play some slow audio like Jamie Foxx
    @IBAction func playSlowAudio(sender: UIButton) {
        playAudioWithVariableRate(0.5)
    }
    
    // Hare Button
    // Play some fast audio like Twista
    @IBAction func playFastAudio(sender: UIButton) {
        playAudioWithVariableRate(1.7)
    }
    
    // Chipmunk Button
    // Play some audio like you've inhaled some helium
    @IBAction func playChipmunkAudio(sender: UIButton) {
        playAudioWithVariablePitch(1000)
    }
    
    // Vader Button
    // Play some audio like you've been sippin' on some sizzurp
    @IBAction func playVaderAudio(sender: UIButton) {
        playAudioWithVariablePitch(-1000)
    }
    
    // Bat Button
    // Play some audio like T-Pain
    @IBAction func playEchoAudio(sender: UIButton) {
        stop()
        audioPlayer.play()
        
        // Play the second recorded audio file at a delay and lower volume
        var delay:NSTimeInterval = 0.5
        var now:NSTimeInterval = audioPlayer.deviceCurrentTime
        echoPlayer.volume = 0.5
        echoPlayer.delegate = self
        echoPlayer.playAtTime(now + delay)
    }
    
    // Stop Button
    @IBAction func stopAudio(sender: UIButton) {
        stop()
    }
    
    // Plays recording based on rate variable passed in
    func playAudioWithVariableRate(rate: Float) {
        stop()
        audioPlayer.rate = rate
        audioPlayer.play()
    }
    
    // Plays recording based on pitch variable passed in
    func playAudioWithVariablePitch(pitch: Float){
        stop()
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        var changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine.attachNode(changePitchEffect)
        
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        audioPlayerNode.play()
    }
    
    // Stop and reset everything
    func stop() {
        audioPlayer.rate = 1.0
        audioPlayer.stop()
        audioPlayer.currentTime = 0
        echoPlayer.stop()
        echoPlayer.currentTime = 0
        echoPlayer.volume = 1.0
        audioEngine.stop()
        audioEngine.reset()
    }
}

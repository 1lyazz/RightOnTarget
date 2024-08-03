//  Sound.swift
//  RightOnTarget
//  Created by Ilya Zablotski

import AVFoundation
import Foundation

var audioPlayer: AVAudioPlayer?

// Method to play a music for one time
func playSound(sound: String, type: String) {
    if let path = Bundle.main.path(forResource: sound, ofType: type) {
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
            audioPlayer?.play()
        } catch {
            print("Error")
        }
    }
}

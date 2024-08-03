//  MusicPlayer.swift
//  RightOnTarget
//  Created by Ilya Zablotski

import AVFoundation
import Foundation

// Use class here to create a singleton for the music not passing to another view

final class MusicPlayer {
    static let shared = MusicPlayer()
    var audioPlayer: AVAudioPlayer?

    private init() {}

    // Function to play music in a loop creating a background music
    func startBackgroundMusic(backgroundMusicFileName: String) {
        guard let bundle = Bundle.main.path(forResource: backgroundMusicFileName, ofType: "mp3") else {
            print("Music file not found")
            return
        }

        let backgroundMusic = NSURL(fileURLWithPath: bundle)
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: backgroundMusic as URL)
            guard let audioPlayer = audioPlayer else { return }
            audioPlayer.numberOfLoops = -1
            audioPlayer.prepareToPlay()
            audioPlayer.play()
        } catch {
            print("Error loading music file: \(error.localizedDescription)")
        }
    }

    // function to stop playing music
    func stopBackgroundMusic() {
        guard let audioPlayer = audioPlayer else { return }
        audioPlayer.stop()
    }
}

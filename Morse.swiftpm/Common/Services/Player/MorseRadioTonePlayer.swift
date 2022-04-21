//
//  MorseRadioTonePlayer.swift
//  Morse
//
//  Created by Tamerlan Satualdypov on 18.04.2022.
//

import Foundation
import AudioUnit
import AVFoundation

final class MorseRadioTonePlayer: NSObject {
    private let timeUnit: CGFloat = 0.2
    
    private var auAudioUnit: AUAudioUnit!
    
    private var isAVActive = false
    private var isAudioRunning = false
    
    private var sampleRate: Double = 44100.0
    
    private var frequency = 750.0
    private var volume = 16383.0
    
    private var toneCount: Int32 = 0
    
    private var yPhase = 0.0
    
    func set(frequency: Double) {
        self.frequency = frequency
    }
    
    func set(volume: Double) {
        self.volume = volume * 32766.0
    }
    
    func set(time: Double) {
        self.toneCount = Int32(time * self.sampleRate);
    }
    
    func play(morse: String, completion: (() -> Void)? = nil) {
        guard let symbol = morse.first, self.isAVActive else {
            completion?()
            return
        }
        
        self.set(volume: 1.0)
        
        // Base Time Unit.
        var time = self.timeUnit
        
        // Short mark should be 1 time unit long;
        // Long mark should be 3 time unit long;
        // Within-character gap should be 1 time unit long.
        if symbol == "." {
            time = self.timeUnit
        } else if symbol == "-" {
            time = 3.0 * self.timeUnit 
        } else {
            time = self.timeUnit
            
            // Setting volume to zero, so
            // we won't play any sound.
            self.set(volume: 0.0)
        }
        
        self.set(time: time)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + time) {
            var symbolsToPlay = morse
            symbolsToPlay.remove(at: morse.startIndex)
            
            self.play(morse: symbolsToPlay, completion: completion)
        }
    }
    
    func stop() {
        if self.isAudioRunning {
            self.auAudioUnit.stopHardware()
            self.isAudioRunning = false
        }
        
        if self.isAVActive {
            do {
                try AVAudioSession.sharedInstance().setActive(false)
                self.isAVActive = false
            } catch { }
        }
    }
    
    func enableSpeaker() {
        guard !self.isAudioRunning else { return }
        
        if !self.isAVActive {
            do {
                let audioSession = AVAudioSession.sharedInstance()
                
                try audioSession.setCategory(.soloAmbient)
                
                var preferredIOBufferDuration = 4.0 * 0.0058
                
                if audioSession.sampleRate == 48000.0 {
                    self.sampleRate = 48000.0
                    preferredIOBufferDuration = 4.0 * 0.0053
                }
                
                try audioSession.setPreferredSampleRate(self.sampleRate)
                try audioSession.setPreferredIOBufferDuration(preferredIOBufferDuration)
                
                try audioSession.setActive(true)
                
                self.isAVActive = true
            } catch { }
        }
        
        do {
            let audioComponentDescription = AudioComponentDescription(
                componentType: kAudioUnitType_Output,
                componentSubType: kAudioUnitSubType_RemoteIO,
                componentManufacturer: kAudioUnitManufacturer_Apple,
                componentFlags: 0,
                componentFlagsMask: 0
            )
            
            if auAudioUnit == nil {
                try auAudioUnit = AUAudioUnit(componentDescription: audioComponentDescription)
                
                let firstBus = auAudioUnit.inputBusses[0]
                
                if let audioFormat = AVAudioFormat(
                    commonFormat: .pcmFormatInt16,
                    sampleRate: Double(self.sampleRate),
                    channels: AVAudioChannelCount(2),
                    interleaved: true
                ) {
                    try firstBus.setFormat(audioFormat)
                }
                
                auAudioUnit.outputProvider = { (_, _, frameCount, _, inputDataList) -> AUAudioUnitStatus in
                    self.fillSpeakerBuffer(inputDataList: inputDataList, frameCount: frameCount)
                    return 0
                }
            }
            
            self.auAudioUnit.isOutputEnabled = true
            self.toneCount = 0
            
            try self.auAudioUnit.allocateRenderResources()
            try self.auAudioUnit.startHardware()
            
            self.isAudioRunning = true
        } catch { }
    }
    
    private func fillSpeakerBuffer(inputDataList: UnsafeMutablePointer<AudioBufferList>, frameCount: UInt32) {
        let inputDataPtr = UnsafeMutableAudioBufferListPointer(inputDataList)
        
        if inputDataPtr.count > 0 {
            let mBuffers: AudioBuffer = inputDataPtr[0]
            let count = Int(frameCount)
            
            if self.volume > 0.0 && self.toneCount > 0 {
                let v = min(self.volume, 32767.0)
                let sz = Int(mBuffers.mDataByteSize)
                
                var sinPhase = self.yPhase
                let dPhase = 2.0 * Double.pi * self.frequency / self.sampleRate
                
                if var bptr = UnsafeMutableRawPointer(mBuffers.mData) {
                    for i in 0 ..< count {
                        let u  = sin(sinPhase)
                        
                        sinPhase += dPhase
                        
                        if (sinPhase > 2.0 * Double.pi) {
                            sinPhase -= 2.0 * Double.pi
                        }
                        
                        let x = Int16(v * u + 0.5)
                        
                        if i < (sz / 2) {
                            bptr.assumingMemoryBound(to: Int16.self).pointee = x
                            bptr += 2
                            bptr.assumingMemoryBound(to: Int16.self).pointee = x
                            bptr += 2
                        }
                    }
                }
                
                self.yPhase = sinPhase
                self.toneCount -= Int32(frameCount)
            } else {
                memset(mBuffers.mData, 0, Int(mBuffers.mDataByteSize))
            }
        }
    }
}

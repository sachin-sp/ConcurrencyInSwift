//
//  ManualThreadCreation.swift
//  Multithreading
//
//  Created by Sachin Pampannavar on 26/03/23.
//

import Foundation

// Custom creation of thread is a bad practice

public class CustomThread {
    public init() {}
    public func createThread() {
        let thread: Thread  = Thread(target: self, selector: #selector(threadSelector), object: nil)
        thread.start()
    }
    
    @objc func threadSelector() {
        print("Custom thread in action")
    }
}


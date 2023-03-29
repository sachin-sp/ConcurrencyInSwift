//
//  AsyncDispatchQueue.swift
//  
//
//  Created by Sachin Pampannavar on 26/03/23.
//

import Foundation

public class AsyncDispatchQueue {
    
    public init() { }
    
    public func test() {
        var counter = 1

        DispatchQueue.main.async {
            for i in 0...3 {
                counter = i
                print("\(counter)")
            }
        }

        for i in 4...6 {
            counter = i
            print("\(counter)")
        }

        DispatchQueue.main.async {
            for i in 7...10 {
                counter = i
                print("\(counter)")
            }
        }
    }
    
}

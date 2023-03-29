import Foundation

public class ActorsAsyncAwaitTest {
    
    public init() {}
    
    public func testRaceConditionWithClass() {
        
        let filght: FlightClass = FlightClass()
        
        let queue1: DispatchQueue = DispatchQueue(label: "queue1")
        let queue2: DispatchQueue = DispatchQueue(label: "queue2")
        
        queue1.async {
            let bookedSeat: String = filght.bookSeat()
            print("Booked seat is  \(bookedSeat)")
        }
        
        queue2.async {
            let availableSeats: [String] = filght.getAvailableSeats()
            print("Available seat \(availableSeats)")
        }
        
    }
    
    public func testRaceConditionWithActor() {
        
        let filght: FlightActor = FlightActor()
        
        let queue1: DispatchQueue = DispatchQueue(label: "queue1")
        let queue2: DispatchQueue = DispatchQueue(label: "queue2")
        
        queue1.async {
            Task {
                let bookedSeat: String = await filght.bookSeat()
                print("Booked seat is  \(bookedSeat)")
            }
        }
        
        queue2.async {
            Task {
                let availableSeats: [String] = await filght.getAvailableSeats()
                print("Available seat \(availableSeats)")
            }
        }
        
    }
    
}

class FlightClass {
    let company = "Vistara"
    var availabelSeats: [String] = ["1A", "1B", "1C"]
    
    let barrierQueue = DispatchQueue(label: "barrierQueue", attributes: .concurrent)
    
    let semaphore: DispatchSemaphore = DispatchSemaphore(value: 1)
    
    /*
    ///Avoiding race condition using barrier flag
    func getAvailableSeats() -> [String] {
        barrierQueue.sync(flags: .barrier) {
            return self.availabelSeats
        }
    }
    
    ///Avoiding race condition using barrier flag
    func bookSeat() -> String {
        barrierQueue.sync(flags: .barrier) {
            let bookedSeat = self.availabelSeats.first ?? ""
            self.availabelSeats.removeFirst()
            return bookedSeat
        }
    }*/
    
    ///Avoiding race condition using semaphore
    func getAvailableSeats() -> [String] {
        defer {
            semaphore.signal()
        }
        semaphore.wait()
        return self.availabelSeats
        
    }
    
    ///Avoiding race condition using semaphore
    func bookSeat() -> String {
        
        defer {
            semaphore.signal()
        }
        
        semaphore.wait()
        let bookedSeat = self.availabelSeats.first ?? ""
        self.availabelSeats.removeFirst()
        return bookedSeat
    }
}

actor FlightActor {
    let company = "Vistara"
    var availabelSeats: [String] = ["1A", "1B", "1C"]
    
    
    func getAvailableSeats() -> [String] {
        return self.availabelSeats
        
    }
    
    func bookSeat() -> String {
        let bookedSeat = self.availabelSeats.first ?? ""
        self.availabelSeats.removeFirst()
        return bookedSeat
    }
}

//
//  Result.swift
//  blah2
//
//  Created by Jay Wren on 10/30/23.
//

import Foundation
import Network

@Observable
class Result: /*Hashable,Codable,*/ Identifiable {
    init(id: Int, name: String, description: String, duration: Duration) {
        self.id = id
        self.name = name
        self.description = description
        self.duration = duration
    }
    var id:Int = 0
    var name:String = ""
    var description:String = ""
    var duration: Duration = Duration.zero
    static var Zero: Result = Result(id: 0, name: "Zero", description: "0", duration: Duration.zero)
}

class LookerUpper {
    var connection: NWConnection?
    var messageToUDP: Data
    var start: ContinuousClock.Instant = ContinuousClock().now
    var end: ContinuousClock.Instant = ContinuousClock().now
    var res: Result
    static var Default: LookerUpper = LookerUpper(res:Result.Zero)

    init(res: Result) {
        self.res = res
        let message = Message(
            type: .query,
            questions: [Question(name: "apple.com.", type: .pointer)])
        do {
            messageToUDP = try message.serialize()
        } catch {
            messageToUDP = Data()
            print("ERROR could not serialize message \(message)")
        }
    }

    func timeDNSLookup( server: String) {
        self.start = ContinuousClock().now
        let hostUDP: NWEndpoint.Host = .init(server)
        // OH NO! DNS LOOKUP IN SWIFT!!!
        connection = NWConnection(host: hostUDP, port: 53, using: .udp)
        self.connection?.stateUpdateHandler = { (newState) in
            print("This is stateUpdateHandler:")
            switch (newState) {
            case .ready:
                print("State: Ready\n")
                self.sendUDP(self.messageToUDP)
                self.receiveUDP()
            case .setup:
                print("State: Setup\n")
            case .cancelled:
                print("State: Cancelled\n")
            case .preparing:
                print("State: Preparing\n")
            default:
                print("ERROR! State not defined!\n")
            }
        }
        self.connection?.start(queue: .global())
    }

    func sendUDP(_ content: Data) {
        self.connection?.send(content: content, completion: NWConnection.SendCompletion.contentProcessed(({ (NWError) in
            if (NWError == nil) {
                print("Data was sent to UDP")
            } else {
                print("ERROR! Error when data (Type: Data) sending. NWError: \n \(NWError!)")
            }
        })))
    }
    func receiveUDP() {
        self.connection?.receiveMessage { (data, context, isComplete, error) in
            if (isComplete) {
                print("Receive is complete")
                self.end = ContinuousClock().now
                self.res.duration = self.end - self.start
                if (data != nil) {
                    do {
                        let response = try Message.init(deserialize: data!)
                        print("Received message: \(response)")
                    } catch {
                        let backToString = String(decoding: data!, as: UTF8.self)
                        print ("ERROR could not deserialize \(backToString)")
                    }
                } else {
                    print("Data == nil")
                }
            }
        }
    }
}

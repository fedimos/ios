//
//  FCConnection.swift
//  FedimosConnection
//
//  Created by Vivien BERNARD on 05/01/2019.
//  Copyright © 2018-2019 Fedimos.
//

import UIKit
import SocketIO

public class FCConnection: NSObject {
    
    public let url: URL
    
    private let socketManager: SocketManager
    
    public init(url: URL) {
        self.url = url
        self.socketManager = SocketManager(socketURL: url, config: [.log(true), .compress])
        super.init()
    }
    
}

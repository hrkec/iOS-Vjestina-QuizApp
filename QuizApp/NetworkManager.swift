//
//  NetworkManager.swift
//  QuizApp
//
//  Created by Marin on 16.05.2021..
//

import Foundation
import Reachability

public class NetworkManager {
    class func isConnectedToNetwork() -> Bool {
        let reachability = Reachability.forInternetConnection()
        return ((reachability?.isReachable()) != nil)
    }
}

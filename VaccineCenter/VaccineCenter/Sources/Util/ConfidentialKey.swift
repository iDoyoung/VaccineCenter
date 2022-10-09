//
//  ConfidentialKey.swift
//  VaccineCenter
//
//  Created by Doyoung on 2022/10/09.
//

import Foundation

enum ConfidentialKey {
    enum authServiceKey {
        static let key = "Authorization"
        static let value = getServiceKey()
    }
    
    private static func getServiceKey() -> String {
        guard let key = Bundle.main.object(forInfoDictionaryKey: "HEADER_AUTH_KEY") as? String else {
            return  ""
        }
        return key
    }
}

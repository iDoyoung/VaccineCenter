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
    
    ///서비스 키는 Config 파일을 생성해서 Git Ignore 시켰습니다. Clone할 경우, Config file 생성 혹은 인증키를 return 해야합니다.
    private static func getServiceKey() -> String {
        guard let key = Bundle.main.object(forInfoDictionaryKey: "HEADER_AUTH_KEY") as? String else {
            return  ""//TODO: 인증키 등록
        }
        return key
    }
}

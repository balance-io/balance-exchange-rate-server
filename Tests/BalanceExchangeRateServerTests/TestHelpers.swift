//
//  TestHelpers.swift
//  BalanceOpenTests
//
//  Created by Raimon Lapuente on 07/08/2017.
//  Copyright © 2017 Balanced Software, Inc. All rights reserved.
//

import Foundation
import XCTest

class TestHelpers {
    
    public static var emptyData: Data {
        let jsonData = "".data(using: .utf8)!
        return jsonData
    }
    
    public static var wrongData: Data {
        let jsonData = "asdfad $%&/(= %&/%( ^G ^SF P=ÄSDFÑVL:;CX_Z¨ÑLKª!sdfasd f4ni3567pytñrew´-.,lñá-.,AKSDCLKXMZ,".data(using: .utf8)!
        return jsonData
    }
}

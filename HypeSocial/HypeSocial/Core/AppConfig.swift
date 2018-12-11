//
//  AppConfig.swift
//  HypeSocial
//
//  Created by Douglas Mendes on 2018-12-04.
//  Copyright © 2018 Douglas Mendes. All rights reserved.
//

struct Application {
    static let clientID = "16c34857-fd53-447b-846a-fee84c368aaa"
    static let graphURI = "https://graph.microsoft.com/v1.0/me/"
    static let scopes: [String] = ["https://graph.microsoft.com/user.read", "https://graph.microsoft.com/contacts.read"]
    static let authority = "https://login.microsoftonline.com/common"
}

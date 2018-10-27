//
//  ViewController.swift
//  HypeSocial
//
//  Created by Douglas Mendes on 2018-10-27.
//  Copyright © 2018 Douglas Mendes. All rights reserved.
//

import UIKit
import RxSwift
import RxMoya
import Moya
import MSAL

final class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        do {
            let application = try MSALPublicClientApplication(clientId: "000000004024AA84")

            application.acquireToken(forScopes: []) { (result, error) in

                guard let authResult = result, error == nil else {
                    print(error!.localizedDescription)
                    return
                }

                // Get access token from result
                let accessToken = authResult.accessToken

                // You'll want to get the account identifier to retrieve and reuse the account for later acquireToken calls
                let accountIdentifier = authResult.account.homeAccountId?.identifier
            }

        } catch {
            print(error)
        }
        
    }
}


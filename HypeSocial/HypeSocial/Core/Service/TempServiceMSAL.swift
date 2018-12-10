//
// Created by Douglas Mendes on 2018-12-04.
// Copyright (c) 2018 Douglas Mendes. All rights reserved.
//

import MSAL

protocol TempServiceMSALDelegate: class {
    func onSignIn()
    func onSignOut()
    func onError()
}

final class TempServiceMSAL {
    private var accessToken: String = ""
    private var idToken: String = ""
    private var applicationContext : MSALPublicClientApplication?

    weak var delegate: TempServiceMSALDelegate? = nil

    var isLoggedIn: Bool {
        return !accessToken.isEmpty
    }

    func start() {
        do {
            guard let authorityURL = URL(string: Application.authority) else {
                updateLogging(text: "Unable to create authority URL")
                return
            }

            let authority = try MSALAuthority(url: authorityURL)
            applicationContext = try MSALPublicClientApplication(clientId: Application.clientID, authority: authority)

        } catch let error {
            updateLogging(text: "Unable to create Application Context \(error)")
        }
    }

    func acquireTokenInteractively() {
        guard let applicationContext = applicationContext else {
            updateLogging(text: "Applciation context not exists")
            return
        }

        applicationContext.acquireToken(forScopes: Application.scopes) { [weak self] (result, error) in
            guard let strongSelf = self else { return }

            if let error = error {
                print(error as NSError)
                strongSelf.updateLogging(text: "Could not acquire token: \(error)")
                strongSelf.delegate?.onError()
                return
            }

            guard let result = result else {
                strongSelf.updateLogging(text: "Could not acquire token: No result returned")
                strongSelf.delegate?.onError()
                return
            }

            strongSelf.accessToken = result.accessToken
            strongSelf.updateLogging(text: "Access token is \(strongSelf.accessToken)")
            strongSelf.getContentWithToken()
        }
    }

    func acquireTokenSilently() {
        guard let applicationContext = applicationContext else { return }
        guard let currentAccount = currentAccount() else { return }
        applicationContext.acquireTokenSilent(forScopes: Application.scopes, account: currentAccount) { [weak self] (result, error) in
            guard let strongSelf = self else { return }

            if let error = error {
                let nsError = error as NSError
                if (nsError.domain == MSALErrorDomain
                        && nsError.code == MSALErrorCode.interactionRequired.rawValue) {

                    DispatchQueue.main.async {
                        strongSelf.acquireTokenInteractively()
                    }
                } else {
                    DispatchQueue.main.async {
                        strongSelf.delegate?.onError()
                        strongSelf.updateLogging(text: "Could not acquire token silently: \(error)")
                    }
                }

                return
            }

            guard let result = result else {
                DispatchQueue.main.async {
                    strongSelf.updateLogging(text: "Could not acquire token: No result returned")
                    strongSelf.delegate?.onError()
                }
                return
            }

            DispatchQueue.main.async {
                strongSelf.idToken = result.idToken!
                strongSelf.accessToken = result.accessToken
                strongSelf.updateLogging(text: "Refreshed Access token is \(strongSelf.accessToken)")
                strongSelf.getContentWithToken()
                strongSelf.updateLogging(text: "\n\n \(strongSelf.idToken)")
            }
        }
    }

    func currentAccount() -> MSALAccount? {
        guard let applicationContext = self.applicationContext else { return nil }

        do {
            let cachedAccounts = try applicationContext.allAccounts()

            if !cachedAccounts.isEmpty {
                return cachedAccounts.first
            }

        } catch let error as NSError {
            updateLogging(text: "Didn't find any accounts in cache: \(error)")
        }

        return nil
    }

    func getContentWithToken() {
        let url = URL(string: Application.graphURI)
        print("Bearer \(self.accessToken)")
        var request = URLRequest(url: url!)

        request.setValue("Bearer \(self.accessToken)", forHTTPHeaderField: "Authorization")
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            guard let strongSelf = self else { return }

            if let error = error {
                strongSelf.updateLogging(text: "Couldn't get graph result: \(error)")
                return
            }

            guard let result = try? JSONSerialization.jsonObject(with: data!, options: []) else {

                strongSelf.updateLogging(text: "Couldn't deserialize result JSON")
                return
            }

            strongSelf.updateLogging(text: "Result from Graph: \(result))")
            strongSelf.delegate?.onSignIn()
        }.resume()
    }

    func updateLogging(text: String) {
        print("\(text)\n")
    }

    func signout() {
        UserDefaults.standard.removeObject(forKey: "MSALCurrentAccountIdentifier")

        guard let applicationContext = self.applicationContext else { return }
        guard let account = self.currentAccount() else { return }

        do {
            try applicationContext.remove(account)
        } catch {
            self.updateLogging(text: "Received error signing account out: \(error)")
        }
    }

}
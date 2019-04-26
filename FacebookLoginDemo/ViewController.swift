//
//  ViewController.swift
//  FacebookLoginDemo
//
//  Created by Martin Løseth Jensen on 23/04/2019.
//  Copyright © 2019 Martin Løseth Jensen. All rights reserved.
//

import UIKit
import FacebookCore
import FacebookLogin

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }


    @IBAction func facebookLoginPressed(_ sender: Any) {
        let manager = LoginManager()
        manager.logIn(readPermissions: [.publicProfile, .email], viewController: self, completion: ({ (result) in
            switch result {
            case .cancelled:
                print("User cancelled the login request")
                break
            case let .success(_, _, token): // all parameters is a let variable
                print("Login was successful with user: \(String(describing: token.userId.debugDescription))")
                // call facebook api to get user email and profile photo
                self.showUserInfo(token: token)
                break
            case .failed(let error):
                print("Login failed because of an error \(error.localizedDescription)")
            }
        }))
    }

    func showUserInfo(token: AccessToken) {
        // 1. build a query
        let connection = GraphRequestConnection()
        let request = GraphRequest(graphPath: "/me", parameters: ["fields": "id, email, picture.type(large)"], accessToken: token, httpMethod: .GET, apiVersion: .defaultVersion)
        connection.add(request) { response, result in
            switch result {
            case .success(response: let response):
                print("response: \(response)")
                if let email = response.dictionaryValue!["email"] {
                    print("email: \(email)")
                }
                break
            case .failed(let error):
                print("error: \(error.localizedDescription)")
                break
            }
        }

        // 2. execute the query
        connection.start()

    }

}


//
//  GPPAuthenticator.swift
//  Roomguru
//
//  Created by Patryk Kaczmarek on 13/04/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import Foundation
import Async

class GPPAuthenticator: NSObject {
    
    typealias AuthenticatorCompletionBlock = (authenticated: Bool, auth: GTMOAuth2Authentication? ,error: NSError?) -> Void
        
    static var isUserAuthenticated: Bool {
        return GPPSignIn.sharedInstance().authentication != nil
    }
    
    private var completion: AuthenticatorCompletionBlock!
    private(set) var isAuthenticating = false
    
    override init() {
        super.init()
        
        let sharedSignIn = GPPSignIn.sharedInstance();
        sharedSignIn.clientID = AppConfiguration.GooglePlus.ClientID
        sharedSignIn.scopes = AppConfiguration.GooglePlus.Scope
        sharedSignIn.shouldFetchGoogleUserID = true
        sharedSignIn.shouldFetchGoogleUserEmail = true
        sharedSignIn.shouldFetchGooglePlusUser = true
        sharedSignIn.delegate = self
    }
    
    func authenticateWithCompletion(completion: AuthenticatorCompletionBlock) {
        
        isAuthenticating = true
        
        self.completion = completion
        
        if GPPSignIn.sharedInstance().hasAuthInKeychain() {
            
            if !GPPSignIn.sharedInstance().trySilentAuthentication() {
                self.completion(authenticated: false, auth: nil, error: nil)
            }
            
        } else {
            Async.main(after: 0.2) {
                self.completion(authenticated: false, auth: nil, error: nil)
            }
        }
    }
    
    func handleURL(url: NSURL, sourceApplication: String?, annotation: AnyObject?) -> Bool {
        return GPPURLHandler.handleURL(url, sourceApplication: sourceApplication, annotation: annotation)
    }
    
    func signOut() {
        GPPSignIn.sharedInstance().signOut()
    }
}

 // MARK: GPPSignInDelegate Methods

extension GPPAuthenticator: GPPSignInDelegate {
    
    func finishedWithAuth(auth: GTMOAuth2Authentication!, error: NSError!) {
        isAuthenticating = false
        if (error != nil) {
            completion(authenticated: false, auth: nil, error: error)
        } else {
            completion(authenticated: true, auth: auth, error: nil)
        }
    }
    
    func didDisconnectWithError(error: NSError!) {
        isAuthenticating = false
        completion(authenticated: false, auth: nil, error: error)
    }
}

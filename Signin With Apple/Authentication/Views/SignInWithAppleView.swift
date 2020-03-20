//
//  SignInWithAppleView.swift
//  Signin With Apple
//
//  Created by Stewart Lynch on 2020-03-18.
//  Copyright © 2020 CreaTECH Solutions. All rights reserved.
//

import SwiftUI
import AuthenticationServices

struct SignInWithAppleView: UIViewRepresentable {
    
    @EnvironmentObject var userInfo: UserInfo
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
    func makeUIView(context: Context) -> ASAuthorizationAppleIDButton {
        let button = ASAuthorizationAppleIDButton(authorizationButtonType: .continue, authorizationButtonStyle: .whiteOutline)
        button.addTarget(context.coordinator, action:  #selector(Coordinator.didTapButton), for: .touchUpInside)
        return button
    }
    
    func updateUIView(_ uiView: ASAuthorizationAppleIDButton, context: Context) {
    }
    
    class Coordinator: NSObject, ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
        
        let parent: SignInWithAppleView?
        // Unhashed nonce.
        var currentNonce: String?
        
        init(_ parent: SignInWithAppleView) {
            self.parent = parent
            super.init()
        }
        
       @objc func didTapButton() {
            let provider = ASAuthorizationAppleIDProvider()
        let nonce = FBAuth.randomNonceString()
        currentNonce = nonce
        let request = provider.createRequest()
        // request full name and email from the user's Apple ID
        request.requestedScopes = [.fullName, .email]
        // pass the request to the initializer of the controller
        let authController = ASAuthorizationController(authorizationRequests: [request])
        
        // similar to delegate, this will ask the VC
        // which window to present the ASAuthorizationController
        authController.presentationContextProvider = self
        
        // delegate functions will be called when the user data
        // is successfully retrieved or error occured
        authController.delegate = self
        
        // show the sign-in with Apple dialog
        authController.performRequests()
        
        }
        
        
        func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
            let vc = UIApplication.shared.windows.last?.rootViewController
            return (vc?.view.window!)!
        }
        
        func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
            
            guard let _ = parent else {
                fatalError("No parent found")
            }
            
            if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
                guard let nonce = currentNonce else {
                    fatalError("Invalid state: A login callback was received, but no login request was sent.")
                }
                guard let appleIDToken = appleIDCredential.identityToken else {
                    print("Unable to fetch identity token")
                    return
                }
                guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                    print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                    return
                }
                
                FBAuth.signInWithApple(idTokenString: idTokenString, nonce: nonce) { (result) in
                    // result is Result<AuthDataResult, Error>
                    switch result {
                    case .success(let authDataResult):
                        // User has successfully connected with apple so let's now deal with the response
                        let signInWithAppleResult = (authDataResult, appleIDCredential)
                        FBAuth.handle(signInWithAppleResult) { (result) in
                            switch result {
                            case .success(let profile):
                                print("Successfully Signed in with Apple into Firebase: \(profile)")

                            case .failure(let err):
                                print(err.localizedDescription)

                            }
                        }
                    case .failure(let err):
                        print(err.localizedDescription)

                    }
                }
                
            } else {

            }
        }
        
        func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
            guard let _ = parent else {
                fatalError("No parent found")
            }
            print("parent found")
        }    }
}


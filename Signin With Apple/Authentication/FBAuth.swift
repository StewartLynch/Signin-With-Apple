//
//  FBAuth.swift
//  Signin With Apple
//
//  Created by Stewart Lynch on 2020-03-18.
//  Copyright © 2020 CreaTECH Solutions. All rights reserved.
//

import SwiftUI
import FirebaseAuth
import CryptoKit
import AuthenticationServices

typealias SignInWithAppleResult = (authDataResult: AuthDataResult, appleIDCredential: ASAuthorizationAppleIDCredential)

struct FBAuth {
    static func authenticate(withEmail email :String,
                      password:String,
                      completionHandler:@escaping (Result<Bool, AuthError>) -> ()) {
        Auth.auth().signIn(withEmail: email, password: password) { (authResult, error) in
            var newError:NSError
            if let err = error {
                
                newError = err as NSError
                var authError:AuthError?
                switch newError.code {
                case 17009:
                    authError = .incorrectPassword
                case 17008:
                    authError = .invalideEmail
                case 17011:
                    authError = .accoundDoesNotExist
                default:
                    authError = .unknownError
                }
                completionHandler(.failure(authError!))
            } else {
                completionHandler(.success(true))
            }
        }
    }
    
    struct providerID {
           static let apple = "apple.com"
       }
       
       static func logout(completion: @escaping (Result<Bool, Error>) -> ()) {
           let auth = Auth.auth()
           do {
               try auth.signOut()
               completion(.success(true))
           } catch let err {
               completion(.failure(err))
           }
       }
       
       static func signIn(providerID: String, idTokenString: String, nonce: String, completion: @escaping (Result<AuthDataResult, Error>) -> ()) {
           // Initialize a Firebase credential.
           let credential = OAuthProvider.credential(withProviderID: providerID,
                                                     idToken: idTokenString,
                                                     rawNonce: nonce)
           // Sign in with Firebase.
           Auth.auth().signIn(with: credential) { (authDataResult, err) in
               if let err = err {
                   // Error. If error.code == .MissingOrInvalidNonce, make sure
                   // you're sending the SHA256-hashed nonce as a hex string with
                   // your request to Apple.
                   print(err.localizedDescription)
                   completion(.failure(err))
                   return
               }
               // User is signed in to Firebase with Apple.
               guard let authDataResult = authDataResult else {
                   completion(.failure(SignInWithAppleAuthError.noAuthDataResult))
                   return
               }
               completion(.success(authDataResult))
           }
       }
       
       static func handle(_ signInWithAppleResult: SignInWithAppleResult, completion: @escaping (Result<Bool, Error>) -> ()) {
           let uid = signInWithAppleResult.authDataResult.user.uid
           
           var name = ""
           let fullName = signInWithAppleResult.appleIDCredential.fullName
           let givenName = fullName?.givenName ?? ""
           let middleName = fullName?.middleName ?? ""
           let familyName = fullName?.familyName ?? ""
           let names = [givenName, middleName, familyName]
           let filteredNames = names.filter {$0 != ""}
           for i in 0..<filteredNames.count {
               name += filteredNames[i]
               if i != filteredNames.count - 1 {
                   name += " "
               }
           }
           
           let email = signInWithAppleResult.authDataResult.user.email ?? ""
           
           var data: [String: Any]
           
           if name != "" {
               data = [
                   FBKeys.User.uid: uid,
                   FBKeys.User.name: name,
                   FBKeys.User.email: email
               ]
           } else {
               data = [
                   FBKeys.User.uid: uid,
                   FBKeys.User.email: email
               ]
           }
           
           FBFirestore.mergeProfile(data, uid: uid) { (result) in
               completion(result)
           }
       }
       
       // Adapted from https://auth0.com/docs/api-auth/tutorials/nonce#generate-a-cryptographically-random-nonce
       static func randomNonceString(length: Int = 32) -> String {
           precondition(length > 0)
           let charset: Array<Character> =
               Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
           var result = ""
           var remainingLength = length
           
           while remainingLength > 0 {
               let randoms: [UInt8] = (0 ..< 16).map { _ in
                   var random: UInt8 = 0
                   let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                   if errorCode != errSecSuccess {
                       fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
                   }
                   return random
               }
               
               randoms.forEach { random in
                   if length == 0 {
                       return
                   }
                   
                   if random < charset.count {
                       result.append(charset[Int(random)])
                       remainingLength -= 1
                   }
               }
           }
           
           return result
       }
       
       @available(iOS 13, *)
       static func sha256(_ input: String) -> String {
           let inputData = Data(input.utf8)
           let hashedData = SHA256.hash(data: inputData)
           let hashString = hashedData.compactMap {
               return String(format: "%02x", $0)
           }.joined()

           return hashString
       }
    
    static func createUser(withEmail email:String,
                           fullName: String,
                           password:String,
                    completionHandler:@escaping (Result<Bool,Error>) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
            if let err = error {
                print("error 1")
                completionHandler(.failure(error!))
                return
            }
            guard let _ = authResult?.user else {
                print("Error 2")
                completionHandler(.failure(error!))
                return
            }
            
            var data: [String: Any]
            
            if fullName != "" {
                data = [
                    FBKeys.User.uid: authResult!.user.uid,
                    FBKeys.User.name: fullName,
                    FBKeys.User.email: authResult!.user.email!
                ]
            } else {
                data = [
                    FBKeys.User.uid: authResult!.user.uid,
                    FBKeys.User.email: email
                ]
            }

            FBFirestore.mergeProfile(data, uid: authResult!.user.uid) { (result) in
                completionHandler(result)
            }
            completionHandler(.success(true))
        }
    }
    
    static func resetPassword(email:String, resetCompletion:@escaping (String,String) -> Void) {
            Auth.auth().sendPasswordReset(withEmail: email, completion: { (error) in
                    if let error = error {
                        resetCompletion("Reset Failed", error.localizedDescription)
                    } else {
                        resetCompletion("","Success. Reset email sent successfully, Check your email")
                    }
                }
            )}
}

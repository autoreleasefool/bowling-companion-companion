//
//  UIViewController+Extensions.swift
//  BowlingCompanionCompanion
//
//  Created by Joseph Roque on 2018-11-02.
//  Copyright © 2018 Joseph Roque. All rights reserved.
//

import UIKit

extension UIViewController: URLSessionDelegate {
	public func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
		completionHandler(.useCredential, URLCredential(trust: challenge.protectionSpace.serverTrust!))
	}
}

// UserIdentity.swift
//
// Copyright (c) 2016 Auth0 (http://auth0.com)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import Foundation

/**
 Auth0 user identity
 */
@objc(A0UserIdentity)
public class UserIdentity: NSObject, JSONObjectPayload {

    public let identifier: String
    public let provider: String
    public let connection: String

    public let social: Bool
    public let profileData: [String: AnyObject]

    public let accessToken: String?
    public let expiresIn: NSDate?
    public let accessTokenSecret: String?

    override public var debugDescription: String {
        return "<identity: \(identifier) provider: \(provider) connection: \(connection)>"
    }

    public required init(identifier: String, provider: String, connection: String, social: Bool, profileData: [String: AnyObject], accessToken: String?, expiresIn: NSDate?, accessTokenSecret: String?) {
        self.identifier = identifier
        self.provider = provider
        self.connection = connection
        self.social = social
        self.profileData = profileData
        self.accessToken = accessToken
        self.expiresIn = expiresIn
        self.accessTokenSecret = accessTokenSecret
    }

    convenience public required init?(json: [String : AnyObject]) {

        guard
            let identifier = json["user_id"] as? String,
            let provider = json["provider"] as? String,
            let connection = json["connection"] as? String
            else { return nil }

        let social = json["isSocial"] as? Bool ?? false
        let profileData = json["profileData"] as? [String: AnyObject] ?? [:]

        let accessToken = json["access_token"] as? String
        let accessTokenSecret = json["access_token_secret"] as? String
        let expiresIn: NSDate?
        if let expiresInSeconds = json["expires_in"] as? NSTimeInterval {
            expiresIn = NSDate(timeIntervalSince1970: expiresInSeconds)
        } else {
            expiresIn = nil
        }
        self.init(identifier: identifier, provider: provider, connection: connection, social: social, profileData: profileData, accessToken: accessToken, expiresIn: expiresIn, accessTokenSecret: accessTokenSecret)
    }
}

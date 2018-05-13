//
//  Search.swift
//  UCLKit
//
//  Created by Tiago Ferreira on 24/11/2017.
//  Copyright © 2017 Tiago Ferreira. All rights reserved.
//

import Foundation
import RequestKit

// Mark: Model

/// Wrapper for the People response
@objc public final class PeopleResponse: NSObject, Codable {
    open var OK: Bool?
    open var error: String?
    open var people: [Person]?

    enum CodingKeys: String, CodingKey {
        case OK = "ok"
        case error
        case people
    }
}

/// Payload from the People response
@objc public final class Person: NSObject, Codable {
    open var name: String?
    open var status: Status?
    open var department: String?
    open var email: String?

    enum CodingKeys: String, CodingKey {
        case name
        case status
        case department
        case email
    }
}

/// Status enum to clarify options.
public enum Status: String, Codable {
    case Student = "Student"
    case Staff = "Staff"
    case Unknown = ""
}

// Mark: Requests

public extension UCLKit {
    /**
     Fetches matching people and information about them.
     - parameter query: Name of the person you are searching for.
     - parameter completion: Callback for the outcome of the fetch.
     */
    public func people(_ session: RequestKitURLSession = URLSession.shared, query: String, completion: @escaping (_ response: Response<PeopleResponse>) -> Void) -> URLSessionDataTaskProtocol? {
        let router = SearchRouter.searchPeople(configuration, query)
        return router.load(session, expectedResultType: PeopleResponse.self) { people, error in
            if let error = error {
                completion(Response.failure(error))
            }

            if let people = people {
                completion(Response.success(people))
            }
        }
    }
}

// MARK: Router

/**
 Main Search Router, contains:
 - GET People router
 */
enum SearchRouter: Router {
    case searchPeople(Configuration, String)

    var configuration: Configuration {
        switch self {
        case .searchPeople(let config, _): return config
        }
    }

    var method: HTTPMethod {
        return .GET
    }

    var encoding: HTTPEncoding {
        return .url
    }

    var params: [String: Any] {
        switch self {
        case .searchPeople(_, let query):
            return ["query": query]
        }
    }

    var path: String {
        switch self {
        case .searchPeople:
            return "search/people"
        }
    }
}

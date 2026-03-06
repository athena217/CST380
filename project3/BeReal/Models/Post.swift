//
//  Post.swift
//  BeReal
//

import Foundation
import ParseSwift

// https://github.com/parse-community/Parse-Swift/blob/3d4bb13acd7496a49b259e541928ad493219d363/ParseSwift.playground/Pages/1%20-%20Your%20first%20Object.xcplaygroundpage/Contents.swift#L33

struct Post: ParseObject {
    var objectId: String?
    var createdAt: Date?
    var updatedAt: Date?
    var ACL: ParseACL?
    var originalData: Data?
    
    var caption: String?
    var user: User?
    var imageFile: ParseFile?
    var location: ParseGeoPoint?
    var locationName: String?
    var comments: [Comment]?
}

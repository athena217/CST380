//
//  Comment.swift
//  BeReal
//


import ParseSwift
import Foundation

struct Comment: ParseObject {
    var objectId: String?
    var createdAt: Date?
    var updatedAt: Date?
    var ACL: ParseACL?
    var originalData: Data?
    
    var text: String?
    var user: User?
    var post: Pointer<Post>?
}


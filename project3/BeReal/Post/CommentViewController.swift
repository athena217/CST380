//
//  CommentViewController.swift
//  BeReal
//
//  Created by Athena Lopez on 2/26/26.
//

import Foundation
import UIKit
import SwiftUI
import ParseSwift


class CommentViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var postComment: UIButton!
    @IBOutlet weak var makeComment: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    var post: Post!
    var comments: [Comment] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Comments"
        
        view.backgroundColor = .black
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .black
        tableView.separatorColor = .darkGray
        
        makeComment.backgroundColor = UIColor.darkGray
        makeComment.textColor = .white
        makeComment.layer.cornerRadius = 8
        makeComment.attributedPlaceholder = NSAttributedString(
            string: "Add a comment...",
            attributes: [.foregroundColor: UIColor.lightGray]
        )
        
        postComment.setTitleColor(.systemBlue, for: .normal)
        
        navigationController?.navigationBar.barTintColor = .black
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        fetchComments()
    }
    
    func fetchComments() {
        guard let postId = post.objectId else { return }
        
        let query = Comment.query()
            .where("post" == Pointer<Post>(objectId: postId))
            .include("user")
            .order([.ascending("createdAt")])
        
        query.find { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let comments):
                    self?.comments = comments
                    self?.tableView.reloadData()
                case .failure(let error):
                    print("Error fetching comments: \(error)")
                }
            }
        }
    }
    
    @IBAction func postCommentTapped(_ sender: UIButton) {
        guard let text = makeComment.text, !text.isEmpty else { return }
        guard let postId = post.objectId else { return }
        
        var comment = Comment()
        comment.text = text
        comment.user = User.current
        comment.post = Pointer<Post>(objectId: postId)
        
        comment.save { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let savedComment):
                    self?.comments.append(savedComment)
                    self?.tableView.reloadData()
                    self?.makeComment.text = ""
                case .failure(let error):
                    print("Error saving comment: \(error)")
                }
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath)
        let comment = comments[indexPath.row]
        
        cell.textLabel?.text = comment.user?.username ?? "Unknown"
        cell.detailTextLabel?.text = comment.text
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 14)
        cell.backgroundColor = .black
        cell.textLabel?.textColor = .white
        cell.detailTextLabel?.textColor = .lightGray
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}


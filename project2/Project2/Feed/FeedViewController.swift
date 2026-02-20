//
//  FeedViewController.swift
//  Project 2 - BeReal Clone //


import UIKit

// TODO: Import Parse Swift
import ParseSwift


class FeedViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private var posts = [Post]() {
        didSet {
            // Reload table view data any time the posts variable gets updated.
            tableView.reloadData()
        }
    }
    
    private var isLoadingMore = false
    private var limit = 10
    
    private let refreshControl = UIRefreshControl()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsSelection = false
        
        if #available(iOS 10.0, *){
            tableView.refreshControl = refreshControl
        } else {
            tableView.addSubview(refreshControl)
        }
        refreshControl.tintColor = .white
        refreshControl.addTarget(self, action: #selector(refreshFeed(_:)), for: .valueChanged)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if posts.isEmpty {
            queryPosts()
        }
    }
    
    @objc private func refreshFeed(_ sender:Any) {
        isLoadingMore = false
        posts.removeAll()
        queryPosts()
    }
    
    private func queryPosts() {
        // TODO: Pt 1 - Query Posts
        // https://github.com/parse-community/Parse-Swift/blob/3d4bb13acd7496a49b259e541928ad493219d363/ParseSwift.playground/Pages/2%20-%20Finding%20Objects.xcplaygroundpage/Contents.swift#L66
        
        // 1. Create a query to fetch Posts
        // 2. Any properties that are Parse objects are stored by reference in Parse DB and as such need to explicitly use `include_:)` to be included in query results.
        // 3. Sort the posts by descending order based on the created at date
        
        let query = Post.query()
            .include("user")
            .order([.descending("createdAt")])
            .limit(limit)
            .skip(posts.count)
        
        // Fetch objects (posts) defined in query (async)
        query.find { [weak self] result in
            switch result {
            case .success(let newPosts):
                if self?.isLoadingMore == true {
                    self?.posts.append(contentsOf: newPosts)
                } else {
                    self?.posts = newPosts
                }
                self?.refreshControl.endRefreshing()
                self?.isLoadingMore = false
                
            case .failure(let error):
                self?.showAlert(description: error.localizedDescription)
                self?.refreshControl.endRefreshing()
                self?.isLoadingMore = false
            }
        }
    }
    
    @IBAction func onLogOutTapped(_ sender: Any) {
        showConfirmLogoutAlert()
    }
    
    private func showConfirmLogoutAlert() {
        let alertController = UIAlertController(title: "Log out of your account?", message: nil, preferredStyle: .alert)
        let logOutAction = UIAlertAction(title: "Log out", style: .destructive) { _ in
            NotificationCenter.default.post(name: Notification.Name("logout"), object: nil)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alertController.addAction(logOutAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
    }
    
    private func showAlert(description: String? = nil) {
        let alertController = UIAlertController(title: "Oops...", message: "\(description ?? "Please try again...")", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(action)
        present(alertController, animated: true)
    }
}

extension FeedViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as? PostCell else {
            return UITableViewCell()
        }
        
        cell.configure(with: posts[indexPath.row])
        return cell
    }
}

extension FeedViewController: UITableViewDelegate {
    func scrollViewController(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height
        
        if offsetY > contentHeight - height * 1.5 && !isLoadingMore {
            isLoadingMore = true
            queryPosts()
        }
    }
}

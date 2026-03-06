//
//  FeedViewController.swift
//  BeReal
//

import UIKit
import ParseSwift

class FeedViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    private let refreshControl = UIRefreshControl()

    private var posts = [Post]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    private var isLoadingMore = false
    private var limit = 10

    
    private func showLoadingFooter() {
        let spinner = UIActivityIndicatorView(style: .medium)
        spinner.startAnimating()
        spinner.frame = CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 44)
        tableView.tableFooterView = spinner
    }
    
    private func hideLoadingFooter() {
        tableView.tableFooterView = nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsSelection = true

        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(onPullToRefresh), for: .valueChanged)
        
        refreshControl.tintColor = .white
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if posts.isEmpty {
            queryPosts()
        }
    }

    private func queryPosts(completion: (() -> Void)? = nil) {
        // https://github.com/parse-community/Parse-Swift/blob/3d4bb13acd7496a49b259e541928ad493219d363/ParseSwift.playground/Pages/2%20-%20Finding%20Objects.xcplaygroundpage/Contents.swift#L66
        
        let yesterdayDate = Calendar.current.date(byAdding: .day, value: (-1), to: Date())!
        
        let query = Post.query()
            .include("user")
            .order([.descending("createdAt")])
            .where("createdAt" >= yesterdayDate)
            .limit(limit)
            .skip(posts.count)
        
        if isLoadingMore && !refreshControl.isRefreshing {
            showLoadingFooter()
        }
        
        // Find and return posts that meet query criteria (async)
        query.find { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let newPosts):
                if self.isLoadingMore {
                    self.posts.append(contentsOf: newPosts)
                } else {
                    self.posts = newPosts
                }
                
            case .failure(let error):
                self.showAlert(description: error.localizedDescription)
            }
            
            self.refreshControl.endRefreshing()
            self.hideLoadingFooter()
            self.isLoadingMore = false
            
            completion?()
        }
    }

    @IBAction func onLogOutTapped(_ sender: Any) {
        showConfirmLogoutAlert()
        NotificationManager.shared.cancelReminders()
        
        User.logout { [weak self] result in
            switch result {
            case .success:
                print("Logged out")
                DispatchQueue.main.async {
                    self?.navigationController?.popToRootViewController(animated: true)
                }
            case .failure(let error):
                print("Logout error: \(error.localizedDescription)")
            }
        }
    }

    @objc private func onPullToRefresh() {
        isLoadingMore = false
        posts.removeAll()
        queryPosts()
        
        refreshControl.beginRefreshing()
        queryPosts { [weak self] in
            self?.refreshControl.endRefreshing()
        }
    }

    private func showConfirmLogoutAlert() {
        let alertController = UIAlertController(title: "Log out of \(User.current?.username ?? "current account")?", message: nil, preferredStyle: .alert)
        let logOutAction = UIAlertAction(title: "Log out", style: .destructive) { _ in
            NotificationCenter.default.post(name: Notification.Name("logout"), object: nil)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alertController.addAction(logOutAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CommentSegue",
           let commentVC = segue.destination as? CommentViewController,
           let indexPath = tableView.indexPathForSelectedRow {
            let selectedPost = posts[indexPath.row]
            commentVC.post = selectedPost
        }
    }
}

extension FeedViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        posts.count
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
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height
        
        if offsetY > contentHeight - height * 1.5 && !isLoadingMore {
            isLoadingMore = true
            queryPosts()
        }
    }
}

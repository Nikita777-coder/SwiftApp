import UIKit
import Foundation

final class NewsListViewController: UIViewController {
    
    private var tableView = UITableView(frame: .zero, style: .plain)
    private var isLoading = false
    private var newsViewModels = [NewsViewModel]()
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fetchNews()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        configureTableView()
    }
    
    private func configureTableView() {
        setTableViewUI()
        setTableViewDelegate()
        setTableViewCell()
    }
    
    private func setTableViewDelegate() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func setTableViewUI() {
        view.addSubview(tableView)
        tableView.backgroundColor = .clear
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableView.rowHeight = 120
        tableView.pinLeft(to: view)
        tableView.pinTop(to: view.safeAreaLayoutGuide.topAnchor)
        tableView.pinRight(to: view)
        tableView.pinBottom(to: view)
    }
    
    private func setTableViewCell() {
        tableView.register(NewsCell.self, forCellReuseIdentifier: NewsCell.reuseIdentifier)
    }
    
    @objc
    private func goBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func fetchNews() {
        title = "News"
        ApiService.shared.getTopStories() { [weak self] result in
            switch result {
            case .success(let articles):
                self?.newsViewModels = articles.compactMap({
                    NewsViewModel (
                        title: $0.title,
                        subtitle: $0.description ?? "No description",
                        imageURL: URL(string: $0.urlToImage ?? "")
                    )
                })
            
            DispatchQueue.main.async {
                self?.isLoading = false
                self?.tableView.reloadData()
            }
            case .failure(let error):
                print(error)
            
            }
            
        }
    }
}



extension NewsListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isLoading {
            return 0
        } else {
            return newsViewModels.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if isLoading {
            

         } else {
             let viewModel = newsViewModels[indexPath.row]
             if let newsCell = tableView.dequeueReusableCell(withIdentifier:
                                                                NewsCell.reuseIdentifier, for: indexPath) as? NewsCell {
                 newsCell.configure(viewModel)
                 return newsCell
             }
         }
         return UITableViewCell()
         
    }
}
    
extension NewsListViewController: UITableViewDelegate {
    internal func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !isLoading {
            let newsVC = NewsViewController()
            newsVC.configure(with: newsViewModels[indexPath.row])
            navigationController?.pushViewController(newsVC, animated: true)
        }
    }
}


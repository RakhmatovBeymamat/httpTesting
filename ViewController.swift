//
//  ViewController.swift
//  EYAZIIS(1)
//
//  Created by Rakhmatov Beymamat on 25.11.23.
//

import UIKit
import Alamofire

class ViewController: UIViewController, UIPopoverPresentationControllerDelegate {
    
    private var files: [String] = []
    private var filteredFiles: [String] = []
    private var myTableView: UITableView!
    private let search = UISearchController(searchResultsController: nil)
    private var searchBarIsEpmty: Bool {
        guard let text = search.searchBar.text else {return false}
        return text.isEmpty
    }
    private var isFiltering: Bool {
        return search.isActive && !searchBarIsEpmty
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchData()
        editViewController()
        addTableView()
        addSearchBar()
        addRefreshBtn()
        aboutBtn()
        
    }
    
    @objc func refresh() {
        files = []
        filteredFiles = []
        fetchData()
        myTableView.reloadData()
    }
    
    @objc func about() {
        let vc = AboutViewController()
        vc.modalPresentationStyle = .popover
        vc.preferredContentSize = .init(width: 500, height: 500)  // the size of popover
        vc.popoverPresentationController?.sourceView = self.view    // the view of the popover
        vc.popoverPresentationController?.sourceRect = CGRect(    // the place to display the popover
            origin: CGPoint(
                x: self.view.bounds.midX,
                y: self.view.bounds.midY
            ),
            size: .zero
        )
        vc.popoverPresentationController?.permittedArrowDirections = [] // the direction of the arrow
        vc.popoverPresentationController?.delegate = self               // delegate
        navigationController?.present(vc, animated: true)
    }

    func fetchData()  {
        let apiManager = ApiManager()
        apiManager.getDataFromDataBase { [weak self] files in
            for file in files {
                self?.files.append(file)
            }
            DispatchQueue.main.async {
                self?.myTableView.reloadData()
            }
        }
    }
    
    func addTableView() {
        let displayWidth: CGFloat = self.view.frame.width
        let displayHeight: CGFloat = self.view.frame.height
        myTableView = UITableView(frame: CGRect(x: 0, y: 0, width: displayWidth, height: displayHeight))
        myTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        myTableView.dataSource = self
        myTableView.delegate = self
        self.view.addSubview(myTableView)
    }
    
    func addSearchBar() {
        search.searchBar.placeholder = "Поиск файла"
        search.searchResultsUpdater = self
        search.obscuresBackgroundDuringPresentation = false
        self.navigationItem.searchController = search
        search.definesPresentationContext = true
    }
    
    func editViewController() {
        view.backgroundColor = .systemBackground
        self.title = "Файлы"
    }
    
    func addRefreshBtn() {
        let refreshBtn = UIBarButtonItem(image: UIImage(systemName: "arrow.clockwise"),
                                         style: .done,
                                         target: self,
                                         action: #selector(refresh))
        self.navigationItem.rightBarButtonItem = refreshBtn
        
    }
    
    func aboutBtn() {
        let aboutButton = UIBarButtonItem(image: UIImage(systemName: "questionmark.circle"),
                                         style: .done,
                                         target: self,
                                         action: #selector(about))
        self.navigationItem.leftBarButtonItem = aboutButton
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return filteredFiles.count
        }
        return files.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath as IndexPath)
                
        if isFiltering {
            cell.textLabel?.text = filteredFiles[indexPath.row]
        } else {
            cell.textLabel?.text = files[indexPath.row]
        }
        
        return cell
    }
    
    
}

extension ViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
    
    func filterContentForSearchText(_ searchText: String) {
        filteredFiles = files.filter {$0.lowercased().contains(searchText.lowercased())}
        myTableView.reloadData()
    }
    
}

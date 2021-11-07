//
//  ViewController.swift
//  CollectionView
//
//  Created by Lee on 11/1/21.
//

import UIKit

class ViewController: UIViewController {
    // MARK: - Sections and Categories
    private enum Section: Int, CaseIterable {
        case trendingMovies
        case trendingTV
        case upcomingMovies
    }
    
    private enum MediaType: String, CaseIterable {
        case movie = "movie"
        case tv = "tv"
    }
    
    private enum Category: String, CaseIterable {
        case trending = "trending"
        case upcoming = "upcoming"
    }
    
    // MARK: - Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - Properties
    var trendingMovies: [String] = ["1","2","3","4","5","1","2","3","4","5","1","2","3","4","5","1","2","3","4","5",]
    var trendingMoviePage: Int = 1
    
    var trendingTV: [String] = ["1","2","3","4","5","1","2","3","4","5","1","2","3","4","5","1","2","3","4","5",]
    var trendingTVPage: Int = 1
    
    var upcomingMovies: [String] = ["1","2","3","4","5","1","2","3","4","5","1","2","3","4","5","1","2","3","4","5",]
    var upcomingMoviesPage: Int = 1
    
    var totalPages = 1000
    private var isFetchingMore = false
    
    private var refresher: UIRefreshControl = UIRefreshControl()
    private var dispatchGroup = DispatchGroup()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupRefresher()
        dispatchGroup.notify(queue: .main) {
            self.setupCollectionView()
            self.collectionView.reloadData()
        }
    }
    
    // MARK: - Methods(
    private func setupCollectionView() {
        collectionView.collectionViewLayout = makeLayout()
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = UIColor.systemFill
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.prefetchDataSource = self
        collectionView.isPrefetchingEnabled = true
        collectionView.register(MediaCollectionViewCell.self, forCellWithReuseIdentifier: "trendingMovieCell")
        collectionView.register(MediaCollectionViewCell.self, forCellWithReuseIdentifier: "trendingTVCell")
        collectionView.register(MediaCollectionViewCell.self, forCellWithReuseIdentifier: "upcomingCell")
        collectionView.register(SectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
    }
    
    private func setupRefresher() {
        refresher.attributedTitle = NSAttributedString(string: "Pull to refresh...")
        refresher.addTarget(self, action: #selector(loadData), for: .valueChanged)
        collectionView.addSubview(refresher)
    }//end func
    
    @objc private func loadData() {
        self.trendingMoviePage = 1
        self.trendingTVPage = 1
        dispatchGroup.notify(queue: .main) {
            self.collectionView.reloadSections([0,1])
            self.refresher.endRefreshing()
        }
    }//end func
    
    private func makeLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { (section, env) -> NSCollectionLayoutSection? in
            return LayoutBuilder.buildMediaHorizontalScrollLayout()
        }
    }//end func
}//end class

// MARK: - Extensions
extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDataSourcePrefetching {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return Section.allCases.count
    }//end func
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case Section.trendingMovies.rawValue:
            return trendingMovies.count
        case Section.trendingTV.rawValue:
            return trendingTV.count
        default:
            return 0
        }
    }//end func
    
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        
    }//end func
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case Section.trendingMovies.rawValue:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "trendingMovieCell", for: indexPath) as? MediaCollectionViewCell
            else {return UICollectionViewCell()}
            cell.setup(media: trendingMovies[indexPath.row], indexPath: indexPath)
            return cell
        case Section.trendingTV.rawValue:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "trendingTVCell", for: indexPath) as? MediaCollectionViewCell
            else {return UICollectionViewCell()}
            cell.setup(media: trendingTV[indexPath.row], indexPath: indexPath)
            return cell
        default:
            return UICollectionViewCell()
        }
    }//end func
}//end extension


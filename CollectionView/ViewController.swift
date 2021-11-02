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
        //        fetchTrendingMedia()
        //        fetchUpcomingMedia()
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
        //        fetchTrendingMedia()
        //        fetchUpcomingMedia()
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
    
    //    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
    //        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath) as? SectionHeader else {return UICollectionReusableView()}
    //        
    //        switch indexPath.section {
    //        case Section.trendingMovies.rawValue:
    //            header.setup(label: "#TrendingMovies")
    //        case Section.trendingTV.rawValue:
    //            header.setup(label: "#TrendingShows")
    ////        case Section.upcomingMovies.rawValue:
    ////            header.setup(label: "Upcoming Movies")
    //        default:
    //            break
    //        }
    //        
    //        return header
    //    }//end func
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case Section.trendingMovies.rawValue:
            return trendingMovies.count
        case Section.trendingTV.rawValue:
            return trendingTV.count
        //        case Section.upcomingMovies.rawValue:
        //            return upcomingMovies.count
        default:
            return 0
        }
    }//end func
    
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        //        for indexPath in indexPaths {
        //            switch indexPath.section {
        //            case Section.trendingMovies.rawValue:
        //                print(trendingMovies.count)
        
        // ImageService().fetchImage(.poster(trendingTV[indexPath.row].posterPath ?? "")) {(_) in}
        //            case Section.upcomingMovies.rawValue:
        //            //    ImageService().fetchImage(.poster(upcomingMovies[indexPath.row].posterPath ?? "")) {(_) in}
        //            default:
        //                break
        //            }
        // }
    }//end func
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch indexPath.section {
        case Section.trendingMovies.rawValue:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "trendingMovieCell", for: indexPath) as? MediaCollectionViewCell
            else {return UICollectionViewCell()}
            //            if indexPath.row > trendingMovies.count - 6 && !isFetchingMore && trendingMoviePage < totalPages {
            //                self.isFetchingMore = true
            //                self.fetchMore(category: Category.trending.rawValue, mediaType: MediaType.movie.rawValue, page: trendingMoviePage + 1)
            //            }
            cell.setup(media: trendingMovies[indexPath.row], indexPath: indexPath)
            return cell
            
        case Section.trendingTV.rawValue:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "trendingTVCell", for: indexPath) as? MediaCollectionViewCell
            else {return UICollectionViewCell()}
            //            if indexPath.row > trendingTV.count - 6 && !isFetchingMore && trendingTVPage < totalPages {
            //                self.isFetchingMore = true
            //                self.fetchMore(category: Category.trending.rawValue, mediaType: MediaType.tv.rawValue, page: trendingTVPage + 1)
            //            }
            cell.setup(media: trendingTV[indexPath.row], indexPath: indexPath)
            return cell
            
        //        case Section.upcomingMovies.rawValue:
        //            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "upcomingCell", for: indexPath) as? MediaCollectionViewCell
        //            else {return UICollectionViewCell()}
        //            cell.setup(media: upcomingMovies[indexPath.row], indexPath: indexPath)
        //            return cell
        
        default:
            return UICollectionViewCell()
        }
    }//end func
    
    //    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    //        switch indexPath.section {
    //        case Section.trendingMovies.rawValue:
    //           // presentDetailVC(media: trendingMovies[indexPath.row])
    //
    //        case Section.trendingTV.rawValue:
    //          //  presentDetailVC(media: trendingTV[indexPath.row])
    //
    //        case Section.upcomingMovies.rawValue:
    //          //  presentDetailVC(media: upcomingMovies[indexPath.row])
    //
    //        default:
    //            break
    //        }
    //    }
}//end extension


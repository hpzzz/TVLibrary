//
//  TrendingViewController.swift
//  TVLibrary
//
//  Created by Karol Harasim on 22/03/2020.
//  Copyright © 2020 Karol Harasim. All rights reserved.
//

import UIKit
import Foundation

class HomeViewController: UIViewController {
    
    enum SectionKind: Int, CaseIterable {
        case groupPaging, continuousGroupLeadingBoundary
        func orthogonalScrollingBehavior() -> UICollectionLayoutSectionOrthogonalScrollingBehavior {
            switch self {
            case .groupPaging:
                return UICollectionLayoutSectionOrthogonalScrollingBehavior.groupPaging
            case .continuousGroupLeadingBoundary:
                return UICollectionLayoutSectionOrthogonalScrollingBehavior.continuousGroupLeadingBoundary
            }
        }
    }
    
    enum SectionLayoutKind: Int, CaseIterable {
        case trending
        case popular
        func columnCount(for width: CGFloat) -> Int {
            let wideMode = width > 800
            switch self {
            case .trending:
                return wideMode ? 2 : 1
            case .popular:
                return wideMode ? 4 : 2
            }
        }
    }
    
    enum HomeSection: String, CaseIterable {
        case Trending = "Trending"
        case PopularToday = "Popular today"
        case PopularThisWeek = "Popular this week"
    }
    
    
    var dataSource: UICollectionViewDiffableDataSource<SectionLayoutKind, TVShowPreview>? = nil
    var collectionView: UICollectionView! = nil
    
    var networkManager: NetworkManager!
    
    var trending: TrendingResult!
    var popular: PopularResult!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        downloadDetails()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let _ = "73622f65fd4eb79f37924c199636fe02"
    }
    
    
    func downloadDetails(){
        print("HAAAAALO")
        let dispatchGroup = DispatchGroup()
        networkManager = NetworkManager()
        
        dispatchGroup.enter()   // <<---
        networkManager.getPopularTVShows(page: 1) { popular, error in
            if error != nil {
                print("Error")
            } else {
//                self.popular.results = popular?.results ?? []
                if let popular = popular {
                    self.popular = popular
                }
                DispatchQueue.main.async {
                    dispatchGroup.leave()   // <<----
                }
            }
        }
        
        dispatchGroup.enter()   // <<---
        networkManager.getTrendingTVShows(page: 1, period: .day) { trending, error in
            if error != nil {
                print("Error")
            } else {
                if let trending = trending {
                    self.trending = trending
                }
                print(self.trending.results.count)
                DispatchQueue.main.async {
                    dispatchGroup.leave()   // <<----
                }
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            self.configureHierarchy()
            self.configureDataSource()
            self.view.setNeedsLayout()
            self.reloadData()
            
        }
    }
}

extension HomeViewController {
    func createLayout() -> UICollectionViewLayout {
        
        let layout = UICollectionViewCompositionalLayout { index, layoutEnvironment in
            switch index {
            case 0:
                return self.createTrendingSection()
            default:
                return self.createPopularSection()
            }
        }
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 20
        layout.configuration = config
        return layout
    }
    
}

extension HomeViewController {
    func configureHierarchy() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        //        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        
        collectionView.register(SectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader , withReuseIdentifier: SectionHeader.reuseIdentifier)
        collectionView.register(TrendingCell.self, forCellWithReuseIdentifier: TrendingCell.reuseIdentifier)
        collectionView.register(PopularCell.self, forCellWithReuseIdentifier: PopularCell.reuseIdentifier)
        collectionView.backgroundColor = .systemBackground
        view.addSubview(collectionView)
        collectionView.delegate = self
    }
    
    
    
    func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<SectionLayoutKind, TVShowPreview>(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath,
             tvShow: TVShowPreview) -> UICollectionViewCell? in
            let section = SectionLayoutKind(rawValue: indexPath.section)!
            switch section {
            case .trending:
                return self.configure(TrendingCell.self, with: tvShow, for: indexPath)
            case .popular:
                return self.configure(PopularCell.self, with: tvShow, for: indexPath)
            }
        }
        
        dataSource?.supplementaryViewProvider = { collectionView, kind, indexPath in
            guard let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionHeader.reuseIdentifier, for: indexPath) as? SectionHeader else {
                return UICollectionReusableView()
            }
            sectionHeader.titleLabel.text = HomeSection.allCases[indexPath.section].rawValue
            return sectionHeader
        }
    }
    
    func configure<T: SelfConfiguringCell>(_ cellType: T.Type, with TVShow: TVShowPreview, for indexPath: IndexPath) -> T {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellType.reuseIdentifier, for: indexPath) as? T else {
            fatalError("Unable to dequeue \(cellType)")
        }
        cell.configure(with: TVShow)
        return cell
    }
    
    func reloadData() {
        var snapshot = NSDiffableDataSourceSnapshot<SectionLayoutKind, TVShowPreview>()
        snapshot.appendSections([SectionLayoutKind.trending, .popular])
        snapshot.appendItems(trending.results, toSection: .trending)
        snapshot.appendItems(popular.results, toSection: .popular)
        dataSource?.apply(snapshot)
    }
    
    func createTrendingSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        
        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        layoutItem.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)
        
        let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(0.5))
        let layoutGroup = NSCollectionLayoutGroup.horizontal(layoutSize: layoutGroupSize, subitems: [layoutItem])
        
        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
        layoutSection.orthogonalScrollingBehavior = .groupPagingCentered
        layoutSection.boundarySupplementaryItems = [createSectionHeader()]
        
        return layoutSection
    }
    
    func createPopularSection() -> NSCollectionLayoutSection {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1))
        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        layoutItem.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)
        let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.93), heightDimension:  .fractionalHeight(0.5))
        let layoutGroup = NSCollectionLayoutGroup.horizontal(layoutSize: layoutGroupSize, subitems: [layoutItem])
        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
        layoutSection.orthogonalScrollingBehavior = .groupPagingCentered
        layoutSection.boundarySupplementaryItems = [createSectionHeader()]
        
        return layoutSection
    }
    
    func createSectionHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
        let layoutSectionHeaderSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(40))
        let layoutSectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: layoutSectionHeaderSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        return layoutSectionHeader
    }
}

extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let loadVC = DetailsViewController()
        loadVC.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(loadVC, animated: true)
    }
}


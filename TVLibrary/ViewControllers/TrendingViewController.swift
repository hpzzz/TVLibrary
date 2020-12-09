//
//  TrendingViewController.swift
//  TVLibrary
//
//  Created by Karol Harasim on 22/03/2020.
//  Copyright © 2020 Karol Harasim. All rights reserved.
//

import UIKit
import Foundation

class TrendingViewController: UIViewController {
    

    
    
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
    
    
    var dataSource: UICollectionViewDiffableDataSource<SectionLayoutKind, TVShow>? = nil
    var collectionView: UICollectionView! = nil
    var trending = TrendingController()
    var popular = PopularController()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let _ = "73622f65fd4eb79f37924c199636fe02"
        downloadDetails(trending: trending, popular: popular)
            }
    
    
    
    
    func downloadDetails(trending: TrendingController, popular: PopularController){
        let dispatchGroup = DispatchGroup()

        dispatchGroup.enter()   // <<---
        trending.getTrending(for: .day) { success in
            if !success {
                print("Bad shit")
            } else {
                DispatchQueue.main.async {
                    dispatchGroup.leave()   // <<----
                }
            }
        }

        dispatchGroup.enter()   // <<---
        popular.getPopular() { succes in
            if !succes {
                print("Bad shit")
            } else {
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

extension TrendingViewController {
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

extension TrendingViewController {
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
        dataSource = UICollectionViewDiffableDataSource<SectionLayoutKind, TVShow>(collectionView: collectionView) {
                (collectionView: UICollectionView, indexPath: IndexPath,
            tvShow: TVShow) -> UICollectionViewCell? in
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
    
    func configure<T: SelfConfiguringCell>(_ cellType: T.Type, with TVShow: TVShow, for indexPath: IndexPath) -> T {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellType.reuseIdentifier, for: indexPath) as? T else {
            fatalError("Unable to dequeue \(cellType)")
        }
        cell.configure(with: TVShow)
        return cell
    }
    
    func reloadData() {
        var snapshot = NSDiffableDataSourceSnapshot<SectionLayoutKind, TVShow>()
        snapshot.appendSections([SectionLayoutKind.trending, .popular])
        snapshot.appendItems(trending.trendingTVShows, toSection: .trending)
        snapshot.appendItems(popular.popularTVShows, toSection: .popular)
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
    
extension TrendingViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let loadVC = DetailsViewController()
        loadVC.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(loadVC, animated: true)

//        self.present(loadVC, animated: true)
        
    }
}
    

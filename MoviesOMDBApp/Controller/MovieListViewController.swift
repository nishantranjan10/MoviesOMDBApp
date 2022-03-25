//
//  MovieListViewController.swift
//  MoviesOMDBApp
//
//  Created by NISHANT RANJAN on 25/3/22.
//

import Foundation
import UIKit

class MovieListViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    var collectionViewFlowLayout: UICollectionViewFlowLayout!
    
    var movieListViewModel = MovieListViewModel(moviesServices: MoviesServices())
    var searchArray : [Search]?
    var searchBarMovieArray = [Search]()
    var searching = false
    
    var page: Int = 1
    var isPageRefreshing:Bool = false
   
    var movieName : String?
    var searchedMovieName : String?
    let imageCache = NSCache<AnyObject, AnyObject>()
    
    override func viewDidLoad() {
           super.viewDidLoad()
        title = K.movieList
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
           super.viewWillAppear(animated)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        setUpCollectionViewItemSize()
    }
    
    // To Call the MovieListApi
    func initBindingWithViewModel(movieName : String, pageNumber : String,searchedMovieName : Bool) {
        
        movieListViewModel.getMovieSearchListData(movieName: movieName, pageNumber: pageNumber, objectType: ToDo.self) { (result: Result) in
            switch result {
            case .success(let object):
               
               if searchedMovieName == true {
                self.searchArray = nil
                self.searchArray = object.Search
               }
               else {
                if let objectArray =  object.Search {
                  self.searchArray?.append(contentsOf: objectArray)
                }
               }
               DispatchQueue.main.async {
                self.collectionView.reloadData()
               }
                                   
               case .failure(let error):
                print(error)
                self.searchArray = nil
              self.collectionView.reloadData()
               }
        }
    }
    
    // To Set the collectionview Layout
    private func setUpCollectionViewItemSize() {
        
        if collectionViewFlowLayout == nil {
            let numberOfItemPerRow: CGFloat = 2
            let lineSpacing : CGFloat = 5
            let innerLineSpacing : CGFloat = 5
            
            let width = (collectionView.frame.width - (numberOfItemPerRow - 1) * innerLineSpacing)/numberOfItemPerRow
            let height = width
            
            collectionViewFlowLayout = UICollectionViewFlowLayout()
            collectionViewFlowLayout.itemSize = CGSize(width: width, height: height)
            collectionViewFlowLayout.sectionInset = UIEdgeInsets.zero
            collectionViewFlowLayout.scrollDirection = .vertical
            collectionViewFlowLayout.minimumLineSpacing = lineSpacing
            collectionViewFlowLayout.minimumInteritemSpacing = innerLineSpacing
            collectionView.setCollectionViewLayout(collectionViewFlowLayout, animated: true)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
         if segue.identifier == K.moveToDetailScreenSegue {
          if let vc = segue.destination as? MovieDetailsViewController {
            if let selectedIndexPaths = self.collectionView.indexPathsForSelectedItems,  let selectedIndexPath = selectedIndexPaths.first {
                vc.imdbID = self.searchArray?[selectedIndexPath.row].imdbID
            }
         }
        }
    }
    
}

extension MovieListViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searchArray?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: MovieListCollectionViewCell.className, for: indexPath) as? MovieListCollectionViewCell
        else {
            preconditionFailure(K.CellErrorMessage)
        }

        cell.titleLabel.text = self.searchArray?[indexPath.row].Title
        cell.imageView.image = nil

         if let urlString = self.searchArray?[indexPath.row].Poster, let url = URL(string: urlString), let data = try? Data(contentsOf: url), let image = UIImage(data: data), let imageFromCache = imageCache.object(forKey: image) as? UIImage {
            cell.imageView.image = imageFromCache
        }
         else {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {

                if let urlString = self.searchArray?[indexPath.row].Poster, let url = URL(string: urlString), let data = try? Data(contentsOf: url) {
                        let imageToCache = UIImage(data: data)

                    if let urlString = self.searchArray?[indexPath.row].Poster, let url = URL(string: urlString), let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                        self.imageCache.setObject(imageToCache!, forKey: image)
                    }

                    cell.imageView.image = UIImage(data: data)
                    cell.setNeedsLayout()
                }
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: K.moveToDetailScreenSegue, sender: self)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

    let noOfCellsInRow = 2

    let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout

    let totalSpace = flowLayout.sectionInset.left
        + flowLayout.sectionInset.right
        + (flowLayout.minimumInteritemSpacing * CGFloat(noOfCellsInRow - 1))

    let size = Int((collectionView.bounds.width - totalSpace) / CGFloat(noOfCellsInRow))

    return CGSize(width: size, height: size)
    }
}

extension MovieListViewController : UISearchBarDelegate {
   
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        //self.searchBarMovieArray = searchArray.t.filter({$0.prefix(searchText.count) == searchText})
                 if searchText.count > 0 {
            movieName = searchText
            page = 1
            initBindingWithViewModel(movieName: searchText, pageNumber: "1", searchedMovieName: true)
        }
         else {
            searchArray = [Search]()
            self.collectionView.reloadData()
        }
    }
    
   public func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool  {
        return true
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searching = false
        searchBar.text = ""
        searchArray = [Search]()
        self.collectionView.reloadData()
    }
    
    // To call on collectionView Scroll
    func scrollViewDidScroll(_ scrollView: UIScrollView) {

        if(self.collectionView.contentOffset.y >= (self.collectionView.contentSize.height - self.collectionView.bounds.size.height)) {
            if !isPageRefreshing {
                page = page + 1
                callMovieApi(page1: page)
            }
        }
    }
    
    // call MovieApi with page Number
    func callMovieApi(page1: Int) {
        let mypage = String(page1)
        if let movieName = movieName {
            initBindingWithViewModel(movieName: movieName, pageNumber: mypage, searchedMovieName: false)
        }
    }
}

//
//  MovieDetailsViewController.swift
//  MoviesOMDBApp
//
//  Created by NISHANT RANJAN on 26/3/22.
//

import Foundation
import UIKit

class MovieDetailsViewController: UIViewController {
    
    @IBOutlet var headerView: UIView!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    
    var movieDetailsViewModel = MovieDetailsViewModel(moviesServices: MoviesServices())
    var movieDetails : MovieDetails?
    
    var imdbID : String? {
           didSet{
               initBindingWithViewModel()
           }
       }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        title = K.movieDetails
        self.tableView.tableHeaderView = headerView
    }

    
    func initBindingWithViewModel() {
           movieDetailsViewModel.getMovieDetailsData(imdbID: imdbID!, objectType: MovieDetails.self) { (result: Result) in
               switch result {
               case .success(let object):
                  self.movieDetails = object
                  DispatchQueue.main.async {
                      self.initMovieImage()
                    self.tableView.reloadData()
                  }
                  case .failure(let error):
                   print(error)
                  }
           }
       }
    
    
    func initMovieImage() {
           
           if let urlString = self.movieDetails?.Poster, let url = URL(string:urlString) {
               
               DispatchQueue.global().async {
                if  let data = try? Data(contentsOf: url) {
                    DispatchQueue.main.async {
                       self.imageView.image = UIImage(data: data)
                    }
                }
            }
            DispatchQueue.main.async {
                self.titleLabel.text = self.movieDetails?.Title
                self.yearLabel.text = self.movieDetails?.Year
            }
           }
       }
    
    func minutesToHoursMinutes (minutes : String) -> (hours : Int , leftMinutes : Int) {
        let min = minutes.components(separatedBy: K.minut)
        
        if min.count > 1 {
            if let minut = Int(min[0].trimmingCharacters(in: .whitespaces)) {
            return (minut / 60, (minut % 60))
        }
        }
       return (0,0)
    }
}


extension MovieDetailsViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CategoryAndSynopsisTableViewCell.className, for: indexPath) as? CategoryAndSynopsisTableViewCell else {
                preconditionFailure(K.CellErrorMessage)
                   }
             if let movieDetails = movieDetails {
                let timeDuratin = minutesToHoursMinutes(minutes: movieDetails.Runtime ?? "")
                if timeDuratin.hours != 0 {
                cell.categoryDetails.text = "\(timeDuratin.hours) h \(timeDuratin.leftMinutes) min"
                }
                else {
                cell.categoryDetails.text = movieDetails.Runtime
                }
                cell.sypnopisDetails.text = movieDetails.Plot
                cell.scoreDetails.text = movieDetails.Metascore
                cell.reviewDetails.text = movieDetails.imdbRating
                cell.popularityDetails.text = movieDetails.imdbVotes
             }
                   
            return cell
        }
        else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: DirectorWriterAutherTableViewCell.className, for: indexPath) as? DirectorWriterAutherTableViewCell
                else {
                    preconditionFailure(K.CellErrorMessage)
                }
            
            if let movieDetails = movieDetails {
                cell.directorDetails.text = movieDetails.Director
                cell.writerDetails.text = movieDetails.Writer
                cell.actorDetails.text = movieDetails.Actors
            }
            return cell
        }
    }
}

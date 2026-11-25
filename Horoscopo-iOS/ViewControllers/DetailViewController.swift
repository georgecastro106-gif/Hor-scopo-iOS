//
//  DetailViewController.swift
//  Horoscopo-iOS
//
//  Created by Turno Mananas on 24/11/2026.
//

import UIKit

class DetailViewController: UIViewController {
    
    var horoscope: Horoscope!
    var isFavorite = false
    
    @IBOutlet weak var favoriteMenuItem: UIBarButtonItem!
    
    @IBOutlet weak var signImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationItem.title = horoscope.name
        navigationItem.subtitle = horoscope.dates
        signImageView.image = horoscope.sign
        
        isFavorite = SessionManager().isFavorite(id: horoscope.id)
        setFavoriteIcon()
    }
    
    func setFavoriteIcon() {
        if isFavorite {
            favoriteMenuItem.image = UIImage(systemName: "heart.fill")
        } else {
            favoriteMenuItem.image = UIImage(systemName: "heart")
        }
    }
    @IBAction func favoriteMenuClicked(_ sender: Any) {
        let session = SessionManager()
        if (isFavorite) {
            session.setFavorite(id: "")
        } else {
            session.setFavorite(id: horoscope.id)
        }
        isFavorite = !isFavorite
        setFavoriteIcon()
    }
    
    @IBAction func shareMenuClicked(_ sender: Any) {
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

//
//  DetailViewController.swift
//  Horoscopo-iOS
//
//  Created by Turno Mananas on 24/11/2026.
//

import UIKit
import Foundation
import OSLog

class DetailViewController: UIViewController {
    
    var horoscope: Horoscope!
    var isFavorite = false
    
    
    @IBOutlet weak var horoscopoLabel: UILabel!
    
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
        
        getHoroscopePrediction()
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
        
        // text to share
              let text = "This is some text that I want to share."
              
              // set up activity view controller
              let textToShare = [ text ]
              let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
              activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
              
              // exclude some activity types from the list (optional)
              activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook ]
              
              // present the view controller
              self.present(activityViewController, animated: true, completion: nil)
              
          }
    
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "App", category: "API REST")

    struct HoroscopeResponse: Decodable {
        struct HoroscopeData: Decodable {
            let horoscope: String
        }
        let data: HoroscopeData
    }

    func getHoroscopePrediction(period: String = "daily") {
        horoscopoLabel.text = "Consultando con las estrellas..."

        
        Task { @MainActor in
            guard var components = URLComponents(string: "https://freehoroscopeapi.com/api/v1/get-horoscope/\(period)") else {
                logger.error("URL inválida para el periodo: \(period, privacy: .public)")
                return
            }
            components.queryItems = [
                URLQueryItem(name: "sign", value: horoscope.id)
            ]

            guard let url = components.url else {
                logger.error("No se pudo construir la URL final")
                return
            }

            var request = URLRequest(url: url)
            request.httpMethod = "GET"

            do {
                let (data, response) = try await URLSession.shared.data(for: request)

                guard let httpResponse = response as? HTTPURLResponse else {
                    logger.error("Respuesta HTTP inválida")
                    return
                }

                if httpResponse.statusCode == 200 {
                    if let rawJSON = String(data: data, encoding: .utf8) {
                        logger.info("\(rawJSON, privacy: .public)")
                    }

                    let decoded = try JSONDecoder().decode(HoroscopeResponse.self, from: data)
                    horoscopoLabel.text = decoded.data.horoscope
                } else {
                    logger.warning("Status code: \(httpResponse.statusCode)")
                }
            } catch {
                logger.error("\(error.localizedDescription, privacy: .public)")
            }
        }
    }
          
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */



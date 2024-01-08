//
//  ImageDownloadService.swift
//  Regional-Compatibility-Checker
//
//  Created by k21123kk on 2024/01/09.
//

import Foundation
import UIKit

class ImageDownloadService {
  func downloadImage(from urlString: String, completion: @escaping (Result<UIImage, Error>) -> Void) {
         guard let url = URL(string: urlString) else {
             completion(.failure(NSError(domain: "InvalidURL", code: -1, userInfo: nil)))
             return
         }

         URLSession.shared.dataTask(with: url) { data, response, error in
             if let error = error {
                 completion(.failure(error))
                 return
             }
             guard let data = data, let image = UIImage(data: data) else {
                 completion(.failure(NSError(domain: "ImageDataError", code: -2, userInfo: nil)))
                 return
             }
             completion(.success(image))
         }.resume()
     }
}

//
//  ApiManager.swift
//  TrailerPreview
//
//  Created by Артём Гуральник on 3/24/19.
//  Copyright © 2019 Guralnyk Artem. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class ApiManager {
    
    typealias CompletionBlock = (JSON?, Error?) -> Void
    
    func performRequest(_ url: String, completion: @escaping CompletionBlock) {
     
        Alamofire.request(url).responseJSON(completionHandler: { response in
            
            switch response.result {
                
            case .success(let value):
                let json = JSON(value)
            
                completion(json,nil)
                
            case .failure(let error):
                completion(nil,error)
            }
            
        })
    }
}

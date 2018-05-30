//
//  ViewController.swift
//  SearchAPi
//
//  Created by Sukumar Anup Sukumaran on 30/05/18.
//  Copyright © 2018 TechTonic. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        parseData()
    }

    func parseData() {
        
        //create url String constant property
        let url = "https://restcountries.eu/rest/v1/all"
        
        //create a URL Request
        var request = URLRequest(url: URL(string: url)!)
        
        // create request httpMethod type
        request.httpMethod = "GET"
        
        // configurations are necessary to add to the URLSession function , configurations like timeout conditions or the need to store credentials , caches and cookies or connection requirements.
        let configuration = URLSessionConfiguration.default
        
        // creates a URLSession object that enable to call the api in the background thread without affecting the UI, the delegate action however is nil, if added URLSessionDelegate. something will be handle in the main queue, thats what id the delegateQueue is for.
        let session = URLSession(configuration: configuration, delegate: nil, delegateQueue: OperationQueue.main)
        
        // create a task variable to call the content of the url and after the completion of the call completion handler will get exequeted
        let task = session.dataTask(with: request) { (data, response, error) in
            
            guard error == nil else {return}
            guard let data = data else {return}
            
            // do catch method because jsonserialization has a throws as return
            do{
                if let json = try JSONSerialization.jsonObject(with: data, options: [.mutableContainers]) as? NSArray {
                    print("FETCHED = \(json), response = \(response!)")
                }
                
            }catch let error{
                
                print("Error = \(error), response = \(response!)")
                
            }
            
        }
        // after creating the task must start it by calling the resume() func.
        task.resume()
    }


}


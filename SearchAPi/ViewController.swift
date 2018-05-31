//
//  ViewController.swift
//  SearchAPi
//
//  Created by Sukumar Anup Sukumaran on 30/05/18.
//  Copyright © 2018 TechTonic. All rights reserved.
//

import UIKit

class Country {
    var country : String
    var capital : String
    
    init(country: String, capital: String) {
        self.country = country
        self.capital = capital
    }
}

class ViewController: UIViewController {
    
    @IBOutlet weak var countryTableView: UITableView!
    var fetchedCountry = [Country]() // array of type Country

    var searchbar = UISearchBar()
    override func viewDidLoad() {
        super.viewDidLoad()
        parseData()
        searchBar()
        ResignResponserOnTouch()
    }

    func parseData() {
        
        fetchedCountry.removeAll()
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
                   // print("FETCHED = \(json), response = \(response!)")
                    
//                    for eachDataFetched in json {
//                        let eachCountry = eachDataFetched as! [String: Any]
//                        let country = eachCountry["name"] as! String
//                        let capital = eachCountry["capital"] as! String
//
//                        self.fetchedCountry.append(Country(country: country, capital: capital))
//                         //print("Fetched = \(self.fetchedCountry[eachDataFetched].c)")
//                    }
                    
                    for i:Int in 0 ..< json.count {
                        let eachCountry = json[i] as! [String: Any]
                        let country = eachCountry["name"] as! String
                        let capital = eachCountry["capital"] as! String
                        
                        self.fetchedCountry.append(Country(country: country, capital: capital))
                         self.countryTableView.reloadData()
                    }
                   
                }
                
            }catch let error{
                
                print("Error = \(error), response = \(response!)")
                
            }
           
        }
        // after creating the task must start it by calling the resume() func.
        task.resume()
        
    }
    
    func ResignResponserOnTouch() {
        
        let tapGest = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyBord(_:)))
        self.countryTableView.addGestureRecognizer(tapGest)
    }
    
    @objc func dismissKeyBord(_ sender: UITapGestureRecognizer){
        //self.view.resignFirstResponder()
        searchbar.endEditing(true)
        print("TOUCHED")
    }


}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedCountry.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = countryTableView.dequeueReusableCell(withIdentifier: "cell")!
        cell.textLabel?.text = fetchedCountry[indexPath.row].country
        cell.detailTextLabel?.text = fetchedCountry[indexPath.row].capital
        return cell
    }
    
    
}

extension ViewController: UISearchBarDelegate {
    
    func searchBar() {
        searchbar = UISearchBar(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50))
        searchbar.delegate = self
        searchbar.showsScopeBar = true
        searchbar.barTintColor = UIColor.lightGray
        searchbar.scopeButtonTitles = ["Country", "Capital"]
        //self.view.addSubview(searchbar)
        self.countryTableView.tableHeaderView = searchbar
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("textDidChange was called ")
        if searchText == "" {
            parseData()
            
        }else{
            
            if searchBar.selectedScopeButtonIndex == 0 {
                print("SCOPE = Country")
                
                fetchedCountry = fetchedCountry.filter({ (haveFiltered) -> Bool in
                    return haveFiltered.country.lowercased().contains(searchText.lowercased())
                })
                
            }else  if searchBar.selectedScopeButtonIndex == 1{
                  print("SCOPE = Capital")
                
                fetchedCountry = fetchedCountry.filter({ (haveFiltered) -> Bool in
                    return haveFiltered.capital.lowercased().contains(searchText.lowercased())
                })
                
            }
            
        }
         self.countryTableView.reloadData()
        
    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        if searchBar.selectedScopeButtonIndex == 0 {
            print("SCOPE = Country")
            
           
            
        }else  if searchBar.selectedScopeButtonIndex == 1{
            print("SCOPE = Capital")
            
           
            
        }
    }
    
}


//
//  ViewController.swift
//  Project13-15
//
//  Created by Gitko Denis on 19.07.2022.
//

import UIKit

class ViewController: UITableViewController {
    var countries = [Country]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        performSelector(inBackground: #selector(fetchJson), with: nil)
    }


    @objc func fetchJson()  {
        if let bundlePath = Bundle.main.path(forResource: "countries", ofType: "json") {
            if let data = try? String(contentsOfFile: bundlePath).data(using: .utf8) {
                parseJson(json: data)
                return
            }
        }
    }
    
    func parseJson(json: Data) {
        let decoder = JSONDecoder()

        if let jsonCountries = try? decoder.decode(Countries.self, from: json) {
            countries = jsonCountries.countries
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
        } else {
            DispatchQueue.main.async {
                self.showError()
            }
        }
    }

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countries.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "Country")
        
        var configuration = cell.defaultContentConfiguration()
        configuration.text = countries[indexPath.row].country
        cell.contentConfiguration = configuration
        
        return cell
    }
    
    @objc func showError() {
        let ac = UIAlertController(title: "Error loading countries", message: nil, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Dismiss", style: .default))
        present(ac, animated: true)
    }
    
}


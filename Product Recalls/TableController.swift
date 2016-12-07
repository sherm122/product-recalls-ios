//
//  TableController.swift
//  Product Recalls
//
//  Created by Adam Sherman on 12/5/16.
//  Copyright © 2016 Adam Sherman. All rights reserved.
//

import UIKit

class TableController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, XMLParserDelegate {

     //let searchController = UISearchController(searchResultsController: nil)
     @IBOutlet weak var tbData: UITableView!
     @IBOutlet weak var searchBar: UISearchBar!
    
     var recalls: [Recall] = []
     var theName: String = String()
     var recallId: String = String()
     var recallDate: String = String()
     var theDescription: String = String()
     var theTitle: String = String()
     var theContact: String = String()
     var urlString: String = String()
     
     func initUrl(date: Date, searchString: String) {

     }
     
     override func viewDidLoad() {
        super.viewDidLoad()
          let dateFormatter = DateFormatter()
          dateFormatter.dateFormat = "yyy-MM-dd"
          let past = dateFormatter.string(from:  Date(timeIntervalSinceNow: -15552000)) //default start date is 180 days ago
          let originalUrlString = "http://www.saferproducts.gov/RestWebServices/Recall?RecallDateStart=" + past
          urlString = originalUrlString.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)!
          let mainUrl = URL(string: urlString)
          if let parser = XMLParser(contentsOf: mainUrl!) {
               parser.delegate = self
               parser.parse()
          }
          tbData.delegate = self
          tbData.dataSource = self
          searchBar.showsCancelButton = true
          searchBar.delegate = self
    }
     
     func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
          searchBar.text = ""
          searchBar.resignFirstResponder()
          let dateFormatter = DateFormatter()
          dateFormatter.dateFormat = "yyy-MM-dd"
          let past = dateFormatter.string(from:  Date(timeIntervalSinceNow: -15552000)) //default start date is 180 days ago
          let originalUrlString = "http://www.saferproducts.gov/RestWebServices/Recall?RecallDateStart=" + past
          urlString = originalUrlString.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)!
          let mainUrl = URL(string: urlString)
          recalls.removeAll()
          if let parser = XMLParser(contentsOf: mainUrl!) {
               parser.delegate = self
               parser.parse()
          }
          tbData.reloadData()
     }
     override func viewDidAppear(_ animated: Bool) {
          tbData.reloadData()
     }
     
     func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
          let dateFormatter = DateFormatter()
          dateFormatter.dateFormat = "yyy-MM-dd"
          let past = dateFormatter.string(from: Date(timeIntervalSinceNow: -31536000)) //start date when searching is 1 year ago
          let originalUrlString = "http://www.saferproducts.gov/RestWebServices/Recall?RecallDateStart=" + past + "&RecallDescription=" + searchText
          urlString = originalUrlString.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)!
     }
     func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
          searchBar.resignFirstResponder()
          let mainUrl = URL(string: urlString)
          recalls.removeAll()
          if let parser = XMLParser(contentsOf: mainUrl!) {
               parser.delegate = self
               parser.parse()
          }
          tbData.reloadData()
     }
     
     func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
          theName = elementName
          if elementName == "Recall" {
               recallId = String()
               recallDate = String()
               theDescription = String()
               theTitle = String()
               theContact = String()
          }
     }
     
     func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
          if elementName == "Recall" {
               
               let recall = Recall()
               recall.recallId = recallId
               recall.recallDate = recallDate
               recall.theDescription = theDescription
               recall.theTitle = theTitle
               recall.theContact = theContact
               recalls.append(recall)
          }
     }
     
     func parser(_ parser: XMLParser, foundCharacters string: String) {
          let data = string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
          
          if (!data.isEmpty) {
               if theName == "RecallID" {
                    recallId += data
               } else if theName == "RecallDate" {
                    recallDate += data
               } else if theName == "Description" {
                    theDescription += data
               } else if theName == "Title" {
                    theTitle += data
               } else if theName == "ConsumerContact" {
                    theContact += data
               }
          }
     }
     
     func numberOfSections(in tableView: UITableView) -> Int {
          return 1
     }
     
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
          return recalls.count
     }
     
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          let cell = tableView.dequeueReusableCell(withIdentifier: "theCell", for: indexPath)
          let recall = recalls[indexPath.row]
          cell.textLabel?.text = recall.theTitle
          cell.detailTextLabel?.text = recall.recallId
          
          return cell
     }
     
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
          
          let storyboard = UIStoryboard(name: "Main", bundle: nil)
          let detailVC = storyboard.instantiateViewController(withIdentifier: "details")  as! DetailController
          
          
          let theRecalls = recalls
          detailVC.recall = theRecalls[indexPath.row]
          
          self.navigationController!.pushViewController(detailVC, animated: true)
     }
     
     
     /* override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

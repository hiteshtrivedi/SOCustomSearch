//
//  ViewController.swift
//  SOCustomSearch
//
//  Created by Hitesh on 11/18/16.
//  Copyright © 2016 myCompany. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var txtSearchBar: UITextField!
    @IBOutlet weak var tblCountry: UITableView!
    
    @IBOutlet weak var btnClear: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    
    var arrCountry = NSMutableArray()
    var arrSearch = NSMutableArray()
    
    var isSearch = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        btnCancel.enabled = false
        btnClear.hidden = true
        getAllCountryName()
    }
    
    //MARK:- Get all Country name
    func getAllCountryName() {
        let locale = NSLocale.currentLocale()
        let countryArray = NSLocale.ISOCountryCodes()
        var arrGetCountry = countryArray.map { (countryCode) -> String in
            return locale.displayNameForKey(NSLocaleCountryCode, value: countryCode)!
        }
        arrGetCountry = arrGetCountry.sort()
        arrCountry.addObjectsFromArray(arrGetCountry)
        tblCountry.reloadData()
    }
    
    
    //MARK: UITableViewDelegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 64
    }

    
    //MARK: UITableViewDataSource
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearch == true {
            return arrSearch.count
        }
        return arrCountry.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        configureCell(cell, forRowAtIndexPath: indexPath)
        return cell
    }
    
    func configureCell(cell: UITableViewCell, forRowAtIndexPath: NSIndexPath) {
        if isSearch == true {
            cell.textLabel?.text = arrSearch[forRowAtIndexPath.row] as? String
        } else {
            cell.textLabel?.text = arrCountry[forRowAtIndexPath.row] as? String
        }
    }


    
    //MARK: - UITextField Delegate -
    func textFieldDidChange(textField: UITextField) {
        self.arrSearch.removeAllObjects()
        if textField.text?.characters.count > 0 {
            isSearch = true
        } else {
            isSearch = false
        }
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        UIView.animateWithDuration(0.3, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
            self.view.layoutIfNeeded()
        }) { (finished) in
            textField.becomeFirstResponder()
        }
        
        if isSearch {
            return
        }
        isSearch = true
        self.arrSearch.removeAllObjects()
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        let newString = (textField.text! as NSString).stringByReplacingCharactersInRange(range, withString: string)
        NSLog("%@", newString)
        
        if newString.characters.count == 0 {
            btnCancel.enabled = false
            btnClear.hidden = true
            
            isSearch = false
            self.tblCountry.reloadData()
        } else {
            let sanitized: String = newString.stringByReplacingOccurrencesOfString("'", withString: "''")
            arrSearch.removeAllObjects()
            self.filteredArray(sanitized)
        }
        return true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField.text?.characters.count == 0 {
            isSearch = false
        } else {
            isSearch = true
        }
        self.tblCountry.reloadData()
        return textField.resignFirstResponder()
    }
    
    //MARK:- Filter by search
    func filteredArray(searchString:NSString) {
        isSearch = true
        btnCancel.enabled = true
        btnClear.hidden = false
        
        let predicate = NSPredicate(format: "SELF contains[c] %@",searchString)
        let filteredArray = arrCountry.filteredArrayUsingPredicate(predicate)
        print(filteredArray)
        arrSearch.addObjectsFromArray(filteredArray)
        tblCountry.reloadData()
    }
    
    //MARK:- Cancel button action
    @IBAction func actionCancel(sender: AnyObject) {
        btnCancel.enabled = false
        btnClear.hidden = true
        isSearch = false
        txtSearchBar.text = ""
        txtSearchBar.resignFirstResponder()
        tblCountry.reloadData()
    }
    
    //MARK:- Clear button action
    @IBAction func actionClear(sender: AnyObject) {
        btnCancel.enabled = false
        btnClear.hidden = true
        isSearch = false
        txtSearchBar.text = ""
        tblCountry.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

//Mark: UITextField extention for padding
class TextField: UITextField {
    
    let padding = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 25);
    
    override func textRectForBounds(bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
    override func placeholderRectForBounds(bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
    override func editingRectForBounds(bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
}


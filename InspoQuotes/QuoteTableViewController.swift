//
//  QuoteTableViewController.swift
//  InspoQuotes
//
//  Created by D L on 2022-11-24.
//

import UIKit
import StoreKit

class QuoteTableViewController: UITableViewController, SKPaymentTransactionObserver {
    
    let productID = "com.dl.InspoQuotes.PremiumQuotes"
    
    var quotesToShow = [
        "Our greatest glory is not in never falling, but in rising every time we fall. — Confucius",
        "All our dreams can come true, if we have the courage to pursue them. – Walt Disney",
        "It does not matter how slowly you go as long as you do not stop. – Confucius",
        "Everything you’ve ever wanted is on the other side of fear. — George Addair",
        "Success is not final, failure is not fatal: it is the courage to continue that counts. – Winston Churchill",
        "Hardships often prepare ordinary people for an extraordinary destiny. – C.S. Lewis"
    ]
    
    let premiumQuotes = [
        "Believe in yourself. You are braver than you think, more talented than you know, and capable of more than you imagine. ― Roy T. Bennett",
        "I learned that courage was not the absence of fear, but the triumph over it. The brave man is not he who does not feel afraid, but he who conquers that fear. – Nelson Mandela",
        "There is only one thing that makes a dream impossible to achieve: the fear of failure. ― Paulo Coelho",
        "It’s not whether you get knocked down. It’s whether you get up. – Vince Lombardi",
        "Your true success in life begins only when you make the commitment to become excellent at what you do. — Brian Tracy",
        "Believe in yourself, take on your challenges, dig deep within yourself to conquer fears. Never let anyone bring you down. You got to keep going. – Chantal Sutherland"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SKPaymentQueue.default().add(self)
        
        if isPurchased() {
            showPremiumQuotes()
        }
        
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isPurchased() {
            return quotesToShow.count
        } else {
            return  quotesToShow.count + 1
        }
    }
    
    //to populate cells
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "QuoteCell", for: indexPath)
        
        //configure the cell
        if indexPath.row < quotesToShow.count {
            cell.textLabel?.text = quotesToShow[indexPath.row]
            cell.textLabel?.numberOfLines = 0
            cell.textLabel?.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            cell.accessoryType = .none
        } else {
            cell.textLabel?.text = "Get More Quotes"
            //colorLiteral become #colorLiteral(
            cell.textLabel?.textColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
            //disclosureIndicator can be used to indicate to the user can press on the cell and something will happen
            cell.accessoryType = .disclosureIndicator
        }
        
        return cell
    }
    
    // MARK: - Table view delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == quotesToShow.count {
            buyPremiumQuotes()
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - In-App purchase methods
    
    //to trigger in-app purchases
    func buyPremiumQuotes() {
        if SKPaymentQueue.canMakePayments() {
            let paymentRequest = SKMutablePayment()
            paymentRequest.productIdentifier = productID
            SKPaymentQueue.default().add(paymentRequest)
        } else {
            //Can't make payments
            print("User can't make payments")
        }
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            if transaction.transactionState == .purchased {
                //User payment sucessful
                print("Transaction successful")
                
                showPremiumQuotes()
                
                SKPaymentQueue.default().finishTransaction(transaction)
                
            } else if transaction.transactionState == .failed {
                //Payment failed
                if let error = transaction.error {
                    let errorDescription = error.localizedDescription
                    print("Transaction failed \(errorDescription)")
                }
                
                SKPaymentQueue.default().finishTransaction(transaction)
            } else if transaction.transactionState == .restored {
                showPremiumQuotes()
                print("Transaction restored")
                
                
                
                SKPaymentQueue.default().finishTransaction(transaction)
            }
        }
    }
    
    func showPremiumQuotes() {
        //to keep hold of the data of whether the user purchased in-app purchase or not
        UserDefaults.standard.set(true, forKey: productID)
        navigationItem.setRightBarButton(nil, animated: true)
        quotesToShow.append(contentsOf: premiumQuotes)
        //to update data and number of cells
        tableView.reloadData()
    }
    
    //to check whether if the user has purchased the premiumQuotes
    func isPurchased() -> Bool {
        let purchaseStatus = UserDefaults.standard.bool(forKey: productID)

        if purchaseStatus {
            print("Previously purchased")
            return true
        } else {
            print("Never purchased")
            return false
        }
    }
    
    @IBAction func restorePressed(_ sender: UIBarButtonItem) {
        SKPaymentQueue.default().restoreCompletedTransactions()
        
    }
}

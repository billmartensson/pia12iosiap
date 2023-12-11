//
//  Store.swift
//  pia12iosiap
//
//  Created by BillU on 2023-12-11.
//

import Foundation
import StoreKit

@MainActor final class Store: ObservableObject {
    @Published private(set) var products: [Product] = []
    @Published private(set) var activeTransactions: Set<StoreKit.Transaction> = []
    
    private var updates: Task<Void, Never>?
    
    @Published var ownedProducts = [String]()
    
    init() {
        updates = Task {
            for await update in StoreKit.Transaction.updates {
                if let transaction = try? update.payloadValue {
                    activeTransactions.insert(transaction)
                    print("TRANSACTION DONE " + transaction.productID)
                    buyok(productid: transaction.productID)
                    await transaction.finish()
                }
            }
        }
    }
    
    deinit {
        updates?.cancel()
    }
    
    func fetchProducts() async {
        do {
            products = try await Product.products(
                for: [
                    "funcredit", "premiumfunstuff", "fancymonthly"
                ]
            )
            print("PRODUCTS:")
            for prod in products {
                print(prod.id)
            }
        } catch {
            products = []
        }
    }
    
    func purchase(_ product: Product) async throws {
        let result = try await product.purchase()
        switch result {
        case .success(let verificationResult):
            if let transaction = try? verificationResult.payloadValue {
                activeTransactions.insert(transaction)
                print("PURCHASE DONE")
                buyok(productid: transaction.productID)
                await transaction.finish()
            }
        case .userCancelled:
            print("USER CANCEL")
            break
        case .pending:
            print("PURCHASE PENDING")
            break
        @unknown default:
            break
        }
    }
    
    func fetchActiveTransactions() async {
        var activeTransactions: Set<StoreKit.Transaction> = []
        
        print("ACTIVE TRANSACTIONS")
        var tempOwned = [String]()
        for await entitlement in StoreKit.Transaction.currentEntitlements {
            if let transaction = try? entitlement.payloadValue {
                //activeTransactions.insert(transaction)
                print("HAVE BOUGHT " + transaction.productID)
                tempOwned.append(transaction.productID)
            }
        }
        self.ownedProducts = tempOwned

        //self.activeTransactions = activeTransactions
    }
    
    
    func buyok(productid : String) {
        if productid == "funcredit" {
            // Skicka till server mera krediter
        }
        if productid == "premiumfunstuff" {
            // Spara att premium
        }
    }
    
}


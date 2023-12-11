//
//  ContentView.swift
//  pia12iosiap
//
//  Created by BillU on 2023-12-11.
//

import SwiftUI
import StoreKit

struct ContentView: View {
    
    @StateObject private var store = Store()
    
    
    var body: some View {
        VStack {
            
            if store.ownedProducts.isEmpty == false {
                Text("USER IS SUBSCRIPTION")
            }
            
            Text("Purchased items: \(store.activeTransactions.count)")
            
            if store.products.isEmpty {
                ProgressView()
            } else {
                ForEach(store.products, id: \.id) { product in
                    Button {
                        Task {
                            try await store.purchase(product)
                        }
                    } label: {
                        VStack {
                            Text(verbatim: product.displayName)
                                .font(.headline)
                            Text(verbatim: product.displayPrice)
                        }
                    }
                    .buttonStyle(.borderedProminent)
                }
                
                
                
                ProductView(id: "funcredit") {
                    Image(systemName: "crown")
                }
                .productViewStyle(.compact)
                .padding()
                .onInAppPurchaseStart { product in
                    print("User has started buying \(product.id)")
                }
                .onInAppPurchaseCompletion { product, result in
                    if case .success(.success(let transaction)) = result {
                        print("Purchased successfully: \(transaction.signedDate)")
                    } else {
                        print("Something else happened")
                    }
                }
            }
        }
        .task {
            await store.fetchProducts()
        }
    }
}

#Preview {
    ContentView()
}




/*
 
 
 VStack {
 Text("Welcome to my store")
 .font(.title)
 
 ProductView(id: "funcredit") {
 Image(systemName: "crown")
 }
 .productViewStyle(.compact)
 .padding()
 .onInAppPurchaseStart { product in
 print("User has started buying \(product.id)")
 }
 .onInAppPurchaseCompletion { product, result in
 if case .success(.success(let transaction)) = result {
 print("Purchased successfully: \(transaction.signedDate)")
 } else {
 print("Something else happened")
 }
 }
 
 }
 
 
 
 
 
 
 VStack {
 Text("Hacking with Swift+")
 .font(.title)
 
 StoreView(ids: ["funcredit", "premiumfunstuff"])
 }
 
 
 
 
 
 VStack {
 Text("Welcome to my store")
 .font(.title)
 
 ProductView(id: "funcredit") {
 Image(systemName: "crown")
 }
 .productViewStyle(.compact)
 .padding()
 
 ProductView(id: "funcredit") {
 Image(systemName: "crown")
 }
 .productViewStyle(.compact)
 .padding()
 }
 
 */

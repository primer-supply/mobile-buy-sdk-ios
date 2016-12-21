//
//  DataProvider.swift
//  Mobile Buy SDK Advanced Sample
//
//  Created by Shopify.
//  Copyright (c) 2016 Shopify Inc. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

import Foundation
import Buy

public class DataProvider {
    
    private(set) var client : BUYClient!
    
    var shop: BUYShop? = nil
    var products: [BUYProduct] = []
    
    var merchantId = ""
    
    public required init(shopDomain: String, apiKey: String, appId: String, merchantId: String) {
        self.merchantId = merchantId
        self.client = BUYClient(shopDomain: shopDomain, apiKey: apiKey, appId: appId)
        self.client.productPageSize = 5
        self.updateShop()
    }
    
    private func updateShop() {
        self.client.getShop {(shop, error) in
            if let shop = shop {
                self.shop = shop;
            }
        }
    }
    
    public func getClient() -> BUYClient {
        return self.client
    }

    public func getProducts(completion: @escaping ([BUYProduct]) -> Void) -> Operation {
        if self.products.count > 0 {
            completion(self.products)
        }
        return self.downloadProducts(completion:completion)
    }
    
    public func getCurrencyFormatter() -> NumberFormatter {
        let currencyFormatter = NumberFormatter()
        currencyFormatter.numberStyle = NumberFormatter.Style.currency
        currencyFormatter.currencyCode = self.shop?.currency
        return currencyFormatter
    }
    
    private func downloadProducts(completion: @escaping([BUYProduct]) -> Void) -> Operation {
        return self.client.getProductsPage(1, completion: { [weak self] (products, page, reachedEnd, error) in
            self?.products = products!
            completion(products!)
        })
    }

    
}

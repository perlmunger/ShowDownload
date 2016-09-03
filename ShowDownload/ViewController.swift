//
//  ViewController.swift
//  ShowDownload
//
//  Created by Matt Long on 9/2/16.
//  Copyright © 2016 Matt Long. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var webView:UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let url = URL(string: "https://bitcoin.org/bitcoin.pdf")
        
        let task = URLSession.shared.downloadTask(with: url!) { (localUrl, response, error) in
            // Have to copy the downloaded file somewhere else or it will get purged
            let filename = "outputfilename.pdf"
            let outputUrl = FileManager.default.documentsDirectoryURL.appendingPathComponent(filename)
            do {
                // The file is now in our documents directory
                try FileManager.default.copyItem(at: localUrl!, to: outputUrl)
            } catch {
                
            }

            // Call back out to the main thread to load the resource
            DispatchQueue.main.async {
                self.webView.loadRequest(URLRequest(url: outputUrl))
            }
        }
        
        task.resume()
    }
    
}

// Add an extension to the file manager to simplify grabbing the documents directory
extension FileManager {
    var documentsDirectoryURL : URL {
        get {
            let urls = self.urls(for: .documentDirectory, in: .userDomainMask)
            return urls[urls.endIndex-1]
        }
    }
}

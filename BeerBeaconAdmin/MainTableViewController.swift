//
//  MainTableViewController.swift
//
// Copyright (c) 21/12/15. Ramotion Inc. (http://ramotion.com)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import UIKit
import FoldingCell
import Firebase
import KVNProgress


class MainTableViewController: UITableViewController {
    
    @IBOutlet weak var cartao_virtual: UILabel!
    
    let kCloseCellHeight: CGFloat = 179
    let kOpenCellHeight: CGFloat = 488

    let kRowsCount = 10
    
    var cellHeights = [CGFloat]()
    
    var taps = [Tap]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        if self.taps.count == 0 {
            
           setupConfig()
           KVNProgress.show(withStatus: "Carregando", on: view)
        }

    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
         if self.taps.count == 0 {
            
            FIRDatabase.database().reference().child("taps").observe(.value, with: { (snapshot) in
                
                self.taps.removeAll()
                
                for child in snapshot.children{
                    let tap = Tap(snapshot: child as! FIRDataSnapshot)
                    tap.uid = (child as AnyObject).key
                    self.taps.append(tap)
                }
                
                self.tableView.reloadData()
                
                KVNProgress.dismiss()
            })
        }
    }
    
    func setupConfig() {
        let Basic = KVNProgressConfiguration()
        Basic.statusColor = UIColor.white
        Basic.circleStrokeForegroundColor = UIColor.white
        Basic.circleStrokeBackgroundColor = UIColor.white
        Basic.circleSize = 80.0
        Basic.lineWidth = 1.5
        Basic.isFullScreen = false
        Basic.backgroundFillColor = UIColor(red: 255/255, green: 212/255, blue: 0/255, alpha: 0.9)
        
        KVNProgress.setConfiguration(Basic)
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createCellHeightsArray()
        self.tableView.backgroundColor = UIColor(patternImage: UIImage(named: "back")!)
        
    }
    
    // MARK: configure
    func createCellHeightsArray() {
        for _ in 0...kRowsCount {
            cellHeights.append(kCloseCellHeight)
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taps.count
    }

    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
      
      guard case let cell as DemoCell = cell else {
        return
      }
      
      cell.backgroundColor = UIColor.clear
      
      if cellHeights[(indexPath as NSIndexPath).row] == kCloseCellHeight {
        cell.selectedAnimation(false, animated: false, completion:nil)
      } else {
        cell.selectedAnimation(true, animated: false, completion: nil)
      }
      
      cell.number = indexPath.row
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FoldingCell", for: indexPath) as! FoldingCell
        
        cell.tap = taps[(indexPath as NSIndexPath).row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeights[(indexPath as NSIndexPath).row]
    }
    
    // MARK: Table vie delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//        let cell = tableView.cellForRow(at: indexPath) as! FoldingCell
//        
//        if cell.isAnimating() {
//            return
//        }
//        
//        var duration = 0.0
//        if cellHeights[(indexPath as NSIndexPath).row] == kCloseCellHeight { // open cell
//            cellHeights[(indexPath as NSIndexPath).row] = kOpenCellHeight
//            cell.selectedAnimation(true, animated: true, completion: nil)
//            duration = 0.5
//        } else {// close cell
//            cellHeights[(indexPath as NSIndexPath).row] = kCloseCellHeight
//            cell.selectedAnimation(false, animated: true, completion: nil)
//            duration = 0.8
//        }
//        
//        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseOut, animations: { () -> Void in
//            tableView.beginUpdates()
//            tableView.endUpdates()
//        }, completion: nil)

        
    }
}

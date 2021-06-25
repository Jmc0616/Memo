//
//  ComposeViewController.swift
//  jmcMemo
//
//  Created by myeongcheol jeong on 2021/06/20.
//

import UIKit

class ComposeViewController: UIViewController {
    
    var editTarget: Memo?

    @IBAction func close(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var memoText: UITextView!
    
    @IBAction func save(_ sender: Any) {
        guard let memo = memoText.text, memo.count > 0 else {
            alert(message: "메모를 입력해주세요!")
            return
        }
//        let newMemo = Memo(content: memo)
//        Memo.dummyMemoList.append(newMemo)
        
        if let target = editTarget{
            target.content = memo
            DataManager.shared.saveContext()
            NotificationCenter.default.post(name: ComposeViewController.memoDidchange, object: nil)
        }else{
            DataManager.shared.addNewMemo(memo)
            NotificationCenter.default.post(name: ComposeViewController.newMemoDidInsert, object: nil)
        }
        dismiss(animated: true, completion: nil)
    }
    
    var willShowToken: NSObjectProtocol?
    var willHideToken: NSObjectProtocol?
    
    deinit {
        if let token = willShowToken {
            NotificationCenter.default.removeObserver(token)
        }
        if let token = willHideToken {
            NotificationCenter.default.removeObserver(token)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let memo = editTarget {
            navigationItem.title = "메모 편집"
            memoText.text = memo.content
        }else{
            navigationItem.title = "새 메모"
            memoText.text = ""
        }
        willShowToken = NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: OperationQueue.main, using: { [weak self] (noti) in
            guard let strongSelf = self else { return }
            
            if let frame = noti.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue{
                let height = frame.cgRectValue.height
                
                var inset = strongSelf.memoText.contentInset
                inset.bottom = height
                strongSelf.memoText.contentInset = inset
                
                inset = strongSelf.memoText.scrollIndicatorInsets
                inset.bottom = height
                strongSelf.memoText.scrollIndicatorInsets = inset
            }
        })
        willHideToken = NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: OperationQueue.main, using: { [weak self] (noti) in
            guard let strongSelf = self else { return }
            
            var inset = strongSelf.memoText.contentInset
            inset.bottom = 0
            strongSelf.memoText.contentInset = inset
            
            inset = strongSelf.memoText.scrollIndicatorInsets
            inset.bottom = 0
            strongSelf.memoText.scrollIndicatorInsets = inset
        })
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension ComposeViewController {
    static let newMemoDidInsert = Notification.Name(rawValue: "newMemoDidInsert")
    static let memoDidchange = Notification.Name(rawValue: "memoDidchange")
}

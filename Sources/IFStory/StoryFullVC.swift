//
//  StoryFullVC.swift
//  customStoryTest
//
//  Created by MD SAZID HASAN DIP on 15/7/21.
//

import UIKit

public class StoryFullVC: UIViewController {
    var onceOnly = false
    
    var igStories: IFStories!
    var delegate: FullScreenSotryDelegate?
    var storyIndex: Int!
    var previousSnap: IFSnap!
    
    private var previewViewTop:CGFloat = 0
    private var previewViewLeft:CGFloat = 0
    private var previewViewRight:CGFloat = 0
    private var previewViewBottom:CGFloat = 0
    private var previewViewRoundedCorner:CGFloat = 0
    
    
    private var stories = [IFSingleStory]()
    
    @IBOutlet weak var storyCollectionView: UICollectionView!
    
    public init(with stories: IFStories, handPickedStoryIndex: Int, delegate:FullScreenSotryDelegate) {
        self.igStories = stories
        self.delegate = delegate
        self.storyIndex = handPickedStoryIndex
        
        let nibName = String(describing: Self.self)
        print("StoryFullVC Nib Name: " + nibName)
        super.init(nibName: nibName, bundle: Bundle.module)
        self.modalPresentationStyle = .fullScreen
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func setVideoOrImageView(top:CGFloat = 0, left:CGFloat = 0, right:CGFloat = 0, bottom:CGFloat = 0, cornerRadius:CGFloat){
        previewViewTop = top
        previewViewLeft = left
        previewViewRight = right
        previewViewBottom = bottom
        previewViewRoundedCorner = cornerRadius
        
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        storyCollectionView.dataSource = self
        storyCollectionView.delegate = self
        storyCollectionView.register(UINib(nibName: "StoryCollectionViewCell", bundle: Bundle.module), forCellWithReuseIdentifier: "StoryCollectionViewCell")
       // populateStories()
        self.stories = self.igStories.stories
    }

}

extension StoryFullVC:  UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.stories.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = storyCollectionView.dequeueReusableCell(withReuseIdentifier: "StoryCollectionViewCell", for: indexPath) as! StoryCollectionViewCell
        print(indexPath.row, indexPath.item)
        
        cell.resizeViewTopContraints = previewViewTop
        cell.resizeViewLeftConstraints = previewViewLeft
        cell.resizeViewRightConstraints = previewViewRight
        cell.resizeViewBottomConstraints = previewViewBottom
        cell.resizeViewCornerRadius = previewViewRoundedCorner

        
        cell.story = self.stories[indexPath.item]
        cell.storyIndexPath = indexPath
        cell.fullScreenStoryDelegateForCell = self
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//        if !onceOnly {
//              let indexToScrollTo = IndexPath(item: storyIndex , section: 0)
//              self.storyCollectionView.scrollToItem(at: indexToScrollTo, at: .left, animated: false)
//            delegate?.storyDidAppear(currentStoryInProgress: stories[indexToScrollTo.item])
//              onceOnly = true
//            }
        
//       let currentCell = cell as! StoryCollectionViewCell
//        print("is current cell progress timer invalidated: ", currentCell.isProgressTimerInvalidate)
//        if currentCell.isProgressTimerInvalidate {
//        currentCell.progressTimer.fire()
//        }

    }
    
}


extension StoryFullVC:  UICollectionViewDelegate {
  
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    public func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        debugPrint(cell, indexPath.item)
    }
    
    
    
   
    
}

extension StoryFullVC: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
}

extension StoryFullVC: FullScreenSnapDelegate{
    func snapDidAppear(currentSnapInProgress: IFSnap?) {
      //  print("snap Did Appear: ", currentSnapInProgress?.lastUpdated)
        delegate?.snapDidAppear(currentSnapInProgress: currentSnapInProgress)
    }
    
    
    func goToNextStory(atStory: IFSingleStory, forSnap: IFSnap, indexPath: IndexPath) {
    
        if indexPath.item <  self.stories.count - 1 {
            let indexPath = IndexPath(item: indexPath.item + 1, section: 0)
            storyCollectionView.scrollToItem(at: indexPath, at: .right, animated: false)
        }else {
        
        self.dismiss(animated: true)
            delegate?.snapClosed(atStroy: atStory , forStoryIndexPath: indexPath, forSnap: forSnap)
        }
    }
    
    func snapWillAppear(nextSnap: IFSnap?) {
        //print("snap will Appear: ", nextSnap?.lastUpdated)
        delegate?.snapWillAppear(nextSnap: nextSnap)
    }
    
    func snapDidDisappear(previousSnap: IFSnap?) {
        //print("snap Did Disappear: ", previousSnap?.lastUpdated)
        if let snap = previousSnap {
            self.previousSnap = snap
            delegate?.snapDidDisappear(previousSnap: previousSnap)
        } else if self.previousSnap != nil {
            delegate?.snapDidDisappear(previousSnap: self.previousSnap)
        }
    }
    
    func profileImageTapped(userInfo: IFUser?) {
        delegate?.profileImageTapped(userInfo: userInfo)
    }
    

    
    func snapClosed(isClosed: Bool, atStroy: IFSingleStory, forStoryIndexPath:IndexPath, forSnap: IFSnap) {
        if forStoryIndexPath.item <  self.stories.count - 1, !isClosed {
           // print("Auto Scrolling to next Story Cell")
//            scrollAutomatically()
        }else {
        
            print("Story CollectionViewController Dissmissed", forSnap.storySnapUrl)
        self.dismiss(animated: true)
            delegate?.snapClosed(atStroy: atStroy , forStoryIndexPath: forStoryIndexPath, forSnap: forSnap)
        }
       
        //delegate.snapClosed(atStroy: atStroy, forSnap: forSnap)
    }
    
    func goToPreviousStroy(atStroy: IFSingleStory, forStoryIndexPath:IndexPath,forCell:StoryCollectionViewCell, forSnap: IFSnap) {
        print("Go to PreviousStory")
        if forStoryIndexPath.item > 0 {
            forCell.progressTimer.invalidate()
            forCell.isProgressTimerInvalidate = true
            let indexPath = IndexPath(item: forStoryIndexPath.item - 1, section: 0)
            storyCollectionView.reloadItems(at: [indexPath])
            storyCollectionView.scrollToItem(at: indexPath, at: .left, animated: false)
        }
    }
    
}

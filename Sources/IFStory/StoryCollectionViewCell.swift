//
//  StoryCollectionViewCell.swift
//  customStoryTest
//
//  Created by MD SAZID HASAN DIP on 28/6/21.
//

import UIKit
import Kingfisher

class StoryCollectionViewCell: UICollectionViewCell{
//    /Volumes/MYMACHDD/XcodeTutoProjects/customStoryTest/IFStory/Sources/IFStory/CollectionView/StoryCollectionViewCell.swift:9:8: Compiling for iOS 9.0, but module 'Kingfisher' has a minimum deployment target of iOS 10.0: /Users/dip/Library/Developer/Xcode/DerivedData/customStoryTest-fcxpayneqsohjrajmmbczeujtsbh/Build/Products/Debug-iphoneos/Kingfisher.swiftmodule/arm64-apple-ios.swiftmodule
//    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        // self.setupViewDidLoad()
       // self.setUpConstraintsForVideoAndImagePreviewView()
        self.setupViewDidLoad()
    }
    
   
    public var story: IFSingleStory! {
        didSet{
           // self.setUpConstraintsForVideoAndImagePreviewView()
            self.setUpConstraintsForVideoAndImagePreviewView()
            self.setupViewWillAppear()
            print("story count after Passing story",story.snapsInSingleStory?.count)
            
        }
    }
    //Identifiers
    fileprivate let snapViewTagIndicator: Int = 8
    @IBOutlet var closeButton: UIButton! {
        didSet {
            self.closeButton.addTarget(self, action: #selector(closeButtonAction), for: .touchUpInside)
        }
    }
    
    
    
    
    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var imageView: UIView!
    @IBOutlet weak var view: UIView!
    
    @IBOutlet weak var progressView: UIView!
    
    @IBOutlet var progressViewHolder: UIView!
    
    @IBOutlet var topTitleLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet var storyImageView: UIImageView!
    @IBOutlet var avatarImageView: UIImageView!
    @IBOutlet var leftIconImageView: UIImageView!
    @IBOutlet var rightIconImageView: UIImageView!
    @IBOutlet weak var resizableView:UIView!
    
    @IBOutlet var countLabel: UILabel!
    
    @IBOutlet var nextButton: UIButton! {
        didSet {
            self.nextButton.addTarget(self, action: #selector(nextAction), for: .touchUpInside)
        }
    }
    @IBOutlet var prevButton: UIButton! {
        didSet {
            self.prevButton.addTarget(self, action: #selector(prevAction), for: .touchUpInside)
        }
        
    }
    
    public var currentViewingStoryIndex = 0
    private var snapIndex = 0
    public var igStories: IFStories!
    private var snapCount = 0
    //  private var stories = [IGStory]()
    private var nextSnapIndex = 0
    public var storyIndexPath: IndexPath!
    
    var progressTimer = Timer()
    var isProgressTimerInvalidate = false
    private var automaticDissappearAfterSeconds = 5.0
    private var timerProgressStartAt = 0.0
    private var progressRate = 0.0
    private var topProgressViews = [UIProgressView]()
    public var showBlurEffectOnFullScreenView = true
    private let pangestureVelocity:CGFloat = 1000
    var fullScreenStoryDelegateForCell: FullScreenSnapDelegate?
    var videoProgressDuration:Float = 0.0
    var videoDuration:Float = 1.0
    var playingVideoView:IFPlayerView!
    
    var resizeViewTopContraints:CGFloat = 0
    var resizeViewBottomConstraints:CGFloat = 0
    var resizeViewLeftConstraints:CGFloat = 0
    var resizeViewRightConstraints:CGFloat = 0
    var resizeViewCornerRadius:CGFloat = 0

    
    
    
   private func setUpConstraintsForVideoAndImagePreviewView() {

        self.resizableView.translatesAutoresizingMaskIntoConstraints = false

        if resizeViewCornerRadius == 0 {

        self.resizableView.topAnchor.constraint(equalTo: self.progressView.topAnchor , constant: resizeViewTopContraints).isActive = true
            self.resizableView.leftAnchor.constraint(equalTo: self.progressView.leftAnchor, constant: resizeViewLeftConstraints).isActive = true
            self.resizableView.rightAnchor.constraint(equalTo: self.progressView.rightAnchor, constant: -resizeViewRightConstraints).isActive = true
            self.resizableView.bottomAnchor.constraint(equalTo: self.progressView.bottomAnchor, constant: -resizeViewBottomConstraints).isActive = true
            self.resizableView.layer.cornerRadius = resizeViewCornerRadius
        
        } else if resizeViewCornerRadius > 0 {
            self.progressView.backgroundColor = UIColor(hex: "#56B07F")
            self.resizableView.topAnchor.constraint(equalTo: self.avatarImageView.bottomAnchor , constant: resizeViewTopContraints).isActive = true
            self.resizableView.leftAnchor.constraint(equalTo: self.progressView.leftAnchor, constant: resizeViewLeftConstraints).isActive = true
            self.resizableView.rightAnchor.constraint(equalTo: self.progressView.rightAnchor, constant: -resizeViewRightConstraints).isActive = true
            self.resizableView.bottomAnchor.constraint(equalTo: self.progressView.bottomAnchor, constant: -resizeViewBottomConstraints).isActive = true
                self.resizableView.layer.cornerRadius = resizeViewCornerRadius
            
        }
        
        
        
    }
    
  
    private func setupViewDidLoad() {
        //self.stories = igStories.stories
        self.avatarImageView.layer.cornerRadius = avatarImageView.frame.size.width * 0.50
        //self.storyImageView.layer.cornerRadius = 20.0
        self.storyImageView.backgroundColor = .black
        
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        avatarImageView.isUserInteractionEnabled = true
        avatarImageView.addGestureRecognizer(tapGestureRecognizer)
        
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        fullScreenStoryDelegateForCell?.profileImageTapped(userInfo: story.user)
    }
    
   public  func setupViewWillAppear() {
        self.initProgressViews()
        self.avatarImageView.transform = .init(scaleX: 0.50, y: 0.50)
        self.topTitleLabel.transform = .init(scaleX: 1, y: 0.85)
        
        self.progressRate = automaticDissappearAfterSeconds/1000
        
        self.topTitleLabel.text = story.user.userName
        
        if let storySnaps = story.snapsInSingleStory, !story!.isSeen {
        
            for storySnap in storySnaps {
                print(storySnap.kind)
                if !storySnap.isSeen{
                    if storySnap.kind != StoryMimeType.video {
                        
                        
                        imageView.isHidden = false
                        
                    let singleStoryImage = storySnap.storySnapUrl
                    self.storyImageView.kf.indicatorType = .activity
                    self.storyImageView.kf.setImage(with: URL(string: singleStoryImage), placeholder: nil , options: nil, completionHandler:  {  (_) in
                        self.fullScreenStoryDelegateForCell?.snapDidAppear(currentSnapInProgress: storySnap)
                        self.initTimerProgress()
                    })
                break
                    
                    }else {
                        self.progressTimer.invalidate()
                        self.isProgressTimerInvalidate = true
                        imageView.isHidden = true
                        debugPrint(storySnap.storySnapUrl)
                        if let videoView = getVideoView(with: self.snapIndex) {
                            print("start player should not start from here")
                            self.playingVideoView = videoView
                            startPlayer(videoView: videoView, with: storySnap.storySnapUrl)
                           //self.initTimerProgress()
                        }else {
                            print("start player should start from here")
                            let videoView = createVideoView()
                            self.playingVideoView = videoView
                            startPlayer(videoView: videoView, with: storySnap.storySnapUrl)
                           // self.initTimerProgress()
                        }
                        break
                    }
                    
                } else {
                    
                }
            }
        } else {
            if let storySnap = story.snapsInSingleStory?.first{
                let singleStoryImage  = storySnap.storySnapUrl
                self.storyImageView.kf.indicatorType = .activity
                self.storyImageView.kf.setImage(with: URL(string: singleStoryImage), placeholder: nil , options: nil) { (_) in
                    self.fullScreenStoryDelegateForCell?.snapDidAppear(currentSnapInProgress: storySnap)
                }
            }
        }
        
        let avatarImageLink = story.user.userProfilePicture
        //print("avatar image: ", avatarImageLink)
        self.storyImageView.kf.indicatorType = .activity
        self.avatarImageView.kf.setImage(with: URL(string: avatarImageLink), placeholder:  nil , options: nil) { (_) in
            
        }
        self.timeLabel.text = story.lastUpdated
        
        
        
        if currentViewingStoryIndex == 0 {
            self.leftIconImageView.isHidden = true
            self.rightIconImageView.isHidden = false
        }
        else if currentViewingStoryIndex == story.snapsInSingleStory!.count  - 1 {
            self.leftIconImageView.isHidden = false
            self.rightIconImageView.isHidden = true
        }
        else {
            self.leftIconImageView.isHidden = false
            self.rightIconImageView.isHidden = false
        }
        
        self.timerProgressStartAt = 0.0
        
        UIView.animate(withDuration: 0.5) {
            self.avatarImageView.transform = .init(scaleX: 1.25, y: 1.25)
            self.topTitleLabel.transform = .identity
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            UIView.animate(withDuration: 0.5) {
                self.avatarImageView.transform = .identity
                //self.topTitleLabel.transform = .identity
            }
        }

    }
    
    
    private func initProgressViews() {
        
        for subViews in self.progressViewHolder.subviews {
            subViews.removeFromSuperview()
        }
        self.topProgressViews.removeAll()
        
        let stackView   = UIStackView()
        stackView.axis  = .horizontal
        stackView.contentMode = .scaleAspectFill
        stackView.distribution  = .fillEqually
        stackView.alignment = .center
        stackView.spacing   = 8.0
        stackView.frame = CGRect(x: 0, y: 0, width: self.progressViewHolder.frame.width, height: 6)

//        stackView.centerYanchor.constraint(equalTo: self.progressViewHolder.centerYanchor).isActive = true
       
       
        
        
        //stackView.translatesAutoresizingMaskIntoConstraints = false
        let storiyImages = story.snapsInSingleStory
        
        for _ in 0..<storiyImages!.count {
            let progressView = UIProgressView()
            progressView.tintColor = .white
            progressView.progress = 0.0
            progressView.contentMode = .scaleAspectFill
            
            stackView.addArrangedSubview(progressView)
            self.topProgressViews.append(progressView)
        }
        self.progressViewHolder.addSubview(stackView)
                stackView.translatesAutoresizingMaskIntoConstraints = false
                stackView.leftAnchor.constraint(equalTo: self.progressViewHolder.leftAnchor, constant:0).isActive = true
                stackView.rightAnchor.constraint(equalTo: self.progressViewHolder.rightAnchor, constant:0).isActive = true
    }
    
    
    
     func updateSnap(index: Int) {
        
        self.setNeedsLayout()
        self.setNeedsDisplay()
        if let snaps = story.snapsInSingleStory {
            if index > 0 {
                self.fullScreenStoryDelegateForCell?.snapDidDisappear(previousSnap: snaps[index - 1])
            }
            let snap = snaps[index]
            print(snap.kind)
            if snap.kind != StoryMimeType.video {
                if isProgressTimerInvalidate {
                    self.progressTimer.fire()
                    isProgressTimerInvalidate = false
                }
            imageView.isHidden = false
            let storyImageLink = snap.storySnapUrl
          self.storyImageView.kf.setImage(with: URL(string: storyImageLink), placeholder:  nil , options: nil) { (_) in
            self.fullScreenStoryDelegateForCell?.snapDidAppear(currentSnapInProgress: snaps[index] )
        }
                
            } else {
                imageView.isHidden = true
                self.progressTimer.invalidate()
                self.isProgressTimerInvalidate = true
                debugPrint(snap.storySnapUrl)
                if let videoView = getVideoView(with: snapIndex) {
                    startPlayer(videoView: videoView, with: snap.storySnapUrl)
                }else {
                    let videoView = createVideoView()
                    startPlayer(videoView: videoView, with: snap.storySnapUrl)
                }
                
                
            }
            
            let nextSnapIndex = index + 1
            if nextSnapIndex < snaps.count {
                fullScreenStoryDelegateForCell?.snapWillAppear(nextSnap: snaps[nextSnapIndex])
            }
            
    }else {
        print("there is no snap to show in current snap or update the story")
        }
    }
    
    
    
    
    @objc func closeButtonAction() {
        self.progressTimer.invalidate()
        fullScreenStoryDelegateForCell?.snapClosed(isClosed:true, atStroy: story, forStoryIndexPath: storyIndexPath, forSnap: story.snapsInSingleStory![snapIndex])
        
    }
    
    @objc func nextAction() {
        
        let imagesInCurrentStory = story.snapsInSingleStory
        
        if self.currentViewingStoryIndex < imagesInCurrentStory!.count-1 {
            
            if playingVideoView != nil {
                playingVideoView.stop()
            }
            
            
            if self.snapIndex < imagesInCurrentStory!.count-1 {
                
                self.topProgressViews[snapIndex].progress = 1.0
                
                self.snapIndex += 1
                self.timerProgressStartAt = 0.0
                
                
                UIView.animate(withDuration: 0.2) {
                    self.updateSnap(index: self.snapIndex)
                }
                
                self.timerProgressStartAt += self.progressRate
            }
            else {
                self.snapIndex = 0
                self.progressTimer.invalidate()
                currentViewingStoryIndex += 1
                fullScreenStoryDelegateForCell?.snapClosed(isClosed: false, atStroy: story, forStoryIndexPath: storyIndexPath, forSnap: (story.snapsInSingleStory?.last)!)
                print("going to next story")
                //                UIView.animate(withDuration: 0.2) {
                //                    self.setupViewWillAppear()
                //                }
          }
            
        }
        else {
            if self.snapIndex < imagesInCurrentStory!.count-1 {
                
            }
            else {
                currentViewingStoryIndex = 0
                self.progressTimer.invalidate()
                fullScreenStoryDelegateForCell?.snapClosed(isClosed: false, atStroy: story, forStoryIndexPath: storyIndexPath, forSnap: (story.snapsInSingleStory?.last)!)
                print("going to next story")
            }
            
        }
    }
    
    
    @objc func prevAction() {
        
        if playingVideoView != nil {
            playingVideoView.stop()
        }
       
            if self.snapIndex > 0 {
                self.progressTimer.invalidate()
                self.topProgressViews[snapIndex].progress = 0.0
                self.snapIndex -= 1
                self.topProgressViews[snapIndex].progress = 0.0
                self.timerProgressStartAt = 0.0
                
                
                
                UIView.animate(withDuration: 0.2) {
                    self.updateSnap(index: self.snapIndex)
                }
                
                self.timerProgressStartAt += self.progressRate
            }
            else {
                self.progressTimer.invalidate()
                self.snapIndex = 0
                self.timerProgressStartAt = 0.0
                currentViewingStoryIndex -= 1
                                UIView.animate(withDuration: 0.2) {
                                    self.setupViewWillAppear()
                                    
                                }
                fullScreenStoryDelegateForCell?.goToPreviousStroy(atStroy: story, forStoryIndexPath: storyIndexPath, forCell: self, forSnap: (story.snapsInSingleStory?.first)!)
            }
            
            
        
    }
    
    
    
    
    private func initTimerProgress() {
        
        self.progressTimer.invalidate()
        self.progressTimer = Timer.scheduledTimer(timeInterval: 0.02, target: self, selector: #selector(timerProgressAction), userInfo: nil, repeats: true)
        self.progressTimer.fire()
        
    }
    
    
    
    @objc func timerProgressAction() {
        //self.countLabel.text = "\(currentViewingStoryIndex+1)\n\(storyImageIndex+1)"
        if timerProgressStartAt > 1.0 {
            //self.closeButtonAction()
            let snapsInCurrentStory = story.snapsInSingleStory
            
            if self.snapIndex < snapsInCurrentStory!.count-1 {
                
                self.snapIndex += 1
                self.timerProgressStartAt = 0.0
                UIView.animate(withDuration: 0.2) {
                    self.updateSnap(index: self.snapIndex)
                }
                if !imageView.isHidden{
                    self.timerProgressStartAt += self.progressRate}else {
                        self.timerProgressStartAt += Double(self.videoProgressDuration)
                    }
            }
            else {
                //                self.timerProgressStartAt = 0.0
                //                self.storyImageIndex = 0
                //self.closeButtonAction()
                
                for progressView in topProgressViews {
                    progressView.progress = 0.0
                }
                
                self.initProgressViews()
                self.nextAction()
                
            }
            
        }
        else {
            if snapIndex < topProgressViews.count {
                self.topProgressViews[snapIndex].progress = Float(timerProgressStartAt)
                self.timerProgressStartAt += self.progressRate
            }
            
            
        }
        
        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if touches.first != nil {
            //print("Finger touched!")
            self.progressTimer.invalidate()
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if touches.first != nil {
            //print("finger is not touching.")
            self.initTimerProgress()
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if touches.first != nil {
            //print("Touch Move")
            self.progressTimer.invalidate()
        }
    }
    
    
}


extension StoryCollectionViewCell {
    
    private func createVideoView() -> IFPlayerView {
        print("creating New Video View")
        let videoView = IFPlayerView.init(frame: CGRect(x: 0, y: 0, width: videoView.frame.width, height: videoView.frame.height))
       videoView.tag = snapIndex + snapViewTagIndicator
        videoView.playerObserverDelegate = self
        print(videoView.subviews.count)
        print(self.videoView.subviews.count)
        videoView.translatesAutoresizingMaskIntoConstraints = false
        self.videoView.addSubview(videoView)
        videoView.topAnchor.constraint(equalTo: self.videoView.topAnchor).isActive = true
        videoView.leftAnchor.constraint(equalTo: self.videoView.leftAnchor).isActive = true
        videoView.rightAnchor.constraint(equalTo: self.videoView.rightAnchor).isActive = true
        videoView.bottomAnchor.constraint(equalTo: self.videoView.bottomAnchor).isActive = true
        
        print(self.videoView.subviews.count)
        self.videoView.setNeedsLayout()
        return videoView
    }
    
    private func startPlayer(videoView: IFPlayerView, with url: String) {
        print("Starting to Play")
        print(self.videoView.subviews.count)
        if self.videoView.subviews.count > 0 {
            if story.isWholeStoryViewed == false {
                let videoResource = VideoResourceForCurrentStorySnap(filePath: url)
                debugPrint(videoResource)
                videoView.play(with: videoResource)
            }
        }
    }
    
    private func getVideoView(with index: Int) -> IFPlayerView? {
        print("Starting to get the Video View")
        if let videoView = self.videoView.subviews.filter({$0.tag == index + snapViewTagIndicator}).first as? IFPlayerView {
            print(videoView.subviews.count)
            self.view.setNeedsLayout()
            return videoView
        }
        return nil
    }
}


extension StoryCollectionViewCell: IFPlayerObserver {
    func didStartPlaying() {
        print("startplaying")
        if let videoView = getVideoView(with: snapIndex){
            print("got Viedeo view")
            //let videoView = scrollview.subviews.filter{v in v.tag == snapIndex + snapViewTagIndicator}.first as? IGPlayerView
            if videoView.error == nil  {
                print()
//                if let holderView = getProgressIndicatorView(with: snapIndex),
//                    let progressView = getProgressView(with: snapIndex) {
//                    progressView.story_identifier = self.story?.internalIdentifier
//                    progressView.snapIndex = snapIndex
                    if let duration = videoView.currentItem?.asset.duration {
                        print(duration.value, duration.seconds)
                        if Float(duration.value) > 0 {
                            print("video duratjion: ", Float(duration.value))
                            self.videoDuration = Float(duration.seconds)
//                            progressView.start(with: duration.seconds, width: holderView.frame.width, completion: {(identifier, snapIndex, isCancelledAbruptly) in
//                                if isCancelledAbruptly == false {
//                                    self.videoSnapIndex = snapIndex
//                                    self.stopPlayer()
//                                    self.didCompleteProgress()
//                                } else {
//                                    self.videoSnapIndex = snapIndex
//                                    self.stopPlayer()
//                                }
//                            })
                        }else {
                            debugPrint("Player error: Unable to play the video")
                        }
                    }
                }
            }
        }
    
        
    
    
    func didCompletePlay() {
        self.initTimerProgress()
        self.nextAction()
    }
    
    func didTrack(progress: Float) {
    print(progress)
        self.videoProgressDuration = (progress / videoDuration)
        
    }
    
    func didFailed(withError error: String, for url: URL?) {
        
    }

}

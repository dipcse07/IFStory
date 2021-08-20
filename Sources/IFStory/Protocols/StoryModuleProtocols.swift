//
//  Protocols.swift
//  customStoryTest
//
//  Created by MD SAZID HASAN DIP on 27/6/21.
//

import Foundation

protocol FullScreenSnapDelegate {
   // func currentStoryAndSnap(story: IGStory?, snap: IGSnap?)
    func snapDidAppear(currentSnapInProgress:IFSnap?)
    func snapWillAppear(nextSnap: IFSnap?)
    //func snapWillDisappear()
    func snapDidDisappear(previousSnap: IFSnap?)
    
    func profileImageTapped(userInfo: IFUser?)
    
    func snapClosed(isClosed: Bool, atStroy: IFSingleStory, forStoryIndexPath:IndexPath, forSnap: IFSnap)
    
    func goToPreviousStroy(atStroy: IFSingleStory, forStoryIndexPath:IndexPath, forCell:StoryCollectionViewCell, forSnap: IFSnap)
    
    
}

public protocol FullScreenSotryDelegate {
    func snapDidAppear(currentSnapInProgress:IFSnap?)
    func snapWillAppear(nextSnap: IFSnap?)
    //func snapWillDisappear()
    func snapDidDisappear(previousSnap: IFSnap?)
    
    func profileImageTapped(userInfo: IFUser?)
    
    func snapClosed(atStroy: IFSingleStory, forStoryIndexPath:IndexPath, forSnap: IFSnap)
    
    func storyDidAppear(currentStoryInProgress: IFSingleStory?)
    func storyWillAppear(nextStory: IFSingleStory?)
    func storyDidDisAppear(previousStory: IFSingleStory?)

    
}

//MARK:- For IF Video Player

protocol IFPlayerObserver: AnyObject {
    func didStartPlaying()
    func didCompletePlay()
    func didTrack(progress: Float)
    func didFailed(withError error: String, for url: URL?)
}

protocol PlayerControlsForStoryVideos: AnyObject {
    func play(with resource: VideoResourceForCurrentStorySnap)
    func play()
    func pause()
    func stop()
    var playerStatus: CurrentPlayerStatus { get }
}


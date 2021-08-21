//
//  File.swift
//  
//
//  Created by MD SAZID HASAN DIP on 20/8/21.
//

import Foundation

public class IFStory : NSObject {
    static let bundleName = "IFStory"

    public static let bundle = Bundle(for:IFStory.self)

    /// Returns the resource bundle associated with the current Swift module. This is required for SPM use
    public static var module: Bundle = {
        let bundleName = "IFStory" // May be "MyFramework_MyFramework" for you

        let candidates = [
            // Bundle should be present here when the package is linked into an App.
            Bundle.main.resourceURL,

            // Bundle should be present here when the package is linked into a framework.
            Bundle(for: IFStory.self).resourceURL,

            // For command-line tools.
            Bundle.main.bundleURL
        ]

        for candidate in candidates {
            let bundlePath = candidate?.appendingPathComponent(bundleName + ".bundle")
            if let bundle = bundlePath.flatMap(Bundle.init(url:)) {
                return bundle
            }
        }
        return IFStory.bundle
    }()
}

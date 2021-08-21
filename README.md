# IFStory--Custom Stories like facebook / Instagram

It's a simple library to use story module like facebook/ instagram
## Installation

Go to  [customStory](https:github.com/dipcse07) and download the customModule folder

```bash
Drag and Drop the folder to your project. 
This module will require KingFisher for image caching and downloads
```

## Usage

```Swift

1. Call or Initiate the StoryFullVC and pass the IGStories Data
2. Present it from your respective viewController

let fullStoryVC = StoryFullVC(with: self.stories!, handPickedStoryIndex: 0, delegate: self)//StoryFullScreenViewer.instantiate(with: stories, handPickedStoryIndex: selectedStoryIndex, delegate: self)

self.present(fullStoryVC, animated: true, completion: nil)
```

## Contributing
Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

Please make sure to update tests as appropriate.

## License
[MIT](https://choosealicense.com/licenses/mit/)

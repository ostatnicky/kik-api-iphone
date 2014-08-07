# KikAPI

## Requirements

The KikAPI library supports iOS versions >= 6.0.

## Installation

KikAPI ~~is~~ *will be* available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

    pod "KikAPI"

## Usage

### Launching / Going back to Kik

With this API method, you can easily launch back into the Kik Application.

```
[[KikClient sharedInstance] backToKik];
```

### Opening a Kik User Profile

Use this to open a profile for a Kik username.

```
[[KikClient sharedInstance] openProfileForKikUsername:@"kikteam"];
```

### Sending a Kik Content Message

There are 2 types of content messages that can be sent through Kik: an article-typed content message and a photo-typed content message.

#### Article

To send an article content message, first construct an instance of the ```KikMessage``` object.

```
KikMessage *message = [KikMessage articleMessageWithTitle:@"Title of your Article"
                                                     text:@"Text of your Article"
                                               contentURL:@"http://www.yourcontent.com/thecontent"
                                               previewURL:nil];
```

- One of either ```Title``` or ```text``` must be specified.
- The ```contentURL``` must be specified; and reflects the piece of content you to send through Kik.
- ```previewURL``` is an optional image URL that can be specified to provide a thumbnail preview in the generated content message inside Kik.


#### Photo

Similarly for sending a photo content message, first construct an instance of the ```KikMessage``` object using either of the class constructors.

```
// Create a photo message using imageURLs
KikMessage *message = [KikMessage photoMessageWithImageURL:@"http://www.images.com/image.png"
                                                previewURL:@"http://www.images.com/image_preview.png"];
```

**or**

```
// Create a photo message from an UIImage
UIImage *image = [UIImage imageNamed:@"image.png"];
KikMessage *message = [KikMessage photoMessageWithImage:image];
```

#### Sending It
Once the ```KikMessage``` object has been created, simply send it through the ```KikClient``` object.

```
[[KikClient sharedInstance] sendKikMessage:message];
```

### Other interesting things with KikMessage

#### dataURIs
For any parameter specified that is a URL in the ```KikMessage``` constructors, you can also provide a base64 encoded data URI representing the images.

#### Forwardable
```KikMessage``` objects have a ```forwardable``` property that can be changed to reflect whether or not the content message can be forwarded inside Kik. Defaults to ```YES```.

```
KikMessage *message = [KikMessage photoMessageWithImage:image];
message.forwardable = NO;
```

#### Fallback URLs
With any ```KikMessage``` content message, you can call the

```
- (void)addFallbackURL:(NSString *)fallbackURL
           forPlatform:(KikMessagePlatform)platform;
```

method to add a fallback URL for the conent message. When your content message is opened inside of Kik, if you have any specified fallback URLs that can be handled by the specified platform, the user will be presented with a button inside Kik in the content viewer to open the specified fallback URLs. The clients will show the first URL that is handleable in the list of URIs. 

A good use case of this would be to send a content message that links back to your own application. You could then add 2 fallback URLs to it, the first one being a custom URL that your app knows how to handle, and the second one being a link to your app in the App Store. Clients who open this content message and have your app installed (the first URL is able to be handled), the action button in Kik will let those clients open that URL, and effectively your application. For clients that don't have your App installed, the button instead will fallback to the second link that you provided and open your ITMS or AppStore link.


### Example Project
To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Author

Kik Interactive, dev@kik.com

## License

KikAPI is available under the MIT license. See the LICENSE file for more info.


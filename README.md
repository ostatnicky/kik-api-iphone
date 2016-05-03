# Kik API

## Requirements

The Kik API library for iOS supports iOS versions >= 6.0.

## Installation

You can install the Kik API using [CocoaPods](http://cocoapods.org). To include the library,
simply add the following line to the Podfile in your project:

    pod 'KikAPI'

## Usage

### Opening a Kik User Profile

```objective-c
[[KikClient sharedInstance] openProfileForKikUsername:@"kikteam"];
```

### Sending a Kik Content Message

Two layout styles are available for your content messages: article and photo. You can specify the layout style that
best suits your content when composing the content message to send.

To send a content message using the API you must construct a `KikMessage` object with the parameters of your message
and send it using the `sendKikMessage` method on `KikClient`. The examples in the following sections will show you how
to construct and send article and photo content messages.

#### Article

```objective-c
KikMessage *message = [KikMessage articleMessageWithTitle:@"Title of your Article"
                                                     text:@"Text of your Article"
                                               contentURL:@"http://www.yourcontent.com/thecontent"
                                               previewURL:nil];

[[KikClient sharedInstance] sendKikMessage:message];
```

- One of either ```Title``` or ```text``` must be specified
- The ```contentURL``` must be specified. This is the target URL that will be opened when the user taps on the message in Kik
- ```previewURL``` is an optional image URL that can be specified to provide a thumbnail preview that will be displayed in your message

#### Photo

```objective-c
// Create a photo message using URLs
KikMessage *message = [KikMessage photoMessageWithImageURL:@"http://www.images.com/image.png"
                                                previewURL:@"http://www.images.com/image_preview.png"];

[[KikClient sharedInstance] sendKikMessage:message];
```

When sending an image URL, you can choose to specify a base64-encoded Data URI in place of a standard web URL. In this case, the data will be uploaded
and downloaded from the Kik servers instead of directly accessing the image via the provided web URL. 

Alternatively, you can specify a `UIImage` as the photo to send.

```objective-c
// Create a photo message from an UIImage object
UIImage *image = [UIImage imageNamed:@"image.png"];
KikMessage *message = [KikMessage photoMessageWithImage:image];
```

#### Video

```objective-c
// Create a video message using URLs
KikMessage *message = [KikMessage videoMessageWithVideoURL:@"http://www.videos.com/video.mp4"
                                                previewURL:@"http://www.videos.com/video_preview.png"];

[[KikClient sharedInstance] sendKikMessage:message];
```

Video files should be encoded using H.264 with baseline profile for video and AAC for audio. The container should be mp4. Video files must be no larger than 15mb and no longer than 2 minutes in duration. The provided preview image should match the first frame of the video and have the same aspect ratio as the video.

If a video is marked to autoplay using the `videoShouldAutoplay` property, it must be no larger than 1mb. Developers are encouraged to test that their video content plays back reliably on a range of iOS and Android devices. 

Alternatively, you can specify an `NSData` object containing the video data to send. In this case, the data will be uploaded to and hosted on the Kik servers.

```objective-c
// Create a video message from an NSData object
NSString *videoPath = [[NSBundle mainBundle] pathForResource:@"video"
													  ofType:@"mp4"]; 
NSURL *videoURL = [NSURL fileURLWithPath:videoPath];
NSData *videoData = [NSData dataWithContentsOfURL:videoURL];
KikMessage *message = [KikMessage videoMessageWithData:videoData];
```

##### Video Message Attributes

###### Looping
If the `videoShouldLoop` property is set to `YES`, the video will loop when played back. In other words, when playback reaches the end of the video it will start again at the beginning. The default value for `videoShouldLoop` is `NO`.

###### Muted
If the `videoShouldBeMuted` property is set to `YES`, the video will be played with the audio track muted. In the case that `videoShouldAutoplay` is set to `YES`, no unmute button will be shown. The default value for `videoShouldBeMuted` is `NO`.

###### Autoplay
If the `videoShouldAutoplay` property is set to `YES`, the video will start playing automatically when it appears in a chat. The video will be muted by default with an unmute button provided to the user. When the unmute button is tapped, playback will restart from the beginning of the video with audio enabled. If the `videoShouldBeMuted` property is set to `YES`, the unmute button will not be shown. If `videoShouldAutoplay` is set to `YES` the attached or linked video data must be less than 1mb. The default value for `videoShouldAutoplay` is `NO`.


```objective-c
...
message.videoShouldLoop = YES;
message.videoShouldAutoplay = YES;
message.videoShouldBeMuted = YES;
```

### Other Message Attributes

#### Forwardable

If you do not want to allow a user to forward a particular content message on to a friend you can set the `forwardable` attribute on a `KikMessage` to `NO`. The default value for `forwardable` is `YES`.

```objective-c
...
message.forwardable = NO;
```

#### Disallow Saving

If you do not want to allow a user to save a particular photo or video message you can set the `disallowSave` attribute on a `KikMessage` to `YES`. The default value for `disallowSave` is `NO`.

```objective-c
...
message.disallowSave = YES;
```

#### Fallback URLs

With any content message, you can specify fallback URLs. When the user opens your content message, Kik will check your fallback URLs to see which URL is supported on the current platform and display a link to the user which will allow them to navigate to that URL.

A fallback URL can be any type of URL whether it is a link to a website (ie. `http://kik.com`) or a specialized scheme for a native app (ie. `kik://users/kikteam/profile`).

If your app supports both Android and iOS, you can add a link to the native scheme which would open your app on each respective platform. Also, if your app is not installed, Kik will detect that your native scheme is not handled. If this is the case, the next fallback URL in order will be presented to the user. This is an opportunity to add another fallback URL linking to the AppStore with an ITMS link or the Google Play Store with a web link.

```objective-c
- (void)addFallbackURL:(NSString *)fallbackURL
           forPlatform:(KikMessagePlatform)platform;
```

##### Example

```objective-c
...
// launch the app first if available
[message addFallbackURL:@"test-iphone://api/launch" forPlatform:KikMessagePlatformiPhone];
[message addFallbackURL:@"test-android://api/launch" forPlatform:KikMessagePlatformAndroid];

// fallback to launching the app store on the given platform
[message addFallbackURL:@"itms-apps://itunes.apple.com/ca/app/kik/id357218860?mt=8" forPlatform:KikMessagePlatformiPhone];
[message addFallbackURL:@"https://play.google.com/store/apps/details?id=kik.android&hl=en" forPlatform:KikMessagePlatformAndroid];
```

### Returning to Kik After Opening Content

When the user taps your content from within Kik and launches your app, they will want to return to Kik to continue their chat. From within your app, use the `backToKik` method to return the user to their active chat once they have viewed the content in your app.

```objective-c
[[KikClient sharedInstance] backToKik];
```

### Example Project

To run the example project, clone the repo, and run `pod install` from the "Example" directory first.

## Author

Kik Interactive, Inc.

## License

Use of the Kik API is subject to the Terms & Conditions and the Acceptable Use Policy. See TERMS.md for details.

The source for KikAPI is available under the Apache 2.0 license. See the LICENSE.md file for details.


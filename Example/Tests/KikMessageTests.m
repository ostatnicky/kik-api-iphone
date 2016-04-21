//
//  KikMessageTests.m
//  KikAPITests
//
//  Created by Anthony Wong on 08/05/2014.
//  Copyright (c) 2014 Anthony Wong. All rights reserved.
//

#import <KikAPI/KikMessage.h>

SpecBegin(KikMessageSpecs)

describe(@"article send", ^{
    
    it(@"can make an article with just a title", ^{
        KikMessage *message = [KikMessage articleMessageWithTitle:@"Some Title"
                                                             text:nil
                                                       contentURL:@"http://kik.com"
                                                       previewURL:@"http://i.imgur.com/v753u3H.jpg"];
        
        expect(message).toNot.beNil();
    });
    
    it(@"can make an article with just text", ^{
        KikMessage *message = [KikMessage articleMessageWithTitle:nil
                                                             text:@"Some Text"
                                                       contentURL:@"http://kik.com"
                                                       previewURL:@"http://i.imgur.com/v753u3H.jpg"];
        
        expect(message).toNot.beNil();
    });
    
    it (@"can't make an article without a content URL", ^{
        KikMessage *message = [KikMessage articleMessageWithTitle:@"Some Title"
                                                             text:@"Some Text"
                                                       contentURL:nil
                                                       previewURL:@"http://i.imgur.com/v753u3H.jpg"];
        
        expect(message).to.beNil();
    });
    
    it (@"can add a fallback urls", ^{
        KikMessage *message = [KikMessage articleMessageWithTitle:@"Some Title"
                                                             text:@"Some Text"
                                                       contentURL:@"http://kik.com"
                                                       previewURL:@"http://i.imgur.com/v753u3H.jpg"];
        
        expect(message.URLs.count).to.equal(1);
        
        [message addFallbackURL:@"http://google.ca" forPlatform:KikMessagePlatformGeneric];
        
        expect(message.URLs.count).to.equal(2);
        expect([message.URLs lastObject][@"value"]).to.equal(@"http://google.ca");
        
        [message addFallbackURL:@"http://android.com" forPlatform:KikMessagePlatformAndroid];
        
        expect(message.URLs.count).to.equal(3);
        expect([message.URLs lastObject][@"platform"]).to.equal(@"android");
        expect([message.URLs lastObject][@"value"]).to.equal(@"http://android.com");
    });
    
});

describe(@"photo send", ^{
    it(@"can make a photo with all urls", ^{
        KikMessage *message = [KikMessage photoMessageWithImageURL:@"http://i.imgur.com/v753u3H.jpg"
                                                        previewURL:@"http://i.imgur.com/v753u3H.jpg"];
        
        expect(message).toNot.beNil();
    });
    
    it (@"can make a photo with all data URIs", ^{
        
        NSString *dataURI = @"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAoAAAAKCAYAAACNMs+9AAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAAyRpVFh0WE1MOmNvbS5hZG9iZS54bXAAAAAAADw/eHBhY2tldCBiZWdpbj0i77u/IiBpZD0iVzVNME1wQ2VoaUh6cmVTek5UY3prYzlkIj8+IDx4OnhtcG1ldGEgeG1sbnM6eD0iYWRvYmU6bnM6bWV0YS8iIHg6eG1wdGs9IkFkb2JlIFhNUCBDb3JlIDUuMy1jMDExIDY2LjE0NTY2MSwgMjAxMi8wMi8wNi0xNDo1NjoyNyAgICAgICAgIj4gPHJkZjpSREYgeG1sbnM6cmRmPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5LzAyLzIyLXJkZi1zeW50YXgtbnMjIj4gPHJkZjpEZXNjcmlwdGlvbiByZGY6YWJvdXQ9IiIgeG1sbnM6eG1wPSJodHRwOi8vbnMuYWRvYmUuY29tL3hhcC8xLjAvIiB4bWxuczp4bXBNTT0iaHR0cDovL25zLmFkb2JlLmNvbS94YXAvMS4wL21tLyIgeG1sbnM6c3RSZWY9Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC9zVHlwZS9SZXNvdXJjZVJlZiMiIHhtcDpDcmVhdG9yVG9vbD0iQWRvYmUgUGhvdG9zaG9wIENTNiAoTWFjaW50b3NoKSIgeG1wTU06SW5zdGFuY2VJRD0ieG1wLmlpZDoyNTdFNTVGOTE1MjQxMUU0OUIzREI4MTgxN0VGMURFRCIgeG1wTU06RG9jdW1lbnRJRD0ieG1wLmRpZDoyNTdFNTVGQTE1MjQxMUU0OUIzREI4MTgxN0VGMURFRCI+IDx4bXBNTTpEZXJpdmVkRnJvbSBzdFJlZjppbnN0YW5jZUlEPSJ4bXAuaWlkOjI1N0U1NUY3MTUyNDExRTQ5QjNEQjgxODE3RUYxREVEIiBzdFJlZjpkb2N1bWVudElEPSJ4bXAuZGlkOjI1N0U1NUY4MTUyNDExRTQ5QjNEQjgxODE3RUYxREVEIi8+IDwvcmRmOkRlc2NyaXB0aW9uPiA8L3JkZjpSREY+IDwveDp4bXBtZXRhPiA8P3hwYWNrZXQgZW5kPSJyIj8+2eGfewAAADVJREFUeNpi/P//PwMxgAVMMjLiV/3/PyMTA5GABV0nCh/JJqJNpL5CFlxuIttERmIDHCDAANmADRTWM3mhAAAAAElFTkSuQmCC";
        
        KikMessage *message = [KikMessage photoMessageWithImageURL:dataURI previewURL:dataURI];
        
        expect(message).toNot.beNil();
    });
    
    it(@"can't make a photo with missing image url", ^{
        KikMessage *message = [KikMessage photoMessageWithImageURL:nil
                                                        previewURL:@"http://i.imgur.com/v753u3H.jpg"];
        
        expect(message).to.beNil();
    });
    
    it(@"can't make a photo with missing preview url", ^{
        KikMessage *message = [KikMessage photoMessageWithImageURL:@"http://i.imgur.com/v753u3H.jpg"
                                                        previewURL:nil];
        
        expect(message).to.beNil();
    });
    
});

describe(@"Video send", ^{
    
    it(@"Can create video message with URLS", ^{
        KikMessage *message = [KikMessage videoMessageWithVideoURL:@"http://clips.vorwaerts-gmbh.de/VfE_html5.mp4"
                                                        previewURL:@"http://i.imgur.com/v753u3H.jpg"];
        
        expect(message).toNot.beNil();
    });
    
    it(@"Can't create video message without a video URL", ^{
        KikMessage *message = [KikMessage videoMessageWithVideoURL:nil
                                                        previewURL:@"http://i.imgur.com/v753u3H.jpg"];
        
        expect(message).to.beNil();
    });
    
    it(@"Can't create video message without a preview URL", ^{
        KikMessage *message = [KikMessage videoMessageWithVideoURL:@"http://clips.vorwaerts-gmbh.de/VfE_html5.mp4"
                                                        previewURL:nil];
        
        expect(message).to.beNil();
    });
    
});
SpecEnd

#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>

@interface DHSwipeIndicator : NSView {
    NSMutableDictionary *twoFingersTouches;
    CGFloat currentSum;
    NSTimer *drawTimer;
    WebView *webView;
    BOOL canGoLeft;
    BOOL canGoRight;
}

@property (retain) NSMutableDictionary *twoFingersTouches;
@property (retain) NSTimer *drawTimer;
@property (retain) WebView *webView;

- (id)initWithWebView:(WebView *)aWebView;

@end

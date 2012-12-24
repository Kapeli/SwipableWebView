#import <WebKit/WebKit.h>

@class DHSwipeIndicator;

@interface DHSwipeWebView : WebView {
    DHSwipeIndicator *swipeIndicator;
    NSMutableDictionary *twoFingersTouches;
    CGFloat currentSum;
    NSTimer *drawTimer;
    BOOL canGoLeft;
    BOOL canGoRight;
}

@property (retain) DHSwipeIndicator *swipeIndicator;
@property (retain) NSMutableDictionary *twoFingersTouches;
@property (retain) NSTimer *drawTimer;
@property (assign) CGFloat currentSum;

@end

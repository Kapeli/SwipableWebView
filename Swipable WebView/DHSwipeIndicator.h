#import <Cocoa/Cocoa.h>
#import "DHSwipeWebView.h"

@interface DHSwipeIndicator : NSView {
    DHSwipeWebView *webView;
}

@property (retain) DHSwipeWebView *webView;

- (id)initWithWebView:(DHSwipeWebView *)aWebView;

@end

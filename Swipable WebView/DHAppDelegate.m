#import "DHAppDelegate.h"
#import "DHSwipeIndicator.h"

@implementation DHAppDelegate

@synthesize webView;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    [[DHSwipeIndicator alloc] initWithWebView:webView];



    [[webView mainFrame] loadHTMLString:[NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"page" ofType:@"html"] encoding:NSUTF8StringEncoding error:nil] baseURL:nil];

}

@end

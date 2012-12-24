#import "DHSwipeWebView.h"
#import "DHSwipeIndicator.h"

@implementation DHSwipeWebView

@synthesize swipeIndicator;
@synthesize twoFingersTouches;
@synthesize drawTimer;
@synthesize currentSum;

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setAcceptsTouchEvents:YES];
    self.swipeIndicator = [[[DHSwipeIndicator alloc] initWithWebView:self] autorelease];
}

- (BOOL)recognizeTwoFingerGestures
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    return [defaults boolForKey:@"AppleEnableSwipeNavigateWithScrolls"];
}

- (void)beginGestureWithEvent:(NSEvent *)event
{
    if(![self recognizeTwoFingerGestures])
    {
        return;
    }
    currentSum = 0;
    NSScrollView *scrollView = [[[[self mainFrame] frameView] documentView] enclosingScrollView];
    NSRect bounds = [[scrollView contentView] bounds];
    canGoLeft = canGoRight = NO;
    if(bounds.origin.x <= 0)
    {
        canGoLeft = YES;
    }
    if(bounds.origin.x + bounds.size.width >= [[scrollView documentView] bounds].size.width)
    {
        canGoRight = YES;
    }
    if(canGoLeft || canGoRight)
    {
        NSSet *touches = [event touchesMatchingPhase:NSTouchPhaseAny inView:nil];
        self.twoFingersTouches = [[[NSMutableDictionary alloc] init] autorelease];
        for(NSTouch *touch in touches)
        {
            [twoFingersTouches setObject:touch forKey:touch.identity];
        }
    }
}

- (void)touchesMovedWithEvent:(NSEvent *)event
{
    if(twoFingersTouches)
    {
        [self handleTwoFingerGesture:event];
    }
}

- (void)handleTwoFingerGesture:(NSEvent *)event
{
    if(!twoFingersTouches)
    {
        if(currentSum != 0)
        {
            currentSum = 0;
            [self launchDrawTimer];
        }
        return;
    }
    
    NSSet *touches = [event touchesMatchingPhase:NSTouchPhaseAny inView:nil];
    CGFloat sumX = 0;
    CGFloat sumY = 0;
    NSInteger magnitudeCount = 0;
    for(NSTouch *touch in touches)
    {
        NSTouch *beginTouch = [twoFingersTouches objectForKey:touch.identity];
        if(!beginTouch)
        {
            continue;
        }
        sumX += touch.normalizedPosition.x - beginTouch.normalizedPosition.x;
        sumY += touch.normalizedPosition.y - beginTouch.normalizedPosition.y;
        ++magnitudeCount;
    }
    
    float absoluteSumX = fabsf(sumX);
    float absoluteSumY = fabsf(sumY);
    if(magnitudeCount != 2 || (absoluteSumX < absoluteSumY && currentSum == 0))
    {
        self.twoFingersTouches = nil;
        if(currentSum != 0)
        {
            currentSum = 0;
            [self launchDrawTimer];
        }
        return;
    }
    
    // Handle natural direction in Lion
    BOOL naturalDirectionEnabled = [[[NSUserDefaults standardUserDefaults] valueForKey:@"com.apple.swipescrolldirection"] boolValue];
    
    if(naturalDirectionEnabled)
    {
        sumX *= -1;
    }
    
    if(sumX == 0 || (sumX < 0 && !canGoLeft) || (sumX > 0 && !canGoRight))
    {
        if(currentSum != 0)
        {
            currentSum = 0;
            [self launchDrawTimer];
        }
        return;
    }
    
    [[[self mainFrame] frameView] setAllowsScrolling:NO];
    // Draw the back/forward indicators
    currentSum = sumX;
    [self launchDrawTimer];
}

- (void)endGestureWithEvent:(NSEvent *)event
{
    if(currentSum < -0.3 && canGoLeft)
    {
        NSLog(@"go back");
    }
    else if(currentSum >= 0.3 && canGoRight)
    {
        NSLog(@"go forward");
    }
    self.twoFingersTouches = nil;
    currentSum = 0;
    [self launchDrawTimer];
}

- (void)launchDrawTimer
{
    // a timer is needed because events are queued and processing and drawing
    // takes longer than they are delivered, so the queue fills up
    if(!drawTimer || ![drawTimer isValid])
    {
        self.drawTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f/25 target:swipeIndicator selector:@selector(display) userInfo:nil repeats:NO];
    }
}

@end

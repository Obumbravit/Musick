//Musick ~ Obumbravit

@import UIKit;
#import "MediaRemote.h"
#import "Classes/FauxNowPlayingTransportButton.h"
#import "Prefs.h"

@interface ControlStackView
@property (nonatomic, assign) BOOL fullStack;
- (void)setSpacing:(double)arg1;
@end

@interface PlayerTimeControl
@property CGFloat accessibilityElapsedDuration;
@end

static double mediaSliderValue;

%hook ControlStackView
%property (nonatomic, assign) BOOL fullStack;

- (id)initWithArrangedSubviews:(id)arg1
{
  NSMutableArray * mutableArray = [[NSMutableArray alloc] init];
  BOOL iOS14 = ([[[UIDevice currentDevice] systemVersion] floatValue] >= 14.0);
  CGFloat sizeConstraintConstant = 22 + (12 * ([[UIScreen mainScreen] scale] - 1));

  FauxNowPlayingTransportButton * rewindButton = [FauxNowPlayingTransportButton buttonWithType:UIButtonTypeRoundedRect];
  [rewindButton.widthAnchor constraintEqualToConstant:sizeConstraintConstant].active = YES;
  [rewindButton.heightAnchor constraintEqualToConstant:sizeConstraintConstant].active = YES;
  [rewindButton setImage:[UIImage systemImageNamed:[NSString stringWithFormat:@"gobackward.%@", [@(rewindValue) stringValue]]] forState:UIControlStateNormal];
  [rewindButton setTintColor:(iOS14) ? [UIColor whiteColor] : [UIColor systemRedColor]];
  [rewindButton handleControlEvent:UIControlEventTouchUpInside withBlock:^{
    MRMediaRemoteSetElapsedTime(mediaSliderValue - rewindValue);
  }];
  [mutableArray addObject:rewindButton];

  [mutableArray addObjectsFromArray:arg1];

  FauxNowPlayingTransportButton * skipButton = [FauxNowPlayingTransportButton buttonWithType:UIButtonTypeRoundedRect];
  [skipButton.widthAnchor constraintEqualToConstant:sizeConstraintConstant].active = YES;
  [skipButton.heightAnchor constraintEqualToConstant:sizeConstraintConstant].active = YES;
  [skipButton setImage:[UIImage systemImageNamed:[NSString stringWithFormat:@"goforward.%@", [@(fastForwardValue) stringValue]]] forState:UIControlStateNormal];
  [skipButton setTintColor:(iOS14) ? [UIColor whiteColor] : [UIColor systemRedColor]];
  [skipButton handleControlEvent:UIControlEventTouchUpInside withBlock:^{
    MRMediaRemoteSetElapsedTime(mediaSliderValue + fastForwardValue);
  }];
  [mutableArray addObject:skipButton];

  ControlStackView * slef = self;
  if ([mutableArray count] == 5)
  {
    slef.fullStack = YES;
    return %orig(mutableArray);
  }
  else
  {
    slef.fullStack = NO;
    return %orig(arg1);
  }
}

- (void)setSpacing:(double)arg1
{
  ControlStackView * slef = self;
  if (!slef.fullStack) return %orig(arg1);

  CGFloat sizeConstraintConstant = 22 + (12 * ([[UIScreen mainScreen] scale] - 1));

  double x = (sizeConstraintConstant * 3) + (arg1 * 2);
  double y = x - (sizeConstraintConstant * 5);

  %orig(y);
}

%end

%hook PlayerTimeControl

- (void)layoutSubviews
{
  %orig();

  PlayerTimeControl * slef = self;
  mediaSliderValue = slef.accessibilityElapsedDuration;
}

%end

%ctor
{
  notificationCallback();
  if (musickEnabled) %init(ControlStackView = objc_getClass("MusicApplication.NowPlayingTransportControlStackView"), PlayerTimeControl = objc_getClass("MusicApplication.PlayerTimeControl"));
}

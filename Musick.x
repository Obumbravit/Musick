//Musick ~ Obumbravit

@import UIKit;
#import "MediaRemote.h"
#import "Classes/FauxNowPlayingTransportButton.h"

@interface ControlStackView
- (void)setSpacing:(double)arg1;
@end

@interface PlayerTimeControl
@property CGFloat accessibilityElapsedDuration;
@end

static double mediaSliderValue;

%hook ControlStackView

- (id)initWithArrangedSubviews:(id)arg1
{
  NSMutableArray * mutableArray = [[NSMutableArray alloc] init];

  FauxNowPlayingTransportButton * rewindButton = [FauxNowPlayingTransportButton buttonWithType:UIButtonTypeRoundedRect];
  rewindButton.frame = CGRectMake(
    0,
    0,
    46,
    46
  );
  [rewindButton setImage:[UIImage systemImageNamed:@"gobackward.15"] forState:UIControlStateNormal];
  [rewindButton setTintColor:[UIColor systemRedColor]];
  [rewindButton handleControlEvent:UIControlEventTouchUpInside withBlock:^{
    MRMediaRemoteSetElapsedTime(mediaSliderValue - 15);
  }];
  [mutableArray addObject:rewindButton];

  [mutableArray addObjectsFromArray:arg1];

  FauxNowPlayingTransportButton * skipButton = [FauxNowPlayingTransportButton buttonWithType:UIButtonTypeRoundedRect];
  skipButton.frame = CGRectMake(
    0,
    0,
    46,
    46
  );
  [skipButton setImage:[UIImage systemImageNamed:@"goforward.15"] forState:UIControlStateNormal];
  [skipButton setTintColor:[UIColor systemRedColor]];
  [skipButton handleControlEvent:UIControlEventTouchUpInside withBlock:^{
    MRMediaRemoteSetElapsedTime(mediaSliderValue + 15);
  }];
  [mutableArray addObject:skipButton];

  return %orig(mutableArray);
}

- (void)setSpacing:(double)arg1
{
  %orig((double)(arg1 / 1.83333333333));
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
    %init(ControlStackView = objc_getClass("MusicApplication.NowPlayingTransportControlStackView"), PlayerTimeControl = objc_getClass("MusicApplication.PlayerTimeControl"));
}

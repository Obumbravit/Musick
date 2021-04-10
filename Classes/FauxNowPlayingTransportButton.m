#import "FauxNowPlayingTransportButton.h"

@implementation FauxNowPlayingTransportButton

- (void)handleControlEvent:(UIControlEvents)event withBlock:(ActionBlock) action
{
  _actionBlock = action;
  [self addTarget:self action:@selector(callActionBlock:) forControlEvents:event];
}

- (void)callActionBlock:(id)sender
{
    _actionBlock();
}

@end

typedef void (^ActionBlock)();

@interface FauxNowPlayingTransportButton : UIButton
{
  ActionBlock _actionBlock;
}
- (void)handleControlEvent:(UIControlEvents)event withBlock:(ActionBlock)action;
@end

#define PLIST_PATH "/var/mobile/Library/Preferences/com.obumbravit.musick.plist"

static BOOL musickEnabled;
static int rewindValue;
static int fastForwardValue;

static void notificationCallback()
{
  NSDictionary * prefs = [[NSMutableDictionary alloc] initWithContentsOfFile:@PLIST_PATH] ?: [@{} mutableCopy];

  NSNumber * musickEnabledd = [prefs objectForKey:@"musickEnabled"];
  musickEnabled = (musickEnabledd) ? [musickEnabledd boolValue] : YES;
  int rewindValuee = [[prefs objectForKey:@"rewindValue"] intValue];
  rewindValue = (rewindValuee) ? rewindValuee : 15;
  int fastForwardValuee = [[prefs objectForKey:@"fastForwardValue"] intValue];
  fastForwardValue = (fastForwardValuee) ? fastForwardValuee : 15;
}

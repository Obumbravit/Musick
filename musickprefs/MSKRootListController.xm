#import <UIKit/UIKit.h>
#import <spawn.h>

#include "MSKRootListController.h"

#define HEADER_IMAGE_PATH "/Library/PreferenceBundles/musickprefs.bundle/MusickFull.png"

@implementation MSKRootListController

- (NSArray *)specifiers
{
	if (!_specifiers) _specifiers = [self loadSpecifiersFromPlistName:@"Root" target:self];
	return _specifiers;
}

- (id)init
{
  	self = [super init];
  	if (self) self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Apply" style:UIBarButtonItemStylePlain target:self action:@selector(apply)];
  	return self;
}

static void killProcess(const char * name)
{
	pid_t pid;
	const char * args[] = {
    "killall",
    "-9",
    name,
    NULL
  };
	posix_spawn(
    &pid,
    "/usr/bin/killall",
    NULL,
    NULL,
    (char * const*)args,
    NULL
  );
}

static void relaunchMusicApp()
{
	SBApplicationController * sbac = [%c(SBApplicationController) sharedInstance];
	SBApplication * sbapp = [sbac applicationWithBundleIdentifier:@"com.apple.Music"];

	[sbac applicationService:[%c(FBUIApplicationService) sharedInstance] suspendApplicationWithBundleIdentifier:@"com.apple.Music"];

	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^(void)
  {
		killProcess("Music");

		[[%c(SBUIController) sharedInstance] performSelector:@selector(activateApplication:) withObject:sbapp afterDelay:1.0];
	});
}

- (void)apply
{
	[self.view endEditing:YES];
	UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Settings Applied!"
    message:@"The Music app will now be restarted.\nPlease allow a few seconds for changes to apply after dismissal."
    preferredStyle:UIAlertControllerStyleAlert];

	UIAlertAction * defaultAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
  {
		relaunchMusicApp();
	}];

	[alert addAction:defaultAction];
	[self presentViewController:alert animated:YES completion:nil];
}

- (void)twitter
{
	NSURL *url;
	if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tweetbot:"]]) url = [NSURL URLWithString:@"tweetbot:///user_profile/Obumbravit"];
	else if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"twitterrific:"]]) url = [NSURL URLWithString:@"twitterrific:///profile?screen_name=Obumbravit"];
	else if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tweetings:"]]) url = [NSURL URLWithString:@"tweetings:///user?screen_name=Obumbravit"];
	else if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"twitter:"]]) url = [NSURL URLWithString:@"twitter://user?screen_name=Obumbravit"];
	else url = [NSURL URLWithString:@"https://mobile.twitter.com/Obumbravit"];
	[[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
}

- (void)kofi
{
	NSURL *url;
	if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"kofi:"]]) url = [NSURL URLWithString:@"https://ko-fi.com/obumbravit"];
	else url = [NSURL URLWithString:@"https://ko-fi.com/obumbravit"];
	[[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
}

@end

@implementation MSKHeader

- (id)initWithSpecifier:(PSSpecifier *)specifier
{
	self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell" specifier:specifier];
	if (self)
	{
		icon = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:@HEADER_IMAGE_PATH]];
		icon.frame = CGRectMake(
			([UIScreen mainScreen].bounds.size.width - 125) / 2,
			0,
			125,
			125
		);
    icon.userInteractionEnabled = YES;

		iconTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(iconTapped:)];
		iconTapRecognizer.numberOfTapsRequired = 1;

		[icon addGestureRecognizer:iconTapRecognizer];

		[self addSubview:icon];
	}
	return self;
}

- (void)iconTapped:(id)sender
{
	UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Musick"
		message:@"Musick was a request by the very kind\nu/bobtheboffin!"
		preferredStyle:UIAlertControllerStyleAlert];

	UIAlertAction * defaultAction = [UIAlertAction actionWithTitle:@"Cool!" style:UIAlertActionStyleDefault handler:nil];

	[alert addAction:defaultAction];

	UIWindow * currentwindow = [[[UIApplication sharedApplication] windows] objectAtIndex:0];
	[currentwindow.rootViewController presentViewController:alert animated:YES completion:nil];
}

- (CGFloat)preferredHeightForWidth:(CGFloat)width
{
	return 125.f;
}

@end

#import <Preferences/PSListController.h>
#import <Preferences/PSTableCell.h>

@interface SBApplication : NSObject
@end

@interface SBApplicationController : NSObject
+ (id)sharedInstance;
- (id)applicationWithBundleIdentifier:(id)arg1;
- (void)applicationService:(id)arg1 suspendApplicationWithBundleIdentifier:(id)arg2;
@end

@interface MSKRootListController : PSListController
@end

@interface MSKHeader : PSTableCell
{
	UIImageView * icon;
  UITapGestureRecognizer * iconTapRecognizer;
}
@end

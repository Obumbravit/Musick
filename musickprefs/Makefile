include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = musickprefs
musickprefs_FILES = MSKRootListController.xm
musickprefs_FRAMEWORKS = UIKit
musickprefs_PRIVATE_FRAMEWORKS = Preferences
musickprefs_INSTALL_PATH = /Library/PreferenceBundles
musickprefs_CFLAGS = -fobjc-arc

include $(THEOS)/makefiles/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/musickprefs.plist$(ECHO_END)

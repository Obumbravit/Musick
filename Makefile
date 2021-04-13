export THEOS = /var/theos
export ARCHS = arm64 arm64e

DEBUG = 0
FINALPACKAGE = 1

INSTALL_TARGET_PROCESSES = SpringBoard
TARGET_IPHONEOS_DEPLOYMENT_VERSION = 13.3

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = Musick
Musick_FILES = Musick.x Classes/FauxNowPlayingTransportButton.m
Musick_FRAMEWORKS = UIKit
Musick_PRIVATE_FRAMEWORKS = MediaRemote
Musick_CFLAGS = -fobjc-arc

include $(THEOS)/makefiles/tweak.mk
SUBPROJECTS += musickprefs
include $(THEOS)/makefiles/aggregate.mk

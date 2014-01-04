ARCHS = armv7 arm64
include theos/makefiles/common.mk

TWEAK_NAME = NewTabSearch
NewTabSearch_FILES = Tweak.xm

include $(THEOS_MAKE_PATH)/tweak.mk

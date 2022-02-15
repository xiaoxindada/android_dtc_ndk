LOCAL_PATH := $(call my-dir)

APP_ABI          := armeabi-v7a arm64-v8a x86 x86_64
APP_CFLAGS       := -Wall -O2 -flto
APP_CFLAGS       += -Wno-sign-compare -Wno-missing-field-initializers -Wno-unused-parameter -DNO_YAML
APP_LDFLAGS      := -O2 -flto
APP_STL          := none
APP_PLATFORM     := android-24 # Android 7.0
APP_STRIP_MODE   := --strip-all

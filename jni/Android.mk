LOCAL_PATH := $(call my-dir)

################
# STATIC LIBS
################
include $(CLEAR_VARS)

LOCAL_MODULE := libfdt
LOCAL_C_INCLUDES := $(LOCAL_PATH)/dtc/libfdt
LOCAL_SRC_FILES := \
        dtc/libfdt/fdt.c \
        dtc/libfdt/fdt_check.c \
        dtc/libfdt/fdt_ro.c \
        dtc/libfdt/fdt_wip.c \
        dtc/libfdt/fdt_sw.c \
        dtc/libfdt/fdt_rw.c \
        dtc/libfdt/fdt_strerror.c \
        dtc/libfdt/fdt_empty_tree.c \
        dtc/libfdt/fdt_addresses.c \
        dtc/libfdt/fdt_overlay.c \
        dtc/libfdt/acpi.c

include $(BUILD_STATIC_LIBRARY)

include $(CLEAR_VARS)

LOCAL_MODULE := libufdt_sysdeps
LOCAL_C_INCLUDES := \
     $(LOCAL_PATH)/libufdt/libufdt_sysdeps/include \
     $(LOCAL_PATH)/libufdt/include \
     $(LOCAL_PATH)/dtc/libfdt \
     $(LOCAL_PATH)/libufdt

LOCAL_EXPORT_C_INCLUDES := \
    $(LOCAL_PATH)/libufdt/libufdt_sysdeps/include

LOCAL_SRC_FILES := \
    libufdt/sysdeps/libufdt_sysdeps_posix.c

include $(BUILD_STATIC_LIBRARY)

################
# EXECUTABLES
################
include $(CLEAR_VARS)

LOCAL_MODULE := dtc_static
LOCAL_C_INCLUDES := $(LOCAL_PATH)/dtc/libfdt
LOCAL_STATIC_LIBRARIES := libfdt
LOCAL_SRC_FILES := \
        dtc/checks.c \
        dtc/data.c \
        dtc/dtc.c \
        dtc/dtc-lexer.lex.c \
        dtc/dtc-parser.tab.c \
        dtc/flattree.c \
        dtc/fstree.c \
        dtc/livetree.c \
        dtc/srcpos.c \
        dtc/treesource.c \
        dtc/util.c
        
LOCAL_LDFLAGS := -static 
include $(BUILD_EXECUTABLE)

include $(CLEAR_VARS)

LOCAL_MODULE := mkdtimg_static
LOCAL_C_INCLUDES := \
    $(LOCAL_PATH)/libufdt \
    $(LOCAL_PATH)/libufdt/utils/src \
    $(LOCAL_PATH)/libufdt/libufdt_sysdeps/include \
    $(LOCAL_PATH)/libufdt/include \
    $(LOCAL_PATH)/dtc/libfdt
    
LOCAL_STATIC_LIBRARIES := libfdt libufdt_sysdeps
LOCAL_SRC_FILES := \
        libufdt/utils/src/mkdtimg.c \
        libufdt/utils/src/mkdtimg_cfg_create.c \
        libufdt/utils/src/mkdtimg_core.c \
        libufdt/utils/src/mkdtimg_create.c \
        libufdt/utils/src/mkdtimg_dump.c \
        libufdt/utils/src/dt_table.c
        
LOCAL_LDFLAGS := -static 
include $(BUILD_EXECUTABLE)


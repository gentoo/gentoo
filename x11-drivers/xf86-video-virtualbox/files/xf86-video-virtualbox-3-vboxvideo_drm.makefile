#
# VirtualBox Guest Additions Module Makefile.
#
# (For 2.6.x this file must be 'Makefile'!)
#
# Copyright (C) 2006-2007 Sun Microsystems, Inc.
#
# This file is part of VirtualBox Open Source Edition (OSE), as
# available from http://www.virtualbox.org. This file is free software;
# you can redistribute it and/or modify it under the terms of the GNU
# General Public License (GPL) as published by the Free Software
# Foundation, in version 2 as it comes in the "COPYING" file of the
# VirtualBox OSE distribution. VirtualBox OSE is distributed in the
# hope that it will be useful, but WITHOUT ANY WARRANTY of any kind.
#
# Please contact Sun Microsystems, Inc., 4150 Network Circle, Santa
# Clara, CA 95054 USA or visit http://www.sun.com if you need
# additional information or have any questions.
#

## @todo We must make this into a common template *soon*.

#
# First, figure out which architecture we're targeting and the build type.
# (We have to support basic cross building (ARCH=i386|x86_64).)
# While at it, warn about BUILD_* vars found to help with user problems.
#
ifeq ($(filter-out x86_64 amd64 AMD64,$(shell uname -m)),)
 BUILD_TARGET_ARCH_DEF := amd64
else
 BUILD_TARGET_ARCH_DEF := x86
endif
ifneq ($(filter-out amd64 x86,$(BUILD_TARGET_ARCH)),)
 $(warning Ignoring unknown BUILD_TARGET_ARCH value '$(BUILD_TARGET_ARCH)'.)
 BUILD_TARGET_ARCH :=
endif
ifeq ($(BUILD_TARGET_ARCH),)
 ifeq ($(ARCH),x86_64)
  BUILD_TARGET_ARCH := amd64
 else
  ifeq ($(ARCH),i386)
   BUILD_TARGET_ARCH := x86
  else
   BUILD_TARGET_ARCH := $(BUILD_TARGET_ARCH_DEF)
  endif
 endif
else
 ifneq ($(BUILD_TARGET_ARCH),$(BUILD_TARGET_ARCH_DEF))
  $(warning Using BUILD_TARGET_ARCH='$(BUILD_TARGET_ARCH)' from the $(origin BUILD_TARGET_ARCH).)
 endif
endif

ifneq ($(filter-out release profile debug strict,$(BUILD_TYPE)),)
 $(warning Ignoring unknown BUILD_TYPE value '$(BUILD_TYPE)'.)
 BUILD_TYPE :=
endif
ifeq ($(BUILD_TYPE),)
 BUILD_TYPE := release
else
 ifneq ($(BUILD_TYPE),release)
  $(warning Using BUILD_TYPE='$(BUILD_TYPE)' from the $(origin BUILD_TYPE).)
 endif
endif

EXTRA_CFLAGS = -fshort-wchar

ifneq ($(MAKECMDGOALS),clean)

ifeq ($(KERNELRELEASE),)

 #
 # building from this directory
 #

 # kernel base directory
 ifndef KERN_DIR
  KERN_DIR := /lib/modules/$(shell uname -r)/build
  ifneq ($(shell if test -d $(KERN_DIR); then echo yes; fi),yes)
   KERN_DIR := /usr/src/linux
   ifneq ($(shell if test -d $(KERN_DIR); then echo yes; fi),yes)
    $(error Error: unable to find the sources of your current Linux kernel. \
	           Specify KERN_DIR=<directory> and run Make again)
   endif
   $(warning Warning: using /usr/src/linux as the source directory of your \
                      Linux kernel. If this is not correct, specify \
		      KERN_DIR=<directory> and run Make again.)
  endif
 else
  ifneq ($(shell if test -d $(KERN_DIR); then echo yes; fi),yes)
   $(error Error: KERN_DIR does not point to a directory)
  endif
 endif

 # includes
 ifndef KERN_INCL
  KERN_INCL = $(KERN_DIR)/include
 endif
 ifneq ($(shell if test -d $(KERN_INCL); then echo yes; fi),yes)
  $(error Error: unable to find the include directory for your current Linux \
                 kernel. Specify KERN_INCL=<directory> and run Make again)
 endif

 # module install dir.
 ifneq ($(filter install install_rpm,$(MAKECMDGOALS)),)
  ifndef MODULE_DIR
   MODULE_DIR_TST := /lib/modules/$(shell uname -r)
   ifeq ($(shell if test -d $(MODULE_DIR_TST); then echo yes; fi),yes)
    MODULE_DIR := $(MODULE_DIR_TST)/misc
   else
    $(error Unable to find the folder to install the DRM driver to)
   endif
  endif # MODULE_DIR unspecified
 endif

 # guess kernel version (24 or 26)
 ifeq ($(shell if grep '"2\.4\.' $(KERN_INCL)/linux/version.h > /dev/null; then echo yes; fi),yes)
  KERN_VERSION := 24
 else
  KERN_VERSION := 26
 endif

else # neq($(KERNELRELEASE),)

 #
 # building from kbuild (make -C <kernel_directory> M=`pwd`)
 #

 # guess kernel version (24 or 26)
 ifeq ($(shell if echo "$(VERSION).$(PATCHLEVEL)." | grep '2\.4\.' > /dev/null; then echo yes; fi),yes)
  KERN_VERSION := 24
 else
  KERN_VERSION := 26
 endif

endif # neq($(KERNELRELEASE),)

# debug - show guesses.
ifdef DEBUG
$(warning dbg: KERN_DIR     = $(KERN_DIR))
$(warning dbg: KERN_INCL    = $(KERN_INCL))
$(warning dbg: MODULE_DIR   = $(MODULE_DIR))
$(warning dbg: KERN_VERSION = $(KERN_VERSION))
endif

KBUILD_VERBOSE ?= 1

#
# Compiler options
#
ifndef INCL
 INCL    := $(addprefix -I,$(KERN_INCL) $(EXTRA_INCL))
 ifndef KBUILD_EXTMOD
  KBUILD_EXTMOD := $(shell pwd)
 endif
 INCL    += $(addprefix -I$(KBUILD_EXTMOD),/ /include /r0drv/linux)
 export INCL
endif
KFLAGS   := -D__KERNEL__ -DMODULE -DRT_OS_LINUX -DIN_RING0 -DIN_RT_R0 \
	    -DIN_SUP_R0 -DVBOX -DVBOX_WITH_HGCM -DLOG_TO_BACKDOOR -DIN_MODULE \
	    -DIN_GUEST_R0
ifeq ($(BUILD_TARGET_ARCH),amd64)
 KFLAGS  += -DRT_ARCH_AMD64 -DVBOX_WITH_64_BITS_GUESTS
else
 KFLAGS  += -DRT_ARCH_X86
endif
ifeq ($(BUILD_TYPE),debug)
KFLAGS   += -DDEBUG
endif

# override is required by the Debian guys
override MODULE = vboxvideo
OBJS   = vboxvideo_drm.o

ifeq ($(KERN_VERSION), 24)
#
# 2.4
#

CFLAGS := -O2 -DVBOX_LINUX_2_4 $(INCL) $(KFLAGS) $(KDEBUG)
MODULE_EXT := o

# 2.4 Module linking
$(MODULE).o: $(OBJS)
	$(LD) -o $@ -r $(OBJS)

.PHONY: $(MODULE)
all: $(MODULE)
$(MODULE): $(MODULE).o

else
#
# 2.6 and later
#

MODULE_EXT := ko

$(MODULE)-y  := $(OBJS)

# special hack for Fedora Core 6 2.6.18 (fc6), rhel5 2.6.18 (el5),
# ClarkConnect 4.3 (cc4) and ClarkConnect 5 (v5)
ifeq ($(KERNELRELEASE),)
 KFLAGS += $(foreach inc,$(KERN_INCL),\
             $(if $(wildcard $(inc)/linux/utsrelease.h),\
               $(if $(shell grep '"2.6.18.*fc6.*"' $(inc)/linux/utsrelease.h; \
			    grep '"2.6.18.*el5.*"' $(inc)/linux/utsrelease.h; \
			    grep '"2.6.18.*v5.*"'  $(inc)/linux/utsrelease.h; \
			    grep '"2.6.18.*cc4.*"' $(inc)/linux/utsrelease.h),\
		-DKERNEL_FC6,),))
else
 KFLAGS += $(if $(shell echo "$(KERNELRELEASE)"|grep '2.6.18.*fc6.*';\
			echo "$(KERNELRELEASE)"|grep '2.6.18.*el5.*';\
			echo "$(KERNELRELEASE)"|grep '2.6.18.*v5.*';\
			echo "$(KERNELRELEASE)"|grep '2.6.18.*cc4.*'),\
		-DKERNEL_FC6,)
endif

# build defs
EXTRA_CFLAGS += $(INCL) $(KFLAGS) $(KDEBUG)

all: $(MODULE)

obj-m += $(MODULE).o

$(MODULE):
	$(MAKE) KBUILD_VERBOSE=$(KBUILD_VERBOSE) -C $(KERN_DIR) SUBDIRS=$(CURDIR) SRCROOT=$(CURDIR) modules

endif

install: $(MODULE)
	@mkdir -p $(MODULE_DIR); \
	install -m 0664 -o root -g root $(MODULE).$(MODULE_EXT) $(MODULE_DIR); \
	PATH="$(PATH):/bin:/sbin" depmod -ae;

endif # eq($(MAKECMDGOALS),clean)

# important: Don't remove Module.symvers! DKMS does 'make clean' before building ...
clean:
	for f in . linux r0drv r0drv/linux; do rm -f $$f/*.o $$f/.*.cmd $$f/.*.flags; done
	rm -rf .vboxvideo* .tmp_ver* vboxvideo.* Modules.symvers modules.order


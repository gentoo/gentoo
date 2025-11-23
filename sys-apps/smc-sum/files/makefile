obj-m := sum_bios.o

KVERSION := $(shell uname -r)
KDIR := /lib/modules/$(KVERSION)/build
PWD := $(shell pwd)

EXTRA_CFLAGS = $(CFLAGS) -Wno-incompatible-pointer-types
EXTRA_LDFLAGS = $(LDFLAGS)

default:
	$(MAKE) -C $(KDIR) M=$(PWD) modules

install:
	$(MAKE) -C $(KDIR) M=$(PWD) modules_install


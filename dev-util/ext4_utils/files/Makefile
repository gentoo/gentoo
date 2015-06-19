AR ?= ar
CC ?= gcc
CFLAGS := $(CFLAGS) -I. -Iinclude -DHOST -DANDROID -fPIC
LDFLAGS := $(LDFLAGS) -L.

PREFIX ?= /usr/
BINDIR ?= $(PREFIX)/bin
INCLUDEDIR ?= $(PREFIX)/include
LIBDIR ?= $(PREFIX)/lib

libext4_utils_src_files := make_ext4fs.c \
        ext4fixup.c \
        ext4_utils.c \
        allocate.c \
        contents.c \
        extent.c \
        indirect.c \
        uuid.c \
        sha1.c \
        wipe.c \
        crc16.c
libext4_utils_obj_files := $(libext4_utils_src_files:.c=.o)

selinux_src_files := src/android.c \
        src/booleans.c \
        src/canonicalize_context.c \
        src/disable.c \
        src/enabled.c \
        src/fgetfilecon.c \
        src/fsetfilecon.c \
        src/getenforce.c \
        src/getfilecon.c \
        src/getpeercon.c \
        src/lgetfilecon.c \
        src/load_policy.c \
        src/lsetfilecon.c \
        src/policyvers.c \
        src/procattr.c \
        src/setenforce.c \
        src/setfilecon.c \
        src/context.c \
        src/mapping.c \
        src/stringrep.c \
        src/compute_create.c \
        src/compute_av.c \
        src/avc.c \
        src/avc_internal.c \
        src/avc_sidtab.c \
        src/get_initial_context.c \
        src/checkAccess.c \
        src/sestatus.c \
        src/deny_unknown.c \
        src/callbacks.c \
        src/check_context.c \
        src/freecon.c \
        src/init.c \
        src/label.c \
        src/label_file.c \
        src/label_android_property.c
selinux_obj_files := $(selinux_src_files:.c=.o)

make_ext4fs_src_files := \
        make_ext4fs_main.c
make_ext4fs_obj_files := $(make_ext4fs_src_files:.c=.o)

ext2simg_src_files := \
        ext2simg.c
ext2simg_obj_files := $(ext2simg_src_files:.c=.o)

ext4fixup_src_files := \
        ext4fixup_main.c
ext4fixup_obj_files := $(ext4fixup_src_files:.c=.o)

libraries := -lext4_utils -lsparse -lz

executables := make_ext4fs ext2simg ext4fixup

all: $(executables)

%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

libext4_utils.a: $(libext4_utils_obj_files) $(selinux_obj_files)
	$(AR) rvs $@ $^

make_ext4fs: libext4_utils.a $(make_ext4fs_obj_files)
	$(CC) $(LDFLAGS) $(make_ext4fs_obj_files) -o $@ $(libraries)

ext2simg: libext4_utils.a $(ext2simg_obj_files)
	$(CC) $(LDFLAGS) $(ext2simg_obj_files) -o $@ $(libraries)

ext4fixup: libext4_utils.a $(ext4fixup_obj_files)
	$(CC) $(LDFLAGS) $(ext4fixup_obj_files) -o $@ $(libraries)

.PHONY: clean install

clean:
	rm -rf *.o *.so $(executables) src/*.o

install: all
	install -d $(DESTDIR)/$(BINDIR) $(DESTDIR)/$(LIBDIR) $(DESTDIR)/$(INCLUDEDIR)/sparse
	install mkuserimg.sh $(executables) $(DESTDIR)/$(BINDIR)

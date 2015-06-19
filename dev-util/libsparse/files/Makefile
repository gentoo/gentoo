CC ?= gcc
CFLAGS := $(CFLAGS) -I. -Iinclude -DANDROID -fPIC
LDFLAGS := $(LDFLAGS) -L.

PREFIX ?= /usr/
BINDIR ?= $(PREFIX)/bin
INCLUDEDIR ?= $(PREFIX)/include
LIBDIR ?= $(PREFIX)/lib

libsparse_src_files := \
        backed_block.c \
        output_file.c \
        sparse.c \
        sparse_crc32.c \
        sparse_err.c \
        sparse_read.c
libsparse_obj_files := $(libsparse_src_files:.c=.o)

simg2img_src_files := \
        simg2img.c
simg2img_obj_files := $(simg2img_src_files:.c=.o)

img2simg_src_files := \
        img2simg.c
img2simg_obj_files := $(img2simg_src_files:.c=.o)

simg2simg_src_files := \
        simg2simg.c
simg2simg_obj_files := $(simg2simg_src_files:.c=.o)

libraries := -lsparse -lz

executables := simg2img img2simg simg2simg

all: libsparse.so $(executables)

%.o: %.c
	$(CC) $(CFLAGS) -c $<

libsparse.so: $(libsparse_obj_files)
	$(CC) $(LDFLAGS) -shared -o $@ $^

simg2img: libsparse.so $(simg2img_obj_files)
	$(CC) $(LDFLAGS) $(simg2img_obj_files) -o $@ $(libraries)

img2simg: libsparse.so $(img2simg_obj_files)
	$(CC) $(LDFLAGS) $(img2simg_obj_files) -o $@ $(libraries)

simg2simg: libsparse.so $(simg2simg_obj_files)
	$(CC) $(LDFLAGS) $(simg2simg_obj_files) -o $@ $(libraries)

.PHONY: clean install

clean:
	rm -rf *.o *.so $(executables)

install: all
	install -d $(DESTDIR)/$(BINDIR) $(DESTDIR)/$(LIBDIR) $(DESTDIR)/$(INCLUDEDIR)/sparse
	install $(executables) $(DESTDIR)/$(BINDIR)
	install libsparse.so $(DESTDIR)/$(LIBDIR)
	install --mode=644 include/sparse/sparse.h $(DESTDIR)/$(INCLUDEDIR)/sparse

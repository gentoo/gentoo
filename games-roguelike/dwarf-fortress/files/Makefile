# Copyright 2014-2015 Alex Xu (Hello71)
# Distributed under the terms of the GNU General Public License v2

PKG_CONFIG ?= pkg-config
PKG_CONFIG_PATH ?= /usr/lib32/pkgconfig:/usr/lib/pkgconfig
PKG_CONFIG := PKG_CONFIG_PATH=$(PKG_CONFIG_PATH) $(PKG_CONFIG)

SRCS := g_src/basics.cpp g_src/command_line.cpp g_src/enabler.cpp \
	g_src/files.cpp g_src/find_files_posix.cpp g_src/graphics.cpp \
	g_src/init.cpp g_src/interface.cpp g_src/keybindings.cpp \
	g_src/music_and_sound_openal.cpp g_src/random.cpp g_src/textlines.cpp \
	g_src/enabler_input.cpp g_src/KeybindingScreen.cpp \
	g_src/win32_compat.cpp g_src/textures.cpp g_src/resize++.cpp \
	g_src/renderer_offscreen.cpp g_src/ttf_manager.cpp
OBJS := $(SRCS:.cpp=.o)

BLIBS := ncursesw openal sndfile
LIBS := glew glu gtk+-2.0 sdl SDL_image SDL_ttf zlib
CXXFLAGS ?= -O2 -pipe -Wall -Wextra
CXXFLAGS += -m32 $(shell $(PKG_CONFIG) --cflags $(BLIBS) $(LIBS)) -Dunix -Dlinux -fPIC -std=c++11
LDLIBS := $(shell $(PKG_CONFIG) --libs $(LIBS))

LG := libs/libgraphics.so

all: $(LG)
$(LG): $(OBJS)
	$(LINK.cpp) -shared $^ $(LDLIBS) -o $@

clean:
	$(RM) $(LG) $(OBJS)

.PHONY: clean

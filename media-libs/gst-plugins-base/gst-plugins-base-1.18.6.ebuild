# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
GST_ORG_MODULE="gst-plugins-base"

inherit flag-o-matic gstreamer-meson

DESCRIPTION="Basepack of plugins for gstreamer"
HOMEPAGE="https://gstreamer.freedesktop.org/"

LICENSE="GPL-2+ LGPL-2+"
KEYWORDS="~alpha amd64 arm ~arm64 ~hppa ~ia64 ~mips ~ppc ppc64 ~riscv ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~x64-solaris ~x86-solaris"

# For OpenGL we have three separate concepts, with a list of possibilities in each:
#  * opengl APIs - opengl and/or gles2; USE=opengl and USE=gles2 enable these accordingly; if neither is enabled, OpenGL helper library and elements are not built at all and all the other options aren't relevant
#  * opengl platforms - glx and/or egl; also cgl, wgl, eagl for non-linux; USE="X opengl" enables glx platform; USE="egl" enables egl platform. Rest is up for relevant prefix teams.
#  * opengl windowing system - x11, wayland, win32, cocoa, android, viv_fb, gbm and/or dispmanx; USE=X enables x11 (but for WSI it's automagic - FIXME), USE=wayland enables wayland, USE=gbm enables gbm (automagic upstream - FIXME); rest is up for relevant prefix/arch teams/contributors to test and provide patches
# With the following limitations:
#  * If opengl and/or gles2 is enabled, a platform has to be enabled - x11 or egl in our case, but x11 (glx) is acceptable only with opengl
#  * If opengl and/or gles2 is enabled, a windowing system has to be enabled - x11, wayland or gbm in our case
#  * glx platform requires opengl API
#  * wayland, gbm and most other non-glx WSIs require egl platform
# Additionally there is optional dmabuf support with egl for additional dmabuf based upload/download/eglimage options;
#  and optional graphene usage for gltransformation and glvideoflip elements and more GLSL Uniforms support in glshader;
#  and libpng/jpeg are required for gloverlay element;

# Keep default IUSE options for relevant ones mirrored with gst-plugins-gtk and gst-plugins-bad
IUSE="alsa +egl gbm gles2 +introspection ivorbis +ogg +opengl +orc +pango theora +vorbis wayland +X"
GL_REQUIRED_USE="
	|| ( gbm wayland X )
	wayland? ( egl )
	gbm? ( egl )
"
REQUIRED_USE="
	ivorbis? ( ogg )
	theora? ( ogg )
	vorbis? ( ogg )
	opengl? ( || ( egl X ) ${GL_REQUIRED_USE} )
	gles2? ( egl ${GL_REQUIRED_USE} )
"

# Dependencies needed by opengl library and plugin (enabled via USE gles2 and/or opengl)
# dmabuf automagic from libdrm headers (drm_fourcc.h) and EGL, so ensure it with USE=egl (platform independent header used only, thus no MULTILIB_USEDEP); provides dmabuf based upload/download/eglimage options
GL_DEPS="
	>=media-libs/mesa-9.0[egl(+)?,gbm(+)?,gles2?,wayland?,${MULTILIB_USEDEP}]
	egl? (
		x11-libs/libdrm
	)
	gbm? (
		>=dev-libs/libgudev-147[${MULTILIB_USEDEP}]
		>=x11-libs/libdrm-2.4.55[${MULTILIB_USEDEP}]
	)
	wayland? (
		dev-libs/wayland[${MULTILIB_USEDEP}]
		>=dev-libs/wayland-protocols-1.15
	)

	>=media-libs/graphene-1.4.0[${MULTILIB_USEDEP}]
	media-libs/libpng:0[${MULTILIB_USEDEP}]
	virtual/jpeg:0[${MULTILIB_USEDEP}]
" # graphene for optional gltransformation and glvideoflip elements and more GLSL Uniforms support in glshader; libpng/jpeg for gloverlay element
# >=media-libs/graphene-1.4.0[${MULTILIB_USEDEP}]

RDEPEND="
	app-text/iso-codes
	>=dev-libs/glib-2.40.0:2[${MULTILIB_USEDEP}]
	>=sys-libs/zlib-1.2.8-r1[${MULTILIB_USEDEP}]
	alsa? ( >=media-libs/alsa-lib-1.0.27.2[${MULTILIB_USEDEP}] )
	introspection? ( >=dev-libs/gobject-introspection-1.31.1:= )
	ivorbis? ( >=media-libs/tremor-0_pre20130223[${MULTILIB_USEDEP}] )
	ogg? ( >=media-libs/libogg-1.3.0[${MULTILIB_USEDEP}] )
	orc? ( >=dev-lang/orc-0.4.24[${MULTILIB_USEDEP}] )
	pango? ( >=x11-libs/pango-1.36.3[${MULTILIB_USEDEP}] )
	theora? ( >=media-libs/libtheora-1.1.1[encode,${MULTILIB_USEDEP}] )
	vorbis? ( >=media-libs/libvorbis-1.3.3-r1[${MULTILIB_USEDEP}] )
	X? (
		>=x11-libs/libX11-1.6.2[${MULTILIB_USEDEP}]
		>=x11-libs/libXext-1.3.2[${MULTILIB_USEDEP}]
		>=x11-libs/libXv-1.0.10[${MULTILIB_USEDEP}]
	)

	gles2? ( ${GL_DEPS} )
	opengl? ( ${GL_DEPS} )

	!<media-libs/gst-plugins-bad-1.15.0:1.0
"
DEPEND="${RDEPEND}
	dev-util/glib-utils
	>=dev-util/gtk-doc-am-1.12
	X? ( x11-base/xorg-proto )
"

DOCS="AUTHORS NEWS README RELEASE"

# Fixes backported to 1.18.x, to be removed in 1.18.7
PATCHES=(
)

multilib_src_configure() {
	filter-flags -mno-sse -mno-sse2 -mno-sse4.1 #610340

	# opus: split to media-plugins/gst-plugins-opus
	GST_PLUGINS_NOAUTO="alsa ogg pango theora vorbis x11 xshm xvideo"
	local emesonargs=(
		-Dtools=enabled

		$(meson_feature alsa)
		$(meson_feature ogg)
		$(meson_feature orc)
		$(meson_feature pango)
		$(meson_feature theora)
		$(meson_feature vorbis)
		$(meson_feature X x11)
		$(meson_feature X xshm)
		$(meson_feature X xvideo)
	)

	if use opengl || use gles2; then
		# because meson doesn't likes extraneous commas
		local gl_api=( $(use opengl && echo opengl) $(use gles2 && echo gles2) )
		local gl_platform=( $(use X && echo glx) $(use egl && echo egl) )
		local gl_winsys=(
			$(use X && echo x11)
			$(use wayland && echo wayland)
			$(use egl && echo egl)
			$(use gbm && echo gbm)
		)

		emesonargs+=(
			-Dgl=enabled
			-Dgl-graphene=enabled
			-Dgl_api=$(IFS=, ; echo "${gl_api[*]}")
			-Dgl_platform=$(IFS=, ; echo "${gl_platform[*]}")
			-Dgl_winsys=$(IFS=, ; echo "${gl_winsys[*]}")
		)
	else
		emesonargs+=(
			-Dgl=disabled
			-Dgl_api=
			-Dgl_platform=
			-Dgl_winsys=
		)
	fi

	# Workaround EGL/eglplatform.h being built with X11 present
	use X || export CFLAGS="${CFLAGS} -DEGL_NO_X11"

	gstreamer_multilib_src_configure
}

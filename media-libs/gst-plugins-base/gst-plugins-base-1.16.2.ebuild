# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
GST_ORG_MODULE="gst-plugins-base"

inherit flag-o-matic gstreamer

DESCRIPTION="Basepack of plugins for gstreamer"
HOMEPAGE="https://gstreamer.freedesktop.org/"

LICENSE="GPL-2+ LGPL-2+"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc x86"

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
	>=media-libs/mesa-9.0[egl?,gbm?,gles2?,wayland?,${MULTILIB_USEDEP}]
	egl? (
		x11-libs/libdrm
	)
	gbm? (
		>=dev-libs/libgudev-147[${MULTILIB_USEDEP}]
		>=x11-libs/libdrm-2.4.55[${MULTILIB_USEDEP}]
	)
	wayland? (
		dev-libs/wayland[${MULTILIB_USEDEP}]
	)

	>=media-libs/graphene-1.4.0[${MULTILIB_USEDEP}]
	media-libs/libpng:0[${MULTILIB_USEDEP}]
	virtual/jpeg:0[${MULTILIB_USEDEP}]
" # graphene for optional gltransformation and glvideoflip elements and more GLSL Uniforms support in glshader; libpng/jpeg for gloverlay element

RDEPEND="
	app-text/iso-codes
	>=dev-libs/glib-2.40.0:2[${MULTILIB_USEDEP}]
	>=media-libs/gstreamer-${PV}:1.0[introspection?,${MULTILIB_USEDEP}]
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

PATCHES=(
	"${FILESDIR}"/${PN}-1.16.2-make43.patch # remove when bumping and switching to Meson
)

src_prepare() {
	# Disable GL tests for now; prone to fail with EGL_NOT_INITIALIZED, etc
	sed -i -e '/^@USE_GL_TRUE@/d' tests/check/Makefile.in
	default
}

multilib_src_configure() {
	filter-flags -mno-sse -mno-sse2 -mno-sse4.1 #610340

	local myconf=()
	# FIXME: Automagic gbm and x11 wsi
	if use opengl || use gles2; then
		myconf+=(
			--enable-gl
			$(use_enable egl)
			$(use_enable gles2)
			$(use_enable opengl)
			$(use_enable wayland)
			$(use_enable X x11)
		)
	else
		myconf+=(
			--disable-gl
			--disable-egl
			--disable-gles2
			--disable-opengl
			--disable-wayland
			--disable-x11
		)
	fi

	if use opengl && use X; then
		# GLX requires desktop OpenGL and X
		myconf+=( --enable-glx )
	else
		myconf+=( --disable-glx )
	fi

	myconf+=(
		--disable-cocoa
		--disable-dispmanx
		--disable-wgl
	)

	gstreamer_multilib_src_configure \
		$(use_enable alsa) \
		$(multilib_native_use_enable introspection) \
		$(use_enable ivorbis) \
		$(use_enable ogg) \
		$(use_enable orc) \
		$(use_enable pango) \
		$(use_enable theora) \
		$(use_enable vorbis) \
		$(use_enable X x) \
		$(use_enable X xshm) \
		$(use_enable X xvideo) \
		--enable-iso-codes \
		--enable-zlib \
		--disable-debug \
		--disable-examples \
		--disable-static \
		"${myconf[@]}"

	# bug #366931, flag-o-matic for the whole thing is overkill
	if [[ ${CHOST} == *86-*-darwin* ]] ; then
		sed -i \
			-e '/FLAGS = /s|-O[23]|-O1|g' \
			gst/audioconvert/Makefile \
			gst/volume/Makefile || die
	fi

	if multilib_is_native_abi; then
		local x
		for x in libs plugins; do
			ln -s "${S}"/docs/${x}/html docs/${x}/html || die
		done
	fi
}

multilib_src_install_all() {
	DOCS="AUTHORS NEWS README RELEASE"
	einstalldocs
	find "${ED}" -name '*.la' -delete || die
}

multilib_src_test() {
	unset GSETTINGS_BACKEND
	emake check
}

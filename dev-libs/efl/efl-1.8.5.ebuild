# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/efl/efl-1.8.5.ebuild,v 1.9 2015/02/14 04:35:08 vapier Exp $

EAPI="5"

MY_P=${P/_/-}

if [[ "${PV}" == "9999" ]] ; then
	EGIT_SUB_PROJECT="core"
	EGIT_URI_APPEND="${PN}"
else
	SRC_URI="http://download.enlightenment.org/rel/libs/${PN}/${MY_P}.tar.bz2"
	EKEY_STATE="snap"
fi

inherit enlightenment

DESCRIPTION="Enlightenment Foundation Libraries all-in-one package"

LICENSE="BSD-2 GPL-2 LGPL-2.1 ZLIB"
KEYWORDS="amd64 ~arm x86"
IUSE="+bmp debug drm +eet egl fbcon +fontconfig fribidi gif gles glib gnutls gstreamer harfbuzz +ico ibus +jpeg jpeg2k opengl ssl physics pixman +png +ppm +psd pulseaudio scim sdl sound systemd tga tiff tslib v4l2 wayland webp X xcb xim xine xpm"

REQUIRED_USE="
	X?		( !xcb )
	pulseaudio?	( sound )
	opengl?		( || ( X xcb sdl wayland ) )
	gles?		( || ( X xcb wayland ) )
	gles?		( !sdl )
	gles?		( egl )
	xcb?		( pixman )
	wayland?	( egl !opengl gles )
	xim?		( || ( X xcb ) )
"

RDEPEND="
	debug? ( dev-util/valgrind )
	fontconfig? ( media-libs/fontconfig )
	fribidi? ( dev-libs/fribidi )
	gif? ( media-libs/giflib )
	glib? ( dev-libs/glib )
	gnutls? ( net-libs/gnutls )
	!gnutls? ( ssl? ( dev-libs/openssl ) )
	gstreamer? (
		=media-libs/gstreamer-0.10*
		=media-libs/gst-plugins-good-0.10*
		=media-plugins/gst-plugins-ffmpeg-0.10*
	)
	harfbuzz? ( media-libs/harfbuzz )
	ibus? ( app-i18n/ibus )
	jpeg? ( virtual/jpeg )
	jpeg2k? ( media-libs/openjpeg )
	physics? ( sci-physics/bullet )
	pixman? ( x11-libs/pixman )
	png? ( media-libs/libpng:0= )
	pulseaudio? ( media-sound/pulseaudio )
	scim?	( app-i18n/scim )
	sdl? (
		media-libs/libsdl
		virtual/opengl
	)
	sound? ( media-libs/libsndfile )
	systemd? ( sys-apps/systemd )
	tiff? ( media-libs/tiff )
	tslib? ( x11-libs/tslib )
	wayland? (
		>=dev-libs/wayland-1.3.0
		>=x11-libs/libxkbcommon-0.3.1
		media-libs/mesa[gles2,wayland]
	)
	webp? ( media-libs/libwebp )
	X? (
		x11-libs/libXcursor
		x11-libs/libX11
		x11-libs/libXcomposite
		x11-libs/libXdamage
		x11-libs/libXext
		x11-libs/libXfixes
		x11-libs/libXinerama
		x11-libs/libXp
		x11-libs/libXrandr
		x11-libs/libXrender
		x11-libs/libXtst
		x11-libs/libXScrnSaver

		opengl? (
			x11-libs/libX11
			x11-libs/libXrender
			virtual/opengl
		)

		gles? (
			x11-libs/libX11
			x11-libs/libXrender
			virtual/opengl
		)
	)
	xcb? (
		x11-libs/libxcb

		opengl? (
			x11-libs/libX11
			x11-libs/libXrender
			virtual/opengl
			x11-libs/xcb-util-renderutil
		)

		gles? (
			x11-libs/libX11
			x11-libs/libXrender
			virtual/opengl
			x11-libs/xcb-util-renderutil
		)
	)
	xine? ( >=media-libs/xine-lib-1.1.1 )
	xpm? ( x11-libs/libXpm )

	dev-lang/lua
	sys-apps/dbus
	>=sys-apps/util-linux-2.20.0
	sys-libs/zlib

	!dev-libs/ecore
	!dev-libs/edbus
	!dev-libs/eet
	!dev-libs/eeze
	!dev-libs/efreet
	!dev-libs/eina
	!dev-libs/eio
	!dev-libs/embryo
	!dev-libs/eobj
	!dev-libs/ephysics
	!media-libs/edje
	!media-libs/emotion
	!media-libs/ethumb
	!media-libs/evas
"

#soft blockers added above for binpkg users
#hard blocks are needed for building
CORE_EFL_CONFLICTS="
	!!dev-libs/ecore
	!!dev-libs/edbus
	!!dev-libs/eet
	!!dev-libs/eeze
	!!dev-libs/efreet
	!!dev-libs/eina
	!!dev-libs/eio
	!!dev-libs/embryo
	!!dev-libs/eobj
	!!dev-libs/ephysics
	!!media-libs/edje
	!!media-libs/emotion
	!!media-libs/ethumb
	!!media-libs/evas
"

DEPEND="
	${CORE_EFL_CONFLICTS}

	${RDEPEND}
	doc? ( app-doc/doxygen )
"

S=${WORKDIR}/${MY_P}

src_configure() {
	use ssl && use gnutls && {
		einfo "You enabled both USEssl and USE=gnutls, but only one can be used"
		einfo "gnutls has been selected for you"
	}
	use opengl && use gles && {
		einfo "You enabled both USE=opengl and USE=gles, but only one can be used"
		einfo "opengl has been selected for you"
	}

	local profile="release"

	use debug && profile="debug"

	local crypto="none"

	use gnutls && crypto="gnutls"
	use ssl && crypto="openssl"

	local x11="none"
	local enable_graphics=""

	use X && x11="xlib"
	use xcb && x11="xcb"

	local MY_ECONF
	( use X || use xcb ) && MY_ECONF+=" --with-x"

	local opengl="none"

	use gles && opengl="es"
	use opengl && opengl="full"

	local glib="no"

	use glib && glib="yes"

	MY_ECONF+="
	--with-profile=${profile}
	--with-crypto=${crypto}
	--with-x11=${x11}
	--with-opengl=${opengl}
	--with-glib=${glib}

	$(use_enable bmp image-loader-bmp)
	$(use_enable bmp image-loader-wbmp)
	$(use_enable drm)
	$(use_enable doc)
	$(use_enable eet image-loader-eet)
	$(use_enable egl)
	$(use_enable fbcon fb)
	$(use_enable fontconfig)
	$(use_enable fribidi)
	$(use_enable gif image-loader-gif)
	$(use_enable gstreamer)
	$(use_enable harfbuzz)
	$(use_enable ico image-loader-ico)
	$(use_enable ibus)
	$(use_enable jpeg image-loader-jpeg)
	$(use_enable jpeg2k image-loader-jp2k)
	$(use_enable nls)
	$(use_enable physics)
	$(use_enable pixman)
	$(use_enable pixman pixman-font)
	$(use_enable pixman pixman-rect)
	$(use_enable pixman pixman-line)
	$(use_enable pixman pixman-poly)
	$(use_enable pixman pixman-image)
	$(use_enable pixman pixman-image-scale-sample)
	$(use_enable png image-loader-png)
	$(use_enable ppm image-loader-pmaps)
	$(use_enable psd image-loader-psd)
	$(use_enable pulseaudio)
	$(use_enable scim)
	$(use_enable sdl)
	$(use_enable sound audio)
	$(use_enable systemd)
	$(use_enable tga image-loader-tga)
	$(use_enable tiff image-loader-tiff)
	$(use_enable tslib)
	$(use_enable v4l2)
	$(use_enable wayland)
	$(use_enable webp image-loader-webp)
	$(use_enable xim)
	$(use_enable xine)
	$(use_enable xpm image-loader-xpm)
	--enable-cserve
	--enable-image-loader-generic

	--disable-tizen
	--disable-gesture
	--enable-xinput2
	--disable-xinput22
	--disable-multisense
	--enable-libmount
	"

	enlightenment_src_configure
}

src_compile() {
	ewarn "If the following compile phase fails with a message including"
	ewarn "lib/edje/.libs/libedje.so: undefined reference to 'eet_mmap'"
	ewarn "then most likely the @preserved-rebuild feature of portage"
	ewarn "preserved the 1.7 libraries, which cause the build failure."
	ewarn "As a workaround, either remove those libs manually or"
	ewarn "uninstall all packages still using those old libs with"
	ewarn "emerge -aC @preserved-rebuild"

	enlightenment_src_compile
}

src_install() {
	MAKEOPTS+=" -j1"

	enlightenment_src_install
}

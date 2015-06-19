# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/efl/efl-1.13.1.ebuild,v 1.2 2015/03/17 17:34:56 vapier Exp $

EAPI="5"

MY_P=${P/_/-}

if [[ "${PV}" == "9999" ]] ; then
	EGIT_SUB_PROJECT="core"
	EGIT_URI_APPEND="${PN}"
elif [[ *"${PV}" == *"_pre"* ]] ; then
	MY_P=${P%%_*}
	SRC_URI="http://download.enlightenment.org/pre-releases/${MY_P}.tar.xz"
	EKEY_STATE="snap"
else
	SRC_URI="http://download.enlightenment.org/rel/libs/${PN}/${MY_P}.tar.xz"
	EKEY_STATE="snap"
fi

inherit enlightenment

DESCRIPTION="Enlightenment Foundation Libraries all-in-one package"

LICENSE="BSD-2 GPL-2 LGPL-2.1 ZLIB"
IUSE="+bmp debug drm +eet egl fbcon +fontconfig fribidi gif gles glib gnutls gstreamer harfbuzz +ico ibus jpeg2k neon oldlua opengl ssl physics pixman +png +ppm +psd pulseaudio scim sdl sound systemd tga tiff tslib v4l2 valgrind wayland webp X xim xine xpm"

REQUIRED_USE="
	pulseaudio?	( sound )
	opengl?		( || ( X sdl wayland ) )
	gles?		( || ( X wayland ) )
	gles?		( !sdl )
	gles?		( egl )
	sdl?		( opengl )
	wayland?	( egl !opengl gles )
	xim?		( X )
"

RDEPEND="
	drm? (
		>=dev-libs/libinput-0.8
		media-libs/mesa[gbm]
		>=x11-libs/libdrm-2.4
		>=x11-libs/libxkbcommon-0.3.0
	)
	fontconfig? ( media-libs/fontconfig )
	fribidi? ( dev-libs/fribidi )
	gif? ( media-libs/giflib )
	glib? ( dev-libs/glib:2 )
	gnutls? ( net-libs/gnutls )
	!gnutls? ( ssl? ( dev-libs/openssl:0 ) )
	gstreamer? (
		media-libs/gstreamer:1.0
		media-libs/gst-plugins-base:1.0
	)
	harfbuzz? ( media-libs/harfbuzz )
	ibus? ( app-i18n/ibus )
	jpeg2k? ( media-libs/openjpeg )
	!oldlua? ( >=dev-lang/luajit-2.0.0 )
	oldlua? ( dev-lang/lua )
	physics? ( >=sci-physics/bullet-2.80 )
	pixman? ( x11-libs/pixman )
	png? ( media-libs/libpng:0= )
	pulseaudio? ( media-sound/pulseaudio )
	scim? ( app-i18n/scim )
	sdl? (
		media-libs/libsdl2
		virtual/opengl
	)
	sound? ( media-libs/libsndfile )
	systemd? ( sys-apps/systemd )
	tiff? ( media-libs/tiff:0 )
	tslib? ( x11-libs/tslib )
	valgrind? ( dev-util/valgrind )
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
	xine? ( >=media-libs/xine-lib-1.1.1 )
	xpm? ( x11-libs/libXpm )

	sys-apps/dbus
	>=sys-apps/util-linux-2.20.0
	sys-libs/zlib
	virtual/jpeg

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
#external lz4 support currently broken because of unstable ABI/API
#	app-arch/lz4

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
	if use ssl && use gnutls ; then
		einfo "You enabled both USEssl and USE=gnutls, but only one can be used;"
		einfo "gnutls has been selected for you."
	fi
	if use opengl && use gles ; then
		einfo "You enabled both USE=opengl and USE=gles, but only one can be used;"
		einfo "opengl has been selected for you."
	fi

	E_ECONF=(
		--with-profile=$(usex debug debug release)
		--with-crypto=$(usex gnutls gnutls $(usex ssl openssl none))
		--with-x11=$(usex X xlib none)
		$(use_with X x)
		--with-opengl=$(usex opengl full $(usex gles es none))
		--with-glib=$(usex glib)
		--enable-i-really-know-what-i-am-doing-and-that-this-will-probably-break-things-and-i-will-fix-them-myself-and-send-patches-aba

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
		$(use_enable gstreamer gstreamer1)
		$(use_enable harfbuzz)
		$(use_enable ico image-loader-ico)
		$(use_enable ibus)
		$(use_enable jpeg2k image-loader-jp2k)
		$(use_enable neon)
		$(use_enable nls)
		$(use_enable oldlua lua-old)
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
		$(use_enable valgrind)
		$(use_enable wayland)
		$(use_enable webp image-loader-webp)
		$(use_enable xim)
		$(use_enable xine)
		$(use_enable xpm image-loader-xpm)
		--enable-cserve
		--enable-gui
		--enable-image-loader-generic
		--enable-image-loader-jpeg

		--disable-tizen
		--disable-gesture
		--disable-gstreamer
		--enable-xinput2
		--disable-xinput22
		--disable-multisense
		--enable-libmount

		# external lz4 support currently broken because of unstable ABI/API
		#--enable-liblz4
	)

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

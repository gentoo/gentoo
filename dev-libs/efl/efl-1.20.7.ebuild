# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

MY_P=${P/_/-}

if [[ "${PV}" == "9999" ]] ; then
	EGIT_SUB_PROJECT="core"
	EGIT_URI_APPEND="${PN}"
elif [[ *"${PV}" == *"_pre"* ]] ; then
	MY_P=${P%%_*}
	SRC_URI="https://download.enlightenment.org/pre-releases/${MY_P}.tar.xz"
else
	SRC_URI="https://download.enlightenment.org/rel/libs/${PN}/${MY_P}.tar.xz"
	KEYWORDS="~amd64 ~arm ~hppa ~mips ~ppc ~ppc64 ~sh ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~x64-solaris ~x86-solaris"
fi

inherit enlightenment gnome2-utils pax-utils xdg-utils

DESCRIPTION="Enlightenment Foundation Libraries all-in-one package"

LICENSE="BSD-2 GPL-2 LGPL-2.1 ZLIB"
IUSE="avahi +bmp dds connman debug drm +eet egl examples fbcon +fontconfig fribidi gif gles glib gnutls gstreamer harfbuzz hyphen +ico ibus ivi jpeg2k libressl libuv luajit neon opengl ssl pdf physics pixman postscript +ppm +psd pulseaudio raw scim sdl sound svg systemd tga tgv tiff tslib unwind v4l valgrind vlc vnc wayland webp X xcf xim xine xpresent xpm"

REQUIRED_USE="
	?? ( opengl gles )
	fbcon? ( !tslib )
	gles? (
		|| ( X wayland )
		!sdl
		egl
	)
	gnutls? ( ssl )
	ibus? ( glib )
	libressl? ( ssl )
	opengl? ( || ( X sdl wayland ) )
	pulseaudio? ( sound )
	sdl? ( opengl )
	vnc? ( X fbcon )
	wayland? ( egl !opengl gles )
	xim? ( X )
"

RDEPEND="
	avahi? ( net-dns/avahi )
	connman? ( net-misc/connman )
	drm? (
		>=dev-libs/libinput-0.8
		media-libs/mesa[gbm]
		>=x11-libs/libdrm-2.4
		>=x11-libs/libxkbcommon-0.3.0
	)
	fontconfig? ( >=media-libs/fontconfig-2.5.0 )
	fribidi? ( >=dev-libs/fribidi-0.19.2 )
	gif? ( media-libs/giflib:= )
	glib? ( dev-libs/glib:2 )
	ssl? (
		gnutls? ( >=net-libs/gnutls-3.3.6 )
		!gnutls? (
			!libressl? ( dev-libs/openssl:0= )
			libressl? ( dev-libs/libressl:0= )
		)
	)
	gstreamer? (
		media-libs/gstreamer:1.0
		media-libs/gst-plugins-base:1.0
	)
	harfbuzz? ( >=media-libs/harfbuzz-0.9.0 )
	hyphen? ( dev-libs/hyphen )
	ibus? ( >=app-i18n/ibus-1.4 )
	jpeg2k? ( media-libs/openjpeg:0 )
	libuv? ( dev-libs/libuv )
	luajit? ( >=dev-lang/luajit-2.0.0 )
	!luajit? ( dev-lang/lua:* )
	pdf? ( >=app-text/poppler-0.45.0[cxx] )
	physics? ( >=sci-physics/bullet-2.80 )
	pixman? ( x11-libs/pixman )
	postscript? ( app-text/libspectre )
	media-libs/libpng:0=
	pulseaudio? ( media-sound/pulseaudio )
	raw? ( media-libs/libraw )
	scim? ( app-i18n/scim )
	sdl? (
		>=media-libs/libsdl2-2.0.0
		virtual/opengl
	)
	sound? ( media-libs/libsndfile )
	svg? (
		>=gnome-base/librsvg-2.36.0
		>=x11-libs/cairo-1.0.0
	)
	systemd? ( >=sys-apps/systemd-209 )
	tiff? ( media-libs/tiff:0= )
	tslib? ( x11-libs/tslib )
	unwind? ( sys-libs/libunwind )
	valgrind? ( dev-util/valgrind )
	vlc? ( media-video/vlc )
	vnc? ( net-libs/libvncserver )
	wayland? (
		>=dev-libs/wayland-1.11.0
		>=x11-libs/libxkbcommon-0.6.0
		media-libs/mesa[gles2,wayland]
	)
	webp? ( media-libs/libwebp )
	X? (
		>=media-libs/freetype-2.5.0.1
		x11-libs/libXcursor
		x11-libs/libX11
		x11-libs/libXcomposite
		x11-libs/libXdamage
		x11-libs/libXext
		x11-libs/libXfixes
		x11-libs/libXinerama
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
		xpresent? ( x11-libs/libXpresent )
		)
	)
	xine? ( >=media-libs/xine-lib-1.1.1 )
	xpm? ( x11-libs/libXpm )

	sys-apps/dbus
	>=sys-apps/util-linux-2.20.0
	sys-libs/zlib
	virtual/jpeg:0=

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
	!media-libs/elementary
	!media-libs/emotion
	!media-libs/ethumb
	!media-libs/evas
	!media-plugins/emotion_generic_players
	!media-plugins/evas_generic_loaders
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

pkg_setup() {
	# Get clean environment, see bug 557408
	xdg_environment_reset
	chown portage:portage -R "${HOME}"
}

src_prepare() {
	enlightenment_src_prepare

	# Remove stupid sleep command.
	# Also back out gnu make hack that causes regen of Makefiles.
	# Delete var setting that causes the build to abort.
	sed -i \
		-e '/sleep 10/d' \
		-e '/^#### Work around bug in automake check macro$/,/^#### Info$/d' \
		-e '/BARF_OK=/s:=.*:=:' \
		configure || die

	# Upstream doesn't offer a configure flag. #611108
	if ! use unwind ; then
		sed -i \
			-e 's:libunwind libunwind-generic:xxxxxxxxxxxxxxxx:' \
			configure || die
	fi
}

src_configure() {
	if use ssl && use gnutls ; then
		einfo "You enabled both USE=ssl and USE=gnutls, but only one can be used;"
		einfo "gnutls has been selected for you."
	fi
	if use opengl && use gles ; then
		einfo "You enabled both USE=opengl and USE=gles, but only one can be used;"
		einfo "opengl has been selected for you."
	fi

	E_ECONF=(
		--with-profile=$(usex debug debug release)
		--with-net-control=$(usex connman connman none)
		--with-crypto=$(usex gnutls gnutls $(usex ssl openssl none))
		--with-x11=$(usex X xlib none)
		$(use_with X x)
		--with-opengl=$(usex opengl full $(usex gles es none))
		--with-glib=$(usex glib)
		--enable-i-really-know-what-i-am-doing-and-that-this-will-probably-break-things-and-i-will-fix-them-myself-and-send-patches-abb

		$(use_enable avahi)
		$(use_enable bmp image-loader-bmp)
		$(use_enable bmp image-loader-wbmp)
		$(use_enable dds image-loader-dds)
		$(use_enable drm)
		$(use_enable drm elput)
		$(use_enable doc)
		$(use_enable eet image-loader-eet)
		$(use_enable egl)
		$(use_enable examples always-build-examples)
		$(use_enable fbcon fb)
		$(use_enable fontconfig)
		$(use_enable fribidi)
		$(use_enable gif image-loader-gif)
		$(use_enable gstreamer gstreamer1)
		$(use_enable harfbuzz)
		$(use_enable hyphen)
		$(use_enable ico image-loader-ico)
		$(use_enable ibus)
		$(use_enable ivi wayland-ivi-shell)
		$(use_enable jpeg2k image-loader-jp2k)
		$(use_enable libuv)
		$(use_enable !luajit lua-old)
		$(use_enable neon)
		$(use_enable nls)
		$(use_enable pdf poppler)
		$(use_enable physics)
		$(use_enable pixman)
		$(use_enable pixman pixman-font)
		$(use_enable pixman pixman-rect)
		$(use_enable pixman pixman-line)
		$(use_enable pixman pixman-poly)
		$(use_enable pixman pixman-image)
		$(use_enable pixman pixman-image-scale-sample)
		--enable-image-loader-png
		$(use_enable postscript spectre)
		$(use_enable ppm image-loader-pmaps)
		$(use_enable psd image-loader-psd)
		$(use_enable pulseaudio)
		$(use_enable raw libraw)
		$(use_enable scim)
		$(use_enable sdl)
		$(use_enable sound audio)
		$(use_enable svg librsvg)
		$(use_enable systemd)
		$(use_enable tga image-loader-tga)
		$(use_enable tgv image-loader-tgv)
		$(use_enable tiff image-loader-tiff)
		$(use_enable tslib)
		$(use_enable v4l v4l2)
		$(use_enable valgrind)
		$(use_enable vlc libvlc)
		$(use_with vlc generic_vlc)
		$(use_enable vnc vnc-server)
		$(use_enable wayland)
		$(use_enable webp image-loader-webp)
		$(use_enable xcf)
		$(use_enable xim)
		$(use_enable xine)
		$(use_enable xpm image-loader-xpm)
		--enable-cserve
		--enable-image-loader-generic
		--enable-image-loader-jpeg

		--disable-tizen
		--disable-gesture
		--disable-gstreamer
		--enable-xinput2
		--disable-xinput22
		--enable-libmount

		# currently no JavaScript engine builds. Therefore:
		--with-js=none

		# external lz4 support currently broken because of unstable ABI/API
		#--enable-liblz4
	)

	use fbcon && use egl &&	E_ECONF="${E_ECONF} --enable-eglfs"
	use X && use xpresent && E_ECONF="${E_ECONF} --enable xpresent"

	enlightenment_src_configure
}

src_compile() {
	if host-is-pax && use luajit ; then
		# We need to build the lua code first so we can pax-mark it. #547076
		local target='_e_built_sources_target_gogogo_'
		printf '%s: $(BUILT_SOURCES)\n' "${target}" >> src/Makefile || die
		emake -C src "${target}"
		emake -C src bin/elua/elua
		pax-mark m src/bin/elua/.libs/elua
	fi
	enlightenment_src_compile
}

src_install() {
	MAKEOPTS+=" -j1"

	enlightenment_src_install
}

pkg_postinst() {
	gnome2_icon_cache_update
	xdg_mimeinfo_database_update
}

pkg_postrm() {
	gnome2_icon_cache_update
	xdg_mimeinfo_database_update
}

# Copyright 2000-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LUA_COMPAT=( lua5-{1..2} )

MY_PV="${PV/_/-}"
MY_PV="${MY_PV/-beta/-test}"
MY_P="${PN}-${MY_PV}"
if [[ ${PV} = *9999 ]] ; then
	if [[ ${PV%.9999} != ${PV} ]] ; then
		EGIT_BRANCH="3.0.x"
	fi
	EGIT_REPO_URI="https://code.videolan.org/videolan/vlc.git"
	inherit git-r3
else
	if [[ ${MY_P} = ${P} ]] ; then
		SRC_URI="https://download.videolan.org/pub/videolan/${PN}/${PV}/${P}.tar.xz"
	else
		SRC_URI="https://download.videolan.org/pub/videolan/testing/${MY_P}/${MY_P}.tar.xz"
	fi
	KEYWORDS="amd64 ~arm arm64 ~loong ppc ppc64 ~riscv -sparc x86"
fi
inherit autotools flag-o-matic lua-single toolchain-funcs virtualx xdg

DESCRIPTION="Media player and framework with support for most multimedia files and streaming"
HOMEPAGE="https://www.videolan.org/vlc/"

LICENSE="LGPL-2.1 GPL-2"
SLOT="0/5-9" # vlc - vlccore

IUSE="a52 alsa aom archive aribsub bidi bluray cddb chromaprint chromecast dav1d dbus
	dc1394 debug directx dts +dvbpsi dvd +encode faad fdk +ffmpeg flac fluidsynth
	fontconfig +gcrypt gme gnome-keyring gstreamer +gui ieee1394 jack jpeg kate
	libass libcaca libnotify +libsamplerate libtar libtiger linsys lirc live lua
	macosx-notifications mad matroska modplug mp3 mpeg mtp musepack ncurses nfs ogg
	omxil optimisememory opus png projectm pulseaudio rdp run-as-root samba sdl-image
	sftp shout sid skins soxr speex srt ssl svg taglib theora tremor truetype twolame
	udev upnp vaapi v4l vdpau vnc vpx wayland +X x264 x265 xml zeroconf zvbi
	cpu_flags_arm_neon cpu_flags_ppc_altivec cpu_flags_x86_mmx cpu_flags_x86_sse
"
REQUIRED_USE="
	chromecast? ( encode )
	directx? ( ffmpeg )
	fontconfig? ( truetype )
	libcaca? ( X )
	libtar? ( skins )
	libtiger? ( kate )
	lua? ( ${LUA_REQUIRED_USE} )
	skins? ( gui truetype X xml )
	ssl? ( gcrypt )
	vaapi? ( ffmpeg X )
	vdpau? ( ffmpeg X )
"
BDEPEND="
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
	lua? ( ${LUA_DEPS} )
	amd64? ( dev-lang/yasm )
	x86? ( dev-lang/yasm )
"
RDEPEND="
	media-libs/libvorbis
	net-dns/libidn:=
	sys-libs/zlib[minizip]
	virtual/libintl
	virtual/opengl
	a52? ( media-libs/a52dec )
	alsa? ( media-libs/alsa-lib )
	aom? ( media-libs/libaom:= )
	archive? ( app-arch/libarchive:= )
	aribsub? ( media-libs/aribb24 )
	bidi? (
		dev-libs/fribidi
		media-libs/freetype:2[harfbuzz]
		media-libs/harfbuzz:=
		virtual/ttf-fonts
	)
	bluray? ( >=media-libs/libbluray-1.3.0:= )
	cddb? ( media-libs/libcddb )
	chromaprint? ( media-libs/chromaprint:= )
	chromecast? (
		>=dev-libs/protobuf-2.5.0:=
		>=net-libs/libmicrodns-0.1.2:=
	)
	dav1d? ( media-libs/dav1d:= )
	dbus? ( sys-apps/dbus )
	dc1394? (
		media-libs/libdc1394:2
		sys-libs/libraw1394
	)
	dts? ( media-libs/libdca )
	dvbpsi? ( >=media-libs/libdvbpsi-1.2.0:= )
	dvd? (
		>=media-libs/libdvdnav-6.1.1:=
		>=media-libs/libdvdread-6.1.2:=
	)
	faad? ( media-libs/faad2 )
	fdk? ( media-libs/fdk-aac:= )
	ffmpeg? ( >=media-video/ffmpeg-3.1.3:=[postproc,vaapi?,vdpau?] )
	flac? (
		media-libs/flac:=
		media-libs/libogg
	)
	fluidsynth? ( media-sound/fluidsynth:= )
	fontconfig? ( media-libs/fontconfig:1.0 )
	gcrypt? (
		dev-libs/libgcrypt:=
		dev-libs/libgpg-error
	)
	gme? ( media-libs/game-music-emu )
	gnome-keyring? ( app-crypt/libsecret )
	gstreamer? ( >=media-libs/gst-plugins-base-1.4.5:1.0 )
	gui? (
		dev-qt/qtcore:5
		dev-qt/qtgui:5
		dev-qt/qtsvg:5
		dev-qt/qtwidgets:5
		X? (
			dev-qt/qtx11extras:5
			x11-libs/libX11
		)
	)
	ieee1394? (
		sys-libs/libavc1394
		sys-libs/libraw1394
	)
	jack? ( virtual/jack )
	jpeg? ( media-libs/libjpeg-turbo:0 )
	kate? ( media-libs/libkate )
	libass? (
		media-libs/fontconfig:1.0
		media-libs/libass:=
	)
	libcaca? ( media-libs/libcaca )
	libnotify? (
		dev-libs/glib:2
		x11-libs/gdk-pixbuf:2
		x11-libs/gtk+:3
		x11-libs/libnotify
	)
	libsamplerate? ( media-libs/libsamplerate )
	libtar? ( dev-libs/libtar )
	libtiger? ( media-libs/libtiger )
	linsys? ( media-libs/zvbi )
	lirc? ( app-misc/lirc )
	live? ( media-plugins/live:= )
	lua? ( ${LUA_DEPS} )
	mad? ( media-libs/libmad )
	matroska? (
		>=dev-libs/libebml-1.4.2:=
		media-libs/libmatroska:=
	)
	modplug? ( >=media-libs/libmodplug-0.8.9.0 )
	mp3? ( media-sound/mpg123 )
	mpeg? ( media-libs/libmpeg2 )
	mtp? ( media-libs/libmtp:= )
	musepack? ( media-sound/musepack-tools )
	ncurses? ( sys-libs/ncurses:=[unicode(+)] )
	nfs? ( >=net-fs/libnfs-0.10.0:= )
	ogg? ( media-libs/libogg )
	opus? ( >=media-libs/opus-1.0.3 )
	png? ( media-libs/libpng:0= )
	projectm? (
		media-fonts/dejavu
		>=media-libs/libprojectm-3.1.12:0=
	)
	pulseaudio? ( media-sound/pulseaudio )
	rdp? ( >=net-misc/freerdp-2.0.0_rc0:=[client(+)] )
	samba? ( >=net-fs/samba-4.0.0:0[client,-debug(-)] )
	sdl-image? ( media-libs/sdl-image )
	sftp? ( net-libs/libssh2 )
	shout? ( media-libs/libshout )
	sid? ( media-libs/libsidplay:2 )
	skins? (
		x11-libs/libXext
		x11-libs/libXinerama
		x11-libs/libXpm
	)
	soxr? ( >=media-libs/soxr-0.1.2 )
	speex? (
		>=media-libs/speex-1.2.0
		media-libs/speexdsp
	)
	srt? ( >=net-libs/srt-1.4.2:= )
	ssl? ( net-libs/gnutls:= )
	svg? (
		gnome-base/librsvg:2
		x11-libs/cairo
	)
	taglib? ( >=media-libs/taglib-1.9 )
	theora? ( media-libs/libtheora )
	tremor? ( media-libs/tremor )
	truetype? (
		media-libs/freetype:2
		virtual/ttf-fonts
		!fontconfig? ( media-fonts/dejavu )
	)
	twolame? ( media-sound/twolame )
	udev? ( virtual/udev )
	upnp? ( net-libs/libupnp:=[ipv6] )
	v4l? ( media-libs/libv4l:= )
	vaapi? ( x11-libs/libva:=[drm(+),wayland?,X?] )
	vdpau? ( x11-libs/libvdpau )
	vnc? ( net-libs/libvncserver )
	vpx? ( media-libs/libvpx:= )
	wayland? (
		>=dev-libs/wayland-1.15
		dev-libs/wayland-protocols
	)
	X? (
		x11-libs/libX11
		x11-libs/libxcb
		x11-libs/xcb-util
		x11-libs/xcb-util-keysyms
	)
	x264? ( >=media-libs/x264-0.0.20190214:= )
	x265? ( media-libs/x265:= )
	xml? ( dev-libs/libxml2:2 )
	zeroconf? ( net-dns/avahi[dbus] )
	zvbi? ( media-libs/zvbi )
"
DEPEND="${RDEPEND}
	X? ( x11-base/xorg-proto )
"

PATCHES=(
	"${FILESDIR}"/${PN}-2.1.0-fix-libtremor-libs.patch # build system
	"${FILESDIR}"/${PN}-2.2.8-freerdp-2.patch # bug 590164
	"${FILESDIR}"/${PN}-3.0.6-fdk-aac-2.0.0.patch # bug 672290
	"${FILESDIR}"/${PN}-3.0.11.1-configure_lua_version.patch
	"${FILESDIR}"/${PN}-3.0.14-fix-live-address-api.patch # bug 835072
	"${FILESDIR}"/${PN}-3.0.17.3-dav1d-1.0.0.patch # bug 835787
)

DOCS=( AUTHORS THANKS NEWS README doc/fortunes.txt )

S="${WORKDIR}/${MY_P}"

pkg_setup() {
	if use lua; then
		lua-single_pkg_setup
	fi
}

src_prepare() {
	xdg_src_prepare # bug 608256

	has_version 'net-libs/libupnp:1.8' && \
		eapply "${FILESDIR}"/${PN}-2.2.8-libupnp-slot-1.8.patch

	# Bootstrap when we are on a git checkout.
	if [[ ${PV} = *9999 ]] ; then
		./bootstrap
	fi

	# Make it build with libtool 1.5
	rm m4/lt* m4/libtool.m4 || die

	# We are not in a real git checkout due to the absence of a .git directory.
	touch src/revision.txt || die

	# Don't use --started-from-file when not using dbus.
	if ! use dbus ; then
		sed -i 's/ --started-from-file//' share/vlc.desktop.in || die
	fi

	# Disable running of vlc-cache-gen, we do that in pkg_postinst
	sed -e "/test.*build.*host/s/\$(host)/nothanks/" \
		-i Makefile.am -i bin/Makefile.am || die "Failed to disable vlc-cache-gen"

	# Fix gettext version mismatch errors.
	sed -i -e s/GETTEXT_VERSION/GETTEXT_REQUIRE_VERSION/ configure.ac || die

	eautoreconf

	# Disable automatic running of tests.
	find . -name 'Makefile.in' -exec sed -i 's/\(..*\)check-TESTS/\1/' {} \; || die
}

src_configure() {
	local -x BUILDCC="$(tc-getBUILD_CC)"

	local myeconfargs=(
		--disable-aa
		--disable-optimizations
		--disable-rpath
		--disable-update-check
		--enable-fast-install
		--enable-screen
		--enable-vcd
		--enable-vlc
		--enable-vorbis
		$(use_enable a52)
		$(use_enable alsa)
		$(use_enable aom)
		$(use_enable archive)
		$(use_enable aribsub)
		$(use_enable bidi fribidi)
		$(use_enable bidi harfbuzz)
		$(use_enable bluray)
		$(use_enable cddb libcddb)
		$(use_enable chromaprint)
		$(use_enable chromecast)
		$(use_enable chromecast microdns)
		$(use_enable cpu_flags_arm_neon neon)
		$(use_enable cpu_flags_ppc_altivec altivec)
		$(use_enable cpu_flags_x86_mmx mmx)
		$(use_enable cpu_flags_x86_sse sse)
		$(use_enable dav1d)
		$(use_enable dbus)
		$(use_enable dbus kwallet)
		$(use_enable dc1394)
		$(use_enable debug)
		$(use_enable directx)
		$(use_enable directx d3d11va)
		$(use_enable directx dxva2)
		$(use_enable dts dca)
		$(use_enable dvbpsi)
		$(use_enable dvd dvdnav)
		$(use_enable dvd dvdread)
		$(use_enable encode sout)
		$(use_enable encode vlm)
		$(use_enable faad)
		$(use_enable fdk fdkaac)
		$(use_enable ffmpeg avcodec)
		$(use_enable ffmpeg avformat)
		$(use_enable ffmpeg postproc)
		$(use_enable ffmpeg swscale)
		$(use_enable flac)
		$(use_enable fluidsynth)
		$(use_enable fontconfig)
		$(use_enable gcrypt libgcrypt)
		$(use_enable gme)
		$(use_enable gnome-keyring secret)
		$(use_enable gstreamer gst-decode)
		$(use_enable gui qt)
		$(use_enable ieee1394 dv1394)
		$(use_enable jack)
		$(use_enable jpeg)
		$(use_enable kate)
		$(use_enable libass)
		$(use_enable libcaca caca)
		$(use_enable libnotify notify)
		$(use_enable libsamplerate samplerate)
		$(use_enable libtar)
		$(use_enable libtiger tiger)
		$(use_enable linsys)
		$(use_enable lirc)
		$(use_enable live live555)
		$(use_enable lua)
		$(use_enable macosx-notifications osx-notifications)
		$(use_enable mad)
		$(use_enable matroska)
		$(use_enable modplug mod)
		$(use_enable mp3 mpg123)
		$(use_enable mpeg libmpeg2)
		$(use_enable mtp)
		$(use_enable musepack mpc)
		$(use_enable ncurses)
		$(use_enable nfs)
		$(use_enable ogg)
		$(use_enable omxil)
		$(use_enable omxil omxil-vout)
		$(use_enable optimisememory optimize-memory)
		$(use_enable opus)
		$(use_enable png)
		$(use_enable projectm)
		$(use_enable pulseaudio pulse)
		$(use_enable rdp freerdp)
		$(use_enable run-as-root)
		$(use_enable samba smbclient)
		$(use_enable sdl-image)
		$(use_enable sftp)
		$(use_enable shout)
		$(use_enable sid)
		$(use_enable skins skins2)
		$(use_enable soxr)
		$(use_enable speex)
		$(use_enable srt)
		$(use_enable ssl gnutls)
		$(use_enable svg)
		$(use_enable svg svgdec)
		$(use_enable taglib)
		$(use_enable theora)
		$(use_enable tremor)
		$(use_enable twolame)
		$(use_enable udev)
		$(use_enable upnp)
		$(use_enable v4l v4l2)
		$(use_enable vaapi libva)
		$(use_enable vdpau)
		$(use_enable vnc)
		$(use_enable vpx)
		$(use_enable wayland)
		$(use_with X x)
		$(use_enable X xcb)
		$(use_enable X xvideo)
		$(use_enable x264)
		$(use_enable x264 x26410b)
		$(use_enable x265)
		$(use_enable xml libxml2)
		$(use_enable zeroconf avahi)
		$(use_enable zvbi)
		$(use_enable !zvbi telx)
		--with-kde-solid="${EPREFIX}"/usr/share/solid/actions
		--disable-asdcp
		--disable-coverage
		--disable-cprof
		--disable-crystalhd
		--disable-decklink
		--disable-gles2
		--disable-goom
		--disable-kai
		--disable-kva
		--disable-libplacebo
		--disable-maintainer-mode
		--disable-merge-ffmpeg
		--disable-mfx
		--disable-mmal
		--disable-opencv
		--disable-opensles
		--disable-oss
		--disable-rpi-omxil
		--disable-schroedinger
		--disable-shine
		--disable-sndio
		--disable-spatialaudio
		--disable-vsxu
		--disable-wasapi
		--disable-wma-fixed
	)
	# ^ We don't have these disabled libraries in the Portage tree yet.

	# Compatibility fix for Samba 4.
	use samba && append-cppflags "-I/usr/include/samba-4.0"

	if use x86; then
		# We need to disable -fstack-check if use >=gcc 4.8.0. bug #499996
		append-cflags $(test-flags-CC -fno-stack-check)
		# Bug 569774
		replace-flags -Os -O2
	fi

	if use omxil; then
		# bug #723006
		# https://trac.videolan.org/vlc/ticket/24617
		append-cflags -fcommon
	fi

	# FIXME: Needs libresid-builder from libsidplay:2 which is in another directory...
	append-ldflags "-L${ESYSROOT}/usr/$(get_libdir)/sidplay/builders/"

	if use riscv; then
		# bug #803473
		append-libs -latomic
	fi

	if use truetype || use bidi; then
		myeconfargs+=( --enable-freetype )
	else
		myeconfargs+=( --disable-freetype )
	fi

	if use truetype || use projectm; then
		local dejavu="${EPREFIX}/usr/share/fonts/dejavu/"
		myeconfargs+=(
			--with-default-font=${dejavu}/DejaVuSans.ttf
			--with-default-font-family=Sans
			--with-default-monospace-font=${dejavu}/DejaVuSansMono.ttf
			--with-default-monospace-font-family=Monospace
		)
	fi

	econf "${myeconfargs[@]}"

	# _FORTIFY_SOURCE is set to 2 in config.h, which is also the default value on Gentoo.
	# Other values may break the build (bug 523144), so definition should not be removed.
	# To prevent redefinition warnings, we undefine _FORTIFY_SOURCE at the start of config.h
	sed -i '1i#undef _FORTIFY_SOURCE' config.h || die
}

src_test() {
	virtx emake check-TESTS
}

src_install() {
	default
	find "${ED}" -name '*.la' -delete || die
}

pkg_postinst() {
	if [[ -z "${ROOT}" ]] && [[ -x "${EROOT}/usr/$(get_libdir)/vlc/vlc-cache-gen" ]] ; then
		einfo "Running ${EPREFIX}/usr/$(get_libdir)/vlc/vlc-cache-gen on ${EROOT}/usr/$(get_libdir)/vlc/plugins/"
		"${EPREFIX}/usr/$(get_libdir)/vlc/vlc-cache-gen" "${EROOT}/usr/$(get_libdir)/vlc/plugins/"
	else
		ewarn "We cannot run vlc-cache-gen (most likely ROOT != /)"
		ewarn "Please run ${EPREFIX}/usr/$(get_libdir)/vlc/vlc-cache-gen manually"
		ewarn "If you do not do it, vlc will take a long time to load."
	fi

	xdg_pkg_postinst
}

pkg_postrm() {
	if [[ -e "${EROOT}"/usr/$(get_libdir)/vlc/plugins/plugins.dat ]]; then
		rm "${EROOT}"/usr/$(get_libdir)/vlc/plugins/plugins.dat || die "Failed to rm plugins.dat"
	fi

	xdg_pkg_postrm
}

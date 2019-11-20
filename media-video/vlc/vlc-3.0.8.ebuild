# Copyright 2000-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PV="${PV/_/-}"
MY_PV="${MY_PV/-beta/-test}"
MY_P="${PN}-${MY_PV}"
if [[ ${PV} = *9999 ]] ; then
	if [[ ${PV%.9999} != ${PV} ]] ; then
		EGIT_REPO_URI="https://git.videolan.org/git/vlc/vlc-${PV%.9999}.git"
	else
		EGIT_REPO_URI="https://git.videolan.org/git/vlc.git"
	fi
	inherit git-r3
else
	if [[ ${MY_P} = ${P} ]] ; then
		SRC_URI="https://download.videolan.org/pub/videolan/${PN}/${PV}/${P}.tar.xz"
	else
		SRC_URI="https://download.videolan.org/pub/videolan/testing/${MY_P}/${MY_P}.tar.xz"
	fi
	KEYWORDS="amd64 ~arm arm64 ppc ppc64 -sparc x86"
fi
inherit autotools flag-o-matic toolchain-funcs virtualx xdg

DESCRIPTION="Media player and framework with support for most multimedia files and streaming"
HOMEPAGE="https://www.videolan.org/vlc/"

LICENSE="LGPL-2.1 GPL-2"
SLOT="0/5-9" # vlc - vlccore

IUSE="a52 alsa altivec aom archive aribsub bidi bluray cddb chromaprint chromecast
	dav1d dbus dc1394 debug directx dts +dvbpsi dvd +encode faad fdk +ffmpeg flac
	fluidsynth fontconfig +gcrypt gme gnome-keyring gstreamer ieee1394 jack jpeg kate
	libass libav libcaca libnotify +libsamplerate libtar libtiger linsys lirc
	live lua macosx-notifications mad matroska modplug mp3 mpeg mtp musepack ncurses
	nfs ogg omxil opencv optimisememory opus png postproc projectm pulseaudio +qt5 rdp
	run-as-root samba sdl-image sftp shout sid skins soxr speex srt ssl svg taglib
	theora tremor truetype twolame udev upnp vaapi v4l vdpau vnc vorbis vpx wayland +X
	x264 x265 xml zeroconf zvbi cpu_flags_arm_neon cpu_flags_x86_mmx cpu_flags_x86_sse
"
REQUIRED_USE="
	chromecast? ( encode )
	directx? ( ffmpeg )
	fontconfig? ( truetype )
	libcaca? ( X )
	libtar? ( skins )
	libtiger? ( kate )
	postproc? ( ffmpeg )
	skins? ( qt5 truetype X xml )
	ssl? ( gcrypt )
	vaapi? ( ffmpeg X )
	vdpau? ( ffmpeg X )
"
BDEPEND="
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
	amd64? ( dev-lang/yasm )
	x86? ( dev-lang/yasm )
"
RDEPEND="
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
		media-libs/harfbuzz
		virtual/ttf-fonts
	)
	bluray? ( media-libs/libbluray:= )
	cddb? ( media-libs/libcddb )
	chromaprint? ( media-libs/chromaprint:= )
	chromecast? (
		>=dev-libs/protobuf-2.5.0:=
		>=net-libs/libmicrodns-0.0.9:=
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
		>=media-libs/libdvdnav-4.9:0=
		>=media-libs/libdvdread-4.9:0=
	)
	faad? ( media-libs/faad2 )
	fdk? ( media-libs/fdk-aac:= )
	ffmpeg? (
		!libav? ( >=media-video/ffmpeg-3.1.3:0=[vaapi?,vdpau?] )
		libav? ( >=media-video/libav-12.2:0=[vaapi?,vdpau?] )
	)
	flac? (
		media-libs/flac
		media-libs/libogg
	)
	fluidsynth? ( media-sound/fluidsynth:= )
	fontconfig? ( media-libs/fontconfig:1.0 )
	gcrypt? (
		dev-libs/libgcrypt:0=
		dev-libs/libgpg-error
	)
	gme? ( media-libs/game-music-emu )
	gnome-keyring? ( app-crypt/libsecret )
	gstreamer? ( >=media-libs/gst-plugins-base-1.4.5:1.0 )
	ieee1394? (
		sys-libs/libavc1394
		sys-libs/libraw1394
	)
	jack? ( virtual/jack )
	jpeg? ( virtual/jpeg:0 )
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
	lua? ( >=dev-lang/lua-5.1:0= )
	mad? ( media-libs/libmad )
	matroska? (
		>=dev-libs/libebml-1.3.6:=
		media-libs/libmatroska:=
	)
	modplug? ( >=media-libs/libmodplug-0.8.9.0 )
	mp3? ( media-sound/mpg123 )
	mpeg? ( media-libs/libmpeg2 )
	mtp? ( media-libs/libmtp:= )
	musepack? ( media-sound/musepack-tools )
	ncurses? ( sys-libs/ncurses:0=[unicode] )
	nfs? ( >=net-fs/libnfs-0.10.0:= )
	ogg? ( media-libs/libogg )
	opencv? ( media-libs/opencv:= )
	opus? ( >=media-libs/opus-1.0.3 )
	png? ( media-libs/libpng:0= )
	postproc? ( libav? ( media-libs/libpostproc ) )
	projectm? (
		media-fonts/dejavu
		media-libs/libprojectm
	)
	pulseaudio? ( media-sound/pulseaudio )
	qt5? (
		dev-qt/qtcore:5
		dev-qt/qtgui:5
		dev-qt/qtsvg:5
		dev-qt/qtwidgets:5
		X? (
			dev-qt/qtx11extras:5
			x11-libs/libX11
		)
	)
	rdp? ( >=net-misc/freerdp-2.0.0_rc0:=[client] )
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
	srt? ( net-libs/srt )
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
	upnp? ( net-libs/libupnp:= )
	v4l? ( media-libs/libv4l:= )
	vaapi? ( x11-libs/libva:=[drm,wayland?,X?] )
	vdpau? ( x11-libs/libvdpau )
	vnc? ( net-libs/libvncserver )
	vorbis? ( media-libs/libvorbis )
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
)

DOCS=( AUTHORS THANKS NEWS README doc/fortunes.txt )

S="${WORKDIR}/${MY_P}"

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

	eautoreconf

	# Disable automatic running of tests.
	find . -name 'Makefile.in' -exec sed -i 's/\(..*\)check-TESTS/\1/' {} \; || die
}

src_configure() {
	local myeconfargs=(
		--disable-aa
		--disable-dependency-tracking
		--disable-optimizations
		--disable-rpath
		--disable-update-check
		--enable-fast-install
		--enable-screen
		--enable-vcd
		--enable-vlc
		$(use_enable a52)
		$(use_enable alsa)
		$(use_enable altivec)
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
		$(use_enable ffmpeg swscale)
		$(use_enable flac)
		$(use_enable fluidsynth)
		$(use_enable fontconfig)
		$(use_enable gcrypt libgcrypt)
		$(use_enable gme)
		$(use_enable gnome-keyring secret)
		$(use_enable gstreamer gst-decode)
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
		$(use_enable ogg)
		$(use_enable omxil)
		$(use_enable omxil omxil-vout)
		$(use_enable opencv)
		$(use_enable optimisememory optimize-memory)
		$(use_enable opus)
		$(use_enable png)
		$(use_enable postproc)
		$(use_enable projectm)
		$(use_enable pulseaudio pulse)
		$(use_enable qt5 qt)
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
		$(use_enable vorbis)
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
		--disable-macosx-qtkit
		--disable-maintainer-mode
		--disable-merge-ffmpeg
		--disable-mfx
		--disable-mmal
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

	# VLC now requires C++11 after commit 4b1c9dcdda0bbff801e47505ff9dfd3f274eb0d8
	append-cxxflags -std=c++11

	# FIXME: Needs libresid-builder from libsidplay:2 which is in another directory...
	append-ldflags "-L/usr/$(get_libdir)/sidplay/builders/"

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
	find "${D}" -name '*.la' -delete || die
}

pkg_postinst() {
	if [[ -z ${ROOT} ]] && [[ -x "/usr/$(get_libdir)/vlc/vlc-cache-gen" ]] ; then
		einfo "Running /usr/$(get_libdir)/vlc/vlc-cache-gen on /usr/$(get_libdir)/vlc/plugins/"
		"/usr/$(get_libdir)/vlc/vlc-cache-gen" "/usr/$(get_libdir)/vlc/plugins/"
	else
		ewarn "We cannot run vlc-cache-gen (most likely ROOT!=/)"
		ewarn "Please run /usr/$(get_libdir)/vlc/vlc-cache-gen manually"
		ewarn "If you do not do it, vlc will take a long time to load."
	fi

	xdg_pkg_postinst
}

pkg_postrm() {
	if [[ -e /usr/$(get_libdir)/vlc/plugins/plugins.dat ]]; then
		rm /usr/$(get_libdir)/vlc/plugins/plugins.dat || die "Failed to rm plugins.dat"
	fi

	xdg_pkg_postrm
}

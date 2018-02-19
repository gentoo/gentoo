# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

MY_PV="${PV/_/-}"
MY_PV="${MY_PV/-beta/-test}"
MY_P="${PN}-${MY_PV}"
if [[ ${PV} = *9999 ]] ; then
	if [[ ${PV%.9999} != ${PV} ]] ; then
		EGIT_REPO_URI="https://git.videolan.org/git/vlc/vlc-${PV%.9999}.git"
	else
		EGIT_REPO_URI="https://git.videolan.org/git/vlc.git"
	fi
	SCM="git-r3"
else
	if [[ ${MY_P} = ${P} ]] ; then
		SRC_URI="https://download.videolan.org/pub/videolan/${PN}/${PV}/${P}.tar.xz"
	else
		SRC_URI="https://download.videolan.org/pub/videolan/testing/${MY_P}/${MY_P}.tar.xz"
	fi
	KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 -sparc ~x86 ~x86-fbsd"
fi
inherit autotools flag-o-matic gnome2-utils toolchain-funcs versionator virtualx xdg-utils ${SCM}

DESCRIPTION="Media player and framework with support for most multimedia files and streaming"
HOMEPAGE="https://www.videolan.org/vlc/"

LICENSE="LGPL-2.1 GPL-2"
SLOT="0/5-9" # vlc - vlccore

IUSE="a52 alsa altivec aom archive bidi bluray cddb chromaprint chromecast dbus dc1394
	debug directx dts +dvbpsi dvd +encode faad fdk +ffmpeg flac fluidsynth fontconfig
	+gcrypt gme gnome-keyring gstreamer ieee1394 jack jpeg kate libass libav libcaca
	libnotify +libsamplerate libtar libtiger linsys lirc live lua macosx-notifications
	macosx-qtkit matroska modplug mp3 mpeg mtp musepack ncurses neon nfs ogg omxil opencv
	optimisememory opus png postproc projectm pulseaudio +qt5 rdp rtsp run-as-root
	samba schroedinger sdl-image sftp shout sid skins speex ssl svg taglib theora tremor
	truetype twolame udev upnp vaapi v4l vcd vdpau vnc vorbis vpx wayland wma-fixed +X
	x264 x265 xml zeroconf zvbi cpu_flags_x86_mmx cpu_flags_x86_sse
"
REQUIRED_USE="
	bidi? ( truetype )
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
RDEPEND="
	net-dns/libidn:0
	sys-libs/zlib:0[minizip]
	virtual/libintl:0
	virtual/opengl
	a52? ( media-libs/a52dec:0 )
	alsa? ( media-libs/alsa-lib:0 )
	aom? ( media-libs/libaom:= )
	archive? ( app-arch/libarchive:= )
	bidi? ( dev-libs/fribidi:0 )
	bluray? ( media-libs/libbluray:0= )
	cddb? ( media-libs/libcddb:0 )
	chromaprint? ( media-libs/chromaprint:0= )
	chromecast? ( >=dev-libs/protobuf-2.5.0:= )
	dbus? ( sys-apps/dbus:0 )
	dc1394? (
		media-libs/libdc1394:2
		sys-libs/libraw1394:0
	)
	dts? ( media-libs/libdca:0 )
	dvbpsi? ( >=media-libs/libdvbpsi-1.2.0:0= )
	dvd? (
		>=media-libs/libdvdnav-4.9:0
		>=media-libs/libdvdread-4.9:0
	)
	faad? ( media-libs/faad2:0 )
	fdk? ( media-libs/fdk-aac:0= )
	ffmpeg? (
		!libav? ( >=media-video/ffmpeg-3.1.3:0=[vaapi?,vdpau?] )
		libav? ( >=media-video/libav-11.8:0=[vaapi?,vdpau?] )
	)
	flac? (
		media-libs/flac:0
		media-libs/libogg:0
	)
	fluidsynth? ( media-sound/fluidsynth:0 )
	fontconfig? ( media-libs/fontconfig:1.0 )
	gcrypt? (
		dev-libs/libgcrypt:0=
		dev-libs/libgpg-error:0
	)
	gme? ( media-libs/game-music-emu:0 )
	gnome-keyring? ( app-crypt/libsecret )
	gstreamer? ( >=media-libs/gst-plugins-base-1.4.5:1.0 )
	ieee1394? (
		sys-libs/libavc1394:0
		sys-libs/libraw1394:0
	)
	jack? ( virtual/jack )
	jpeg? ( virtual/jpeg:0 )
	kate? ( media-libs/libkate:0 )
	libass? (
		media-libs/fontconfig:1.0
		media-libs/libass:0=
	)
	libcaca? ( media-libs/libcaca:0 )
	libnotify? (
		dev-libs/glib:2
		x11-libs/gdk-pixbuf:2
		x11-libs/gtk+:3
		x11-libs/libnotify:0
	)
	libsamplerate? ( media-libs/libsamplerate:0 )
	libtar? ( dev-libs/libtar:0 )
	libtiger? ( media-libs/libtiger:0 )
	linsys? ( media-libs/zvbi )
	lirc? ( app-misc/lirc:0 )
	live? ( media-plugins/live:0 )
	lua? ( >=dev-lang/lua-5.1:0 )
	matroska? (
		dev-libs/libebml:0=
		media-libs/libmatroska:0=
	)
	modplug? ( media-libs/libmodplug:0 )
	mp3? ( media-libs/libmad:0 )
	mpeg? ( media-libs/libmpeg2:0 )
	mtp? ( media-libs/libmtp:0= )
	musepack? ( media-sound/musepack-tools:0 )
	ncurses? ( sys-libs/ncurses:0=[unicode] )
	nfs? ( >=net-fs/libnfs-0.10.0:= )
	ogg? ( media-libs/libogg:0 )
	opencv? ( media-libs/opencv:0= )
	opus? ( >=media-libs/opus-1.0.3:0 )
	png? ( media-libs/libpng:0= )
	postproc? ( libav? ( media-libs/libpostproc:0= ) )
	projectm? (
		media-fonts/dejavu:0
		media-libs/libprojectm:0
	)
	pulseaudio? ( media-sound/pulseaudio:0 )
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
	rdp? ( >=net-misc/freerdp-2.0.0_rc0:0=[client] )
	samba? ( >=net-fs/samba-4.0.0:0[client,-debug(-)] )
	schroedinger? ( >=media-libs/schroedinger-1.0.10:0 )
	sdl-image? ( media-libs/sdl-image:0 )
	sftp? ( net-libs/libssh2:0 )
	shout? ( media-libs/libshout:0 )
	sid? ( media-libs/libsidplay:2 )
	skins? (
		x11-libs/libXext:0
		x11-libs/libXinerama:0
		x11-libs/libXpm:0
	)
	speex? (
		>=media-libs/speex-1.2.0:0
		media-libs/speexdsp:0
	)
	ssl? ( net-libs/gnutls:0 )
	svg? (
		gnome-base/librsvg:2
		x11-libs/cairo:0
	)
	taglib? ( >=media-libs/taglib-1.9:0 )
	theora? ( media-libs/libtheora:0 )
	tremor? ( media-libs/tremor:0 )
	truetype? (
		media-libs/freetype:2
		virtual/ttf-fonts:0
		!fontconfig? ( media-fonts/dejavu:0 )
	)
	twolame? ( media-sound/twolame:0 )
	udev? ( virtual/udev:0 )
	upnp? ( net-libs/libupnp:= )
	v4l? ( media-libs/libv4l:0 )
	vaapi? ( x11-libs/libva:0=[drm,wayland?,X?] )
	vcd? ( >=dev-libs/libcdio-0.78.2:0 )
	vdpau? ( x11-libs/libvdpau:0 )
	vnc? ( net-libs/libvncserver:0 )
	vorbis? ( media-libs/libvorbis:0 )
	vpx? ( media-libs/libvpx:0= )
	wayland? (
		dev-libs/wayland
		dev-libs/wayland-protocols
	)
	X? (
		x11-libs/libX11
		x11-libs/libxcb
		x11-libs/libXcursor
		x11-libs/xcb-util
		x11-libs/xcb-util-keysyms
	)
	x264? ( media-libs/x264:0= )
	x265? ( media-libs/x265:0= )
	xml? ( dev-libs/libxml2:2 )
	zeroconf? ( net-dns/avahi:0[dbus] )
	zvbi? ( media-libs/zvbi )
"
DEPEND="${RDEPEND}
	>=sys-devel/gettext-0.19.8:*
	virtual/pkgconfig:*
	amd64? ( dev-lang/yasm:* )
	x86? ( dev-lang/yasm:* )
	X? ( x11-proto/xproto )
"

PATCHES=(
	"${FILESDIR}"/${PN}-2.1.0-fix-libtremor-libs.patch # build system
	"${FILESDIR}"/${PN}-2.2.4-libav-11.7.patch # bug #593460
	"${FILESDIR}"/${PN}-2.2.8-freerdp-2.patch # bug 590164
)

DOCS=( AUTHORS THANKS NEWS README doc/fortunes.txt )

S="${WORKDIR}/${MY_P}"

src_prepare() {
	default

	has_version '>=net-libs/libupnp-1.8.0' && \
		eapply "${FILESDIR}"/${P}-libupnp-slot-1.8.patch

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
		--disable-dependency-tracking
		--disable-optimizations
		--disable-update-check
		--enable-fast-install
		--enable-screen
		--enable-vlc
		$(use_enable a52)
		$(use_enable alsa)
		$(use_enable altivec)
		$(use_enable aom)
		$(use_enable archive)
		$(use_enable bidi fribidi)
		$(use_enable bluray)
		$(use_enable cddb libcddb)
		$(use_enable chromaprint)
		$(use_enable chromecast)
		$(use_enable cpu_flags_x86_mmx mmx)
		$(use_enable cpu_flags_x86_sse sse)
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
		$(use_enable macosx-qtkit)
		$(use_enable modplug mod)
		$(use_enable mp3 mad)
		$(use_enable mpeg libmpeg2)
		$(use_enable mtp)
		$(use_enable musepack mpc)
		$(use_enable ncurses)
		$(use_enable neon)
		$(use_enable ogg)
		$(use_enable omxil)
		$(use_enable opencv)
		$(use_enable optimisememory optimize-memory)
		$(use_enable opus)
		$(use_enable png)
		$(use_enable postproc)
		$(use_enable projectm)
		$(use_enable pulseaudio pulse)
		$(use_enable qt5 qt)
		$(use_enable rdp freerdp)
		$(use_enable rtsp realrtsp)
		$(use_enable run-as-root)
		$(use_enable samba smbclient)
		$(use_enable schroedinger)
		$(use_enable sdl-image)
		$(use_enable sftp)
		$(use_enable shout)
		$(use_enable sid)
		$(use_enable skins skins2)
		$(use_enable speex)
		$(use_enable ssl gnutls)
		$(use_enable svg)
		$(use_enable svg svgdec)
		$(use_enable taglib)
		$(use_enable theora)
		$(use_enable tremor)
		$(use_enable truetype freetype)
		$(use_enable twolame)
		$(use_enable udev)
		$(use_enable upnp)
		$(use_enable v4l v4l2)
		$(use_enable vaapi libva)
		$(use_enable vcd)
		$(use_enable vdpau)
		$(use_enable vnc)
		$(use_enable vorbis)
		$(use_enable vpx)
		$(use_enable wayland)
		$(use_enable wma-fixed)
		$(use_with X x)
		$(use_enable X xcb)
		$(use_enable X xvideo)
		$(use_enable x264)
		$(use_enable x265)
		$(use_enable xml libxml2)
		$(use_enable zeroconf avahi)
		$(use_enable zvbi)
		$(use_enable !zvbi telx)
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
		--disable-opensles
		--disable-oss
		--disable-rpi-omxil
		--disable-shine
		--disable-sndio
		--disable-spatialaudio
		--disable-srt
		--disable-vsxu
		--disable-wasapi
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

	xdg_environment_reset # bug 608256

	if use truetype || use projectm ; then
		local dejavu="/usr/share/fonts/dejavu/"
		myeconfargs+=(
			--with-default-font=${dejavu}/DejaVuSans.ttf
			--with-default-font-family=Sans
			--with-default-monospace-font=${dejavu}/DejaVuSansMono.ttf
			--with-default-monospace-font-family=Monospace
		)
	fi

	econf ${myeconfargs[@]}

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
	if [[ "$ROOT" = "/" ]] && [[ -x "/usr/$(get_libdir)/vlc/vlc-cache-gen" ]] ; then
		einfo "Running /usr/$(get_libdir)/vlc/vlc-cache-gen on /usr/$(get_libdir)/vlc/plugins/"
		"/usr/$(get_libdir)/vlc/vlc-cache-gen" "/usr/$(get_libdir)/vlc/plugins/"
	else
		ewarn "We cannot run vlc-cache-gen (most likely ROOT!=/)"
		ewarn "Please run /usr/$(get_libdir)/vlc/vlc-cache-gen manually"
		ewarn "If you do not do it, vlc will take a long time to load."
	fi

	gnome2_icon_cache_update
	xdg_mimeinfo_database_update
	xdg_desktop_database_update
}

pkg_postrm() {
	if [[ -e /usr/$(get_libdir)/vlc/plugins/plugins.dat ]]; then
		rm /usr/$(get_libdir)/vlc/plugins/plugins.dat || die "Failed to rm plugins.dat"
	fi

	gnome2_icon_cache_update
	xdg_mimeinfo_database_update
	xdg_desktop_database_update
}

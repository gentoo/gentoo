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
	KEYWORDS="amd64 ~arm ~arm64 ppc ppc64 -sparc x86 ~x86-fbsd"
fi
inherit autotools flag-o-matic gnome2-utils toolchain-funcs versionator virtualx xdg-utils ${SCM}

DESCRIPTION="Media player and framework with support for most multimedia files and streaming"
HOMEPAGE="https://www.videolan.org/vlc/"

LICENSE="LGPL-2.1 GPL-2"
SLOT="0/5-8" # vlc - vlccore

IUSE="a52 aalib alsa altivec atmo +audioqueue +avcodec +avformat bidi bluray cdda
	cddb chromaprint dbus dc1394 debug directx dts dvb +dvbpsi dvd dxva2
	elibc_glibc +encode faad fdk fluidsynth +ffmpeg flac fontconfig +gcrypt gme
	gnome gnutls growl gstreamer httpd ieee1394 jack jpeg kate libass libav
	libcaca libnotify +libsamplerate libtiger linsys libtar lirc live lua
	macosx-dialog-provider macosx-eyetv macosx-quartztext macosx-qtkit
	matroska cpu_flags_x86_mmx modplug mp3 mpeg mtp musepack ncurses neon ogg
	omxil opencv opengl optimisememory opus png postproc projectm pulseaudio
	+qt5 rdp rtsp run-as-root samba schroedinger sdl sdl-image sftp shout
	sid skins speex cpu_flags_x86_sse svg +swscale taglib theora tremor truetype
	twolame udev upnp vaapi v4l vcdx vdpau vlm vnc vorbis vpx wma-fixed +X
	x264 x265 +xcb xml xv zeroconf zvbi
"
REQUIRED_USE="
	aalib? ( X )
	bidi? ( truetype )
	cddb? ( cdda )
	dvb? ( dvbpsi )
	dxva2? ( avcodec )
	ffmpeg? ( avcodec avformat swscale )
	fontconfig? ( truetype )
	gnutls? ( gcrypt )
	httpd? ( lua )
	libcaca? ( X )
	libtar? ( skins )
	libtiger? ( kate )
	qt5? ( X )
	sdl? ( X )
	skins? ( qt5 truetype X xml )
	vaapi? ( avcodec X )
	vdpau? ( X )
	vlm? ( encode )
	xv? ( xcb )
"
RDEPEND="
	dev-libs/libgpg-error:0
	net-dns/libidn:0
	sys-libs/zlib:0[minizip]
	virtual/libintl:0
	a52? ( >=media-libs/a52dec-0.7.4-r3:0 )
	aalib? ( media-libs/aalib:0 )
	alsa? ( >=media-libs/alsa-lib-1.0.24:0 )
	avcodec? (
		!libav? ( media-video/ffmpeg:0= )
		libav? ( media-video/libav:0= )
	)
	avformat? (
		!libav? ( media-video/ffmpeg:0= )
		libav? ( media-video/libav:0= )
	)
	bidi? ( dev-libs/fribidi:0 )
	bluray? ( >=media-libs/libbluray-0.3:0= )
	cddb? ( >=media-libs/libcddb-1.2:0 )
	chromaprint? ( >=media-libs/chromaprint-0.6:0 )
	dbus? ( >=sys-apps/dbus-1.6:0 )
	dc1394? ( >=sys-libs/libraw1394-2.0.1:0 >=media-libs/libdc1394-2.1:2 )
	dts? ( >=media-libs/libdca-0.0.5:0 )
	dvbpsi? ( >=media-libs/libdvbpsi-1.0.0:0= )
	dvd? ( >=media-libs/libdvdread-4.9:0 >=media-libs/libdvdnav-4.9:0 )
	elibc_glibc? ( >=sys-libs/glibc-2.8:2.2 )
	faad? ( >=media-libs/faad2-2.6.1:0 )
	fdk? ( media-libs/fdk-aac:0 )
	flac? ( >=media-libs/libogg-1:0 >=media-libs/flac-1.1.2:0 )
	fluidsynth? ( >=media-sound/fluidsynth-1.1.2:0 )
	fontconfig? ( media-libs/fontconfig:1.0 )
	gcrypt? ( >=dev-libs/libgcrypt-1.2.0:0= )
	gme? ( media-libs/game-music-emu:0 )
	gnome? ( gnome-base/gnome-vfs:2 dev-libs/glib:2 )
	gnutls? ( >=net-libs/gnutls-3.0.20:0 )
	gstreamer? ( >=media-libs/gst-plugins-base-1.4.5:1.0 )
	ieee1394? ( >=sys-libs/libraw1394-2.0.1:0 >=sys-libs/libavc1394-0.5.3:0 )
	jack? ( virtual/jack )
	jpeg? ( virtual/jpeg:0 )
	kate? ( >=media-libs/libkate-0.3:0 )
	libass? ( >=media-libs/libass-0.9.8:0= media-libs/fontconfig:1.0 )
	libcaca? ( >=media-libs/libcaca-0.99_beta14:0 )
	libnotify? ( x11-libs/libnotify:0 x11-libs/gtk+:2 x11-libs/gdk-pixbuf:2 dev-libs/glib:2 )
	libsamplerate? ( media-libs/libsamplerate:0 )
	libtar? ( >=dev-libs/libtar-1.2.11-r3:0 )
	libtiger? ( >=media-libs/libtiger-0.3.1:0 )
	linsys? ( >=media-libs/zvbi-0.2.28:0 )
	lirc? ( app-misc/lirc:0 )
	live? ( >=media-plugins/live-2011.12.23:0 )
	lua? ( >=dev-lang/lua-5.1:0 )
	matroska? (	>=dev-libs/libebml-1:0= >=media-libs/libmatroska-1:0= )
	modplug? ( >=media-libs/libmodplug-0.8.4:0 !~media-libs/libmodplug-0.8.8 )
	mp3? ( media-libs/libmad:0 )
	mpeg? ( >=media-libs/libmpeg2-0.3.2:0 )
	mtp? ( >=media-libs/libmtp-1:0 )
	musepack? ( >=media-sound/musepack-tools-444:0 )
	ncurses? ( sys-libs/ncurses:0=[unicode] )
	ogg? ( >=media-libs/libogg-1:0 )
	opencv? ( >media-libs/opencv-2:0= )
	opengl? ( virtual/opengl:0 >=x11-libs/libX11-1.3.99.901:0 )
	opus? ( >=media-libs/opus-1.0.3:0 )
	png? ( media-libs/libpng:0= )
	postproc? (
		!libav? ( >=media-video/ffmpeg-2.2:0= )
		libav? ( media-libs/libpostproc:0= )
	)
	projectm? ( media-libs/libprojectm:0 media-fonts/dejavu:0 )
	pulseaudio? ( >=media-sound/pulseaudio-1:0 )
	qt5? ( dev-qt/qtcore:5 dev-qt/qtgui:5 dev-qt/qtwidgets:5 dev-qt/qtx11extras:5 )
	rdp? ( >=net-misc/freerdp-2.0.0_rc0:0=[client] )
	samba? ( >=net-fs/samba-4.0.0:0[client,-debug(-)] )
	schroedinger? ( >=media-libs/schroedinger-1.0.10:0 )
	sdl? ( >=media-libs/libsdl-1.2.10:0
		sdl-image? ( >=media-libs/sdl-image-1.2.10:0 ) )
	sftp? ( net-libs/libssh2:0 )
	shout? ( >=media-libs/libshout-2.1:0 )
	sid? ( media-libs/libsidplay:2 )
	skins? ( x11-libs/libXext:0 x11-libs/libXpm:0 x11-libs/libXinerama:0 )
	speex? ( >=media-libs/speex-1.2.0:0 media-libs/speexdsp:0 )
	svg? ( >=gnome-base/librsvg-2.9:2 >=x11-libs/cairo-1.13.1:0 )
	swscale? (
		!libav? ( media-video/ffmpeg:0= )
		libav? ( media-video/libav:0= )
	)
	taglib? ( >=media-libs/taglib-1.9:0 )
	theora? ( >=media-libs/libtheora-1.0_beta3:0 )
	tremor? ( media-libs/tremor:0 )
	truetype? ( media-libs/freetype:2 virtual/ttf-fonts:0
		!fontconfig? ( media-fonts/dejavu:0 ) )
	twolame? ( media-sound/twolame:0 )
	udev? ( >=virtual/udev-142:0 )
	upnp? ( net-libs/libupnp:= )
	v4l? ( media-libs/libv4l:0 )
	vaapi? (
		x11-libs/libva:0=[X,drm]
		!libav? ( media-video/ffmpeg:0=[vaapi] )
		libav? ( media-video/libav:0=[vaapi] )
	)
	vcdx? ( >=dev-libs/libcdio-0.78.2:0 >=media-video/vcdimager-0.7.22:0 )
	vdpau? (
		x11-libs/libvdpau:0
		!libav? ( media-video/ffmpeg:0= )
		libav? ( >=media-video/libav-10:0= )
	)
	vnc? ( >=net-libs/libvncserver-0.9.9:0 )
	vorbis? ( media-libs/libvorbis:0 )
	vpx? ( media-libs/libvpx:0= )
	X? ( x11-libs/libX11:0 )
	x264? ( media-libs/x264:0= )
	x265? ( media-libs/x265:0= )
	xcb? ( x11-libs/libxcb:0 x11-libs/xcb-util:0 x11-libs/xcb-util-keysyms:0 )
	xml? ( dev-libs/libxml2:2 )
	zeroconf? ( >=net-dns/avahi-0.6:0[dbus] )
	zvbi? ( media-libs/zvbi:0 )
"
DEPEND="${RDEPEND}
	app-arch/xz-utils:0
	>=sys-devel/gettext-0.18.3:*
	virtual/pkgconfig:*
	amd64? ( dev-lang/yasm:* )
	x86?   ( dev-lang/yasm:* )
	xcb? ( x11-proto/xproto:0 )
"

PATCHES=(
	# Fix build system mistake.
	"${FILESDIR}"/${PN}-2.1.0-fix-libtremor-libs.patch

	# Bug #541678
	"${FILESDIR}"/qt4-select.patch

	# Allow QT5.5 since Gentoo has a patched QTwidgets
	"${FILESDIR}"/${PN}-2.2.2-qt5widgets.patch

	# Bug #575072
	"${FILESDIR}"/${PN}-2.2.4-relax_ffmpeg.patch
	"${FILESDIR}"/${PN}-2.2.4-ffmpeg3.patch

	# Bug #589396
	"${FILESDIR}"/${PN}-2.2.4-cxx0x.patch

	# Bug #594126, #629294
	"${FILESDIR}"/${PN}-2.2.6-decoder-lock-scope.patch
	"${FILESDIR}"/${PN}-2.2.4-alsa-large-buffers.patch

	# Bug #593460
	"${FILESDIR}"/${PN}-2.2.4-libav-11.7.patch

	"${FILESDIR}"/${P}-libupnp-compat.patch

	# Bug 590164
	"${FILESDIR}"/${P}-freerdp-2.patch
)

DOCS=( AUTHORS THANKS NEWS README doc/fortunes.txt doc/intf-vcd.txt )

S="${WORKDIR}/${MY_P}"

src_prepare() {
	default

	has_version '>=net-libs/libupnp-1.8.0' && eapply "${FILESDIR}"/${P}-libupnp-slot-1.8.patch

	# Bootstrap when we are on a git checkout.
	if [[ ${PV} = *9999 ]] ; then
		./bootstrap
	fi

	# Make it build with libtool 1.5
	rm -f m4/lt* m4/libtool.m4 || die

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

	# If qtchooser is installed, it may break the build, because moc,rcc and uic binaries for wrong qt
	# version may be used. Setting QT_SELECT environment variable will enforce correct binaries.
	if use qt5; then
		export QT_SELECT=qt5
	fi
}

src_configure() {
	local myconf

	# Compatibility fix for Samba 4.
	use samba && append-cppflags "-I/usr/include/samba-4.0"

	if use x86; then
		# We need to disable -fstack-check if use >=gcc 4.8.0. bug #499996
		append-cflags $(test-flags-CC -fno-stack-check)
		# Bug 569774
		replace-flags -Os -O2
	fi

	# FIXME: Needs libresid-builder from libsidplay:2 which is in another directory...
	append-ldflags "-L/usr/$(get_libdir)/sidplay/builders/"

	xdg_environment_reset # bug 608256

	if use truetype || use projectm ; then
		local dejavu="/usr/share/fonts/dejavu/"
		myconf="--with-default-font=${dejavu}/DejaVuSans.ttf \
				--with-default-font-family=Sans \
				--with-default-monospace-font=${dejavu}/DejaVuSansMono.ttf
				--with-default-monospace-font-family=Monospace"
	fi

	if use qt5 ; then
		myconf+=" --enable-qt=5"
	else
		myconf+=" --disable-qt"
	fi

	econf \
		${myconf} \
		--enable-vlc \
		--docdir=/usr/share/doc/${PF} \
		--disable-dependency-tracking \
		--disable-optimizations \
		--disable-update-check \
		--enable-fast-install \
		--enable-screen \
		$(use_enable a52) \
		$(use_enable aalib aa) \
		$(use_enable alsa) \
		$(use_enable altivec) \
		$(use_enable atmo) \
		$(use_enable audioqueue) \
		$(use_enable avcodec) \
		$(use_enable avformat) \
		$(use_enable bidi fribidi) \
		$(use_enable bluray) \
		$(use_enable cdda vcd) \
		$(use_enable cddb libcddb) \
		$(use_enable chromaprint) \
		$(use_enable dbus) \
		$(use_enable directx) \
		$(use_enable dc1394) \
		$(use_enable debug) \
		$(use_enable dts dca) \
		$(use_enable dvbpsi) \
		$(use_enable dvd dvdread) $(use_enable dvd dvdnav) \
		$(use_enable dxva2) \
		$(use_enable encode sout) \
		$(use_enable faad) \
		$(use_enable fdk fdkaac) \
		$(use_enable flac) \
		$(use_enable fluidsynth) \
		$(use_enable fontconfig) \
		$(use_enable gcrypt libgcrypt) \
		$(use_enable gme) \
		$(use_enable gnome gnomevfs) \
		$(use_enable gnutls) \
		$(use_enable growl) \
		$(use_enable gstreamer gst-decode) \
		$(use_enable httpd) \
		$(use_enable ieee1394 dv1394) \
		$(use_enable jack) \
		$(use_enable jpeg) \
		$(use_enable kate) \
		$(use_enable libass) \
		$(use_enable libcaca caca) \
		$(use_enable libnotify notify) \
		$(use_enable libsamplerate samplerate) \
		$(use_enable libtar) \
		$(use_enable libtiger tiger) \
		$(use_enable linsys) \
		$(use_enable lirc) \
		$(use_enable live live555) \
		$(use_enable lua) \
		$(use_enable macosx-dialog-provider) \
		$(use_enable macosx-eyetv) \
		$(use_enable macosx-qtkit) \
		$(use_enable macosx-quartztext) \
		$(use_enable matroska mkv) \
		$(use_enable cpu_flags_x86_mmx mmx) \
		$(use_enable modplug mod) \
		$(use_enable mp3 mad) \
		$(use_enable mpeg libmpeg2) \
		$(use_enable mtp) \
		$(use_enable musepack mpc) \
		$(use_enable ncurses) \
		$(use_enable neon) \
		$(use_enable ogg) $(use_enable ogg mux_ogg) \
		$(use_enable omxil) \
		$(use_enable omxil omxil-vout) \
		$(use_enable opencv) \
		$(use_enable opengl glspectrum) \
		$(use_enable opus) \
		$(use_enable optimisememory optimize-memory) \
		$(use_enable png) \
		$(use_enable postproc) \
		$(use_enable projectm) \
		$(use_enable pulseaudio pulse) \
		$(use_enable rdp freerdp) \
		$(use_enable rtsp realrtsp) \
		$(use_enable run-as-root) \
		$(use_enable samba smbclient) \
		$(use_enable schroedinger) \
		$(use_enable sdl) \
		$(use_enable sdl-image) \
		$(use_enable sid) \
		$(use_enable sftp) \
		$(use_enable shout) \
		$(use_enable skins skins2) \
		$(use_enable speex) \
		$(use_enable cpu_flags_x86_sse sse) \
		$(use_enable svg) \
		$(use_enable svg svgdec) \
		$(use_enable swscale) \
		$(use_enable taglib) \
		$(use_enable theora) \
		$(use_enable tremor) \
		$(use_enable truetype freetype) \
		$(use_enable twolame) \
		$(use_enable udev) \
		$(use_enable upnp) \
		$(use_enable v4l v4l2) \
		$(use_enable vaapi libva) \
		$(use_enable vcdx) \
		$(use_enable vdpau) \
		$(use_enable vlm) \
		$(use_enable vnc) \
		$(use_enable vorbis) \
		$(use_enable vpx) \
		$(use_enable wma-fixed) \
		$(use_with X x) \
		$(use_enable x264) \
		$(use_enable x265) \
		$(use_enable xcb) \
		$(use_enable xml libxml2) \
		$(use_enable xv xvideo) \
		$(use_enable zeroconf bonjour) \
		$(use_enable zvbi) $(use_enable !zvbi telx) \
		--disable-asdcp \
		--disable-coverage \
		--disable-cprof \
		--disable-crystalhd \
		--disable-decklink \
		--disable-directfb \
		--disable-gles1 \
		--disable-gles2 \
		--disable-goom \
		--disable-kai \
		--disable-kva \
		--disable-maintainer-mode \
		--disable-merge-ffmpeg \
		--disable-mfx \
		--disable-mmal-codec \
		--disable-mmal-vout \
		--disable-opensles \
		--disable-oss \
		--disable-quicktime \
		--disable-rpi-omxil \
		--disable-shine \
		--disable-sndio \
		--disable-vda \
		--disable-vsxu \
		--disable-wasapi

		# ^ We don't have these disabled libraries in the Portage tree yet.

	# _FORTIFY_SOURCE is set to 2 in config.h, which is also the default value on Gentoo.
	# Other values of _FORTIFY_SOURCE may break the build (bug 523144), so definition should not be removed from config.h.
	# To prevent redefinition warnings, we undefine _FORTIFY_SOURCE at the very start of config.h file
	sed -i '1i#undef _FORTIFY_SOURCE' "${S}"/config.h || die
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
		"/usr/$(get_libdir)/vlc/vlc-cache-gen" -f "/usr/$(get_libdir)/vlc/plugins/"
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

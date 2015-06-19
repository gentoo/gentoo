# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/vlc/vlc-2.2.1.ebuild,v 1.10 2015/06/08 18:43:38 pacho Exp $

EAPI="5"

SCM=""
if [ "${PV%9999}" != "${PV}" ] ; then
	SCM="git-r3"

	if [ "${PV%.9999}" != "${PV}" ] ; then
		EGIT_REPO_URI="git://git.videolan.org/vlc/vlc-${PV%.9999}.git"
	else
		EGIT_REPO_URI="git://git.videolan.org/vlc.git"
	fi
fi

inherit eutils multilib autotools toolchain-funcs flag-o-matic virtualx ${SCM}

MY_PV="${PV/_/-}"
MY_PV="${MY_PV/-beta/-test}"
MY_P="${PN}-${MY_PV}"

DESCRIPTION="VLC media player - Video player and streamer"
HOMEPAGE="http://www.videolan.org/vlc/"
if [ "${PV%9999}" != "${PV}" ] ; then # Live ebuild
	SRC_URI=""
elif [[ "${MY_P}" == "${P}" ]]; then
	SRC_URI="http://download.videolan.org/pub/videolan/${PN}/${PV}/${P}.tar.xz"
else
	SRC_URI="http://download.videolan.org/pub/videolan/testing/${MY_P}/${MY_P}.tar.xz"
fi

LICENSE="LGPL-2.1 GPL-2"
SLOT="0/5-8" # vlc - vlccore

if [ "${PV%9999}" = "${PV}" ] ; then
	KEYWORDS="~amd64 ~arm ~ppc64 -sparc ~x86 ~x86-fbsd"
else
	KEYWORDS=""
fi

IUSE="a52 aalib alsa altivec atmo +audioqueue +avcodec
	+avformat bidi bluray cdda cddb chromaprint dbus dc1394 debug
	directfb directx dts dvb +dvbpsi dvd dxva2 elibc_glibc +encode faad fdk
	fluidsynth +ffmpeg flac fontconfig +gcrypt gme gnome gnutls
	growl httpd ieee1394 jack jpeg kate kde libass libav libcaca libnotify
	+libsamplerate libtiger linsys libtar lirc live lua
	macosx-dialog-provider macosx-eyetv macosx-quartztext macosx-qtkit
	matroska media-library cpu_flags_x86_mmx modplug mp3 mpeg
	mtp musepack ncurses neon ogg omxil opencv opengl optimisememory opus
	png postproc projectm pulseaudio +qt4 qt5 rdp rtsp run-as-root samba
	schroedinger sdl sdl-image sftp shout sid skins speex cpu_flags_x86_sse svg +swscale
	taglib theora tremor truetype twolame udev upnp vaapi v4l vcdx vdpau
	vlm vnc vorbis vpx wma-fixed +X x264 x265 +xcb xml xv zeroconf zvbi"

RDEPEND="
		!<media-video/ffmpeg-1.2:0
		dev-libs/libgpg-error:0
		net-dns/libidn:0
		>=sys-libs/zlib-1.2.5.1-r2:0[minizip]
		virtual/libintl:0
		a52? ( >=media-libs/a52dec-0.7.4-r3:0 )
		aalib? ( media-libs/aalib:0 )
		alsa? ( >=media-libs/alsa-lib-1.0.24:0 )
		avcodec? (
			!libav? ( media-video/ffmpeg:0= )
			libav? ( >=media-video/libav-11:0= )
		)
		avformat? (
			!libav? ( media-video/ffmpeg:0= )
			libav? ( media-video/libav:0= )
		)
		bidi? ( >=dev-libs/fribidi-0.10.4:0 )
		bluray? ( >=media-libs/libbluray-0.3:0 )
		cddb? ( >=media-libs/libcddb-1.2:0 )
		chromaprint? ( >=media-libs/chromaprint-0.6:0 )
		dbus? ( >=sys-apps/dbus-1.6:0 )
		dc1394? ( >=sys-libs/libraw1394-2.0.1:0 >=media-libs/libdc1394-2.1:2 )
		directfb? ( dev-libs/DirectFB:0 sys-libs/zlib:0 )
		dts? ( >=media-libs/libdca-0.0.5:0 )
		dvbpsi? ( >=media-libs/libdvbpsi-0.2.1:0 )
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
		ieee1394? ( >=sys-libs/libraw1394-2.0.1:0 >=sys-libs/libavc1394-0.5.3:0 )
		jack? ( >=media-sound/jack-audio-connection-kit-0.99.0-r1:0 )
		jpeg? ( virtual/jpeg:0 )
		kate? ( >=media-libs/libkate-0.3:0 )
		libass? ( >=media-libs/libass-0.9.8:0 media-libs/fontconfig:1.0 )
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
		ncurses? ( sys-libs/ncurses:5[unicode] )
		ogg? ( >=media-libs/libogg-1:0 )
		opencv? ( >media-libs/opencv-2:0 )
		opengl? ( virtual/opengl:0 >=x11-libs/libX11-1.3.99.901:0 )
		opus? ( >=media-libs/opus-1.0.3:0 )
		png? ( media-libs/libpng:0= sys-libs/zlib:0 )
		postproc? (
			!libav? ( >=media-video/ffmpeg-2.2:0= )
			libav? ( media-libs/libpostproc:0= )
		)
		projectm? ( media-libs/libprojectm:0 media-fonts/dejavu:0 )
		pulseaudio? ( >=media-sound/pulseaudio-1:0 )
		qt4? ( >=dev-qt/qtgui-4.6:4 >=dev-qt/qtcore-4.6:4 )
		qt5? ( >=dev-qt/qtgui-5.1:5 >=dev-qt/qtcore-5.1:5 >=dev-qt/qtwidgets-5.1:5  >=dev-qt/qtx11extras-5.1:5 )
		rdp? ( >=net-misc/freerdp-1.0.1:0= )
		samba? ( || ( >=net-fs/samba-3.4.6:0[smbclient] >=net-fs/samba-4:0[client] ) )
		schroedinger? ( >=media-libs/schroedinger-1.0.10:0 )
		sdl? ( >=media-libs/libsdl-1.2.10:0
			sdl-image? ( >=media-libs/sdl-image-1.2.10:0 sys-libs/zlib:0 ) )
		sftp? ( net-libs/libssh2:0 )
		shout? ( >=media-libs/libshout-2.1:0 )
		sid? ( media-libs/libsidplay:2 )
		skins? ( x11-libs/libXext:0 x11-libs/libXpm:0 x11-libs/libXinerama:0 )
		speex? ( media-libs/speex:0 )
		svg? ( >=gnome-base/librsvg-2.9:2 >=x11-libs/cairo-1.13.1:0 )
		swscale? (
			!libav? ( media-video/ffmpeg:0= )
			libav? ( media-video/libav:0= )
		)
		taglib? ( >=media-libs/taglib-1.9:0 sys-libs/zlib:0 )
		theora? ( >=media-libs/libtheora-1.0_beta3:0 )
		tremor? ( media-libs/tremor:0 )
		truetype? ( media-libs/freetype:2 virtual/ttf-fonts:0
			!fontconfig? ( media-fonts/dejavu:0 ) )
		twolame? ( media-sound/twolame:0 )
		udev? ( >=virtual/udev-142:0 )
		upnp? ( net-libs/libupnp:0 )
		v4l? ( media-libs/libv4l:0 )
		vaapi? (
			x11-libs/libva:0[X,drm]
			!libav? ( media-video/ffmpeg:0=[vaapi] )
			libav? ( media-video/libav:0=[vaapi] )
		)
		vcdx? ( >=dev-libs/libcdio-0.78.2:0 >=media-video/vcdimager-0.7.22:0 )
		zeroconf? ( >=net-dns/avahi-0.6:0[dbus] )
"

# Temporarily block non-live FFMPEG versions as they break vdpau, 9999 works;
# thus we'll have to wait for a new release there.
RDEPEND="${RDEPEND}
		vdpau? (
			>=x11-libs/libvdpau-0.6:0
			!libav? ( >=media-video/ffmpeg-2.2:0= )
			libav? ( >=media-video/libav-10:0= )
		)
		vnc? ( >=net-libs/libvncserver-0.9.9:0 )
		vorbis? ( >=media-libs/libvorbis-1.1:0 )
		vpx? ( media-libs/libvpx:0 )
		X? ( x11-libs/libX11:0 )
		x264? ( >=media-libs/x264-0.0.20090923:0= )
		x265? ( media-libs/x265:0= )
		xcb? ( >=x11-libs/libxcb-1.6:0 >=x11-libs/xcb-util-0.3.4:0 >=x11-libs/xcb-util-keysyms-0.3.4:0 )
		xml? ( >=dev-libs/libxml2-2.5:2 )
		zvbi? ( >=media-libs/zvbi-0.2.25:0 )
"

DEPEND="${RDEPEND}
	kde? ( >=kde-base/kdelibs-4:4 )
	xcb? ( x11-proto/xproto:0 )
	app-arch/xz-utils:0
	x86?   ( dev-lang/yasm:* )
	amd64? ( dev-lang/yasm:* )
	>=sys-devel/gettext-0.18.3:*
	virtual/pkgconfig:*
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
	qt4? ( X !qt5 )
	qt5? ( X !qt4 )
	sdl? ( X )
	skins? ( truetype X ^^ ( qt4 qt5 ) )
	vaapi? ( avcodec X )
	vlm? ( encode )
	xv? ( xcb )
"

S="${WORKDIR}/${MY_P}"

pkg_setup() {
	if [[ "${MERGE_TYPE}" != "binary" && "$(tc-getCC)" == *"gcc"* ]] ; then
		if [[ $(gcc-major-version) < 4 || ( $(gcc-major-version) == 4 && $(gcc-minor-version) < 5 ) ]] ; then
			die "You need to have at least >=sys-devel/gcc-4.5 to build and/or have a working vlc, see bug #426754."
		fi
	fi
}

src_unpack() {
	if [ "${PV%9999}" != "${PV}" ] ; then
		git-r3_src_unpack
	else
		unpack ${A}
	fi
}

src_prepare() {
	# Remove unnecessary warnings about unimplemented pragmas on gcc for now.
	# Need to recheck this with gcc 4.9 and every subsequent minor bump of gcc.
	#
	# config.h:792: warning: ignoring #pragma STDC FENV_ACCESS [-Wunknown-pragmas]
	# config.h:793: warning: ignoring #pragma STDC FP_CONTRACT [-Wunknown-pragmas]
	#
	# http://gcc.gnu.org/c99status.html
	if [[ "$(tc-getCC)" == *"gcc"* ]] ; then
		sed -i 's/ifndef __FAST_MATH__/if 0/g' configure.ac || die
	fi

	# Bootstrap when we are on a git checkout.
	if [[ "${PV%9999}" != "${PV}" ]] ; then
		./bootstrap
	fi

	# Make it build with libtool 1.5
	rm -f m4/lt* m4/libtool.m4 || die

	# We are not in a real git checkout due to the absence of a .git directory.
	touch src/revision.txt || die

	# Fix build system mistake.
	epatch "${FILESDIR}"/${PN}-2.1.0-fix-libtremor-libs.patch

	# Patch up incompatibilities and reconfigure autotools.
	epatch "${FILESDIR}"/${PN}-9999-libva-1.2.1-compat.patch

	# Patch for bug 542414
	epatch "${FILESDIR}"/${PN}-2.2.0-rdp-1.2.0.patch

	# Patch for bug 541928
	epatch "${FILESDIR}"/${PN}-2.2.0-xcb_vdpau.patch

	# Fix up broken audio when skipping using a fixed reversed bisected commit.
	epatch "${FILESDIR}"/${PN}-2.1.0-TomWij-bisected-PA-broken-underflow.patch

	# Bug #541678
	epatch "${FILESDIR}"/qt4-select.patch

	# Don't use --started-from-file when not using dbus.
	if ! use dbus ; then
		sed -i 's/ --started-from-file//' share/vlc.desktop.in || die
	fi

	epatch_user

	eautoreconf

	# Disable automatic running of tests.
	find . -name 'Makefile.in' -exec sed -i 's/\(..*\)check-TESTS/\1/' {} \; || die

	# If qtchooser is installed, it may break the build, because moc,rcc and uic binaries for wrong qt version may be used.
	# Setting QT_SELECT environment variable will enforce correct binaries.
	if use qt4; then
		export QT_SELECT=qt4
	elif use qt5; then
		export QT_SELECT=qt5
	fi
}

src_configure() {
	# Compatibility fix for Samba 4.
	use samba && append-cppflags "-I/usr/include/samba-4.0"

	# We need to disable -fstack-check if use >=gcc 4.8.0.
	# See bug #499996
	use x86 && append-cflags $(test-flags-CC -fno-stack-check)

	# Needs libresid-builder from libsidplay:2 which is in another directory...
	# FIXME!
	append-ldflags "-L/usr/$(get_libdir)/sidplay/builders/"

	if use truetype || use projectm ; then
		local dejavu="/usr/share/fonts/dejavu/"
		myconf="--with-default-font=${dejavu}/DejaVuSans.ttf \
				--with-default-font-family=Sans \
				--with-default-monospace-font=${dejavu}/DejaVuSansMono.ttf
				--with-default-monospace-font-family=Monospace"
	fi

	local qt_flag=""
	if use qt4 ; then
		qt_flag="--enable-qt=4"
	elif use qt5 ; then
		qt_flag="--enable-qt=5"
	else
		qt_flag="--disable-qt"
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
		$(use_enable directfb) \
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
		$(use_enable httpd) \
		$(use_enable ieee1394 dv1394) \
		$(use_enable jack) \
		$(use_enable jpeg) \
		$(use_enable kate) \
		$(use_with kde kde-solid) \
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
		${qt_flag} \
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
	Xemake check-TESTS
}

DOCS="AUTHORS THANKS NEWS README doc/fortunes.txt doc/intf-vcd.txt"

src_install() {
	default

	# Punt useless libtool's .la files
	find "${D}" -name '*.la' -delete
}

pkg_postinst() {
	if [ "$ROOT" = "/" ] && [ -x "/usr/$(get_libdir)/vlc/vlc-cache-gen" ] ; then
		einfo "Running /usr/$(get_libdir)/vlc/vlc-cache-gen on /usr/$(get_libdir)/vlc/plugins/"
		"/usr/$(get_libdir)/vlc/vlc-cache-gen" -f "/usr/$(get_libdir)/vlc/plugins/"
	else
		ewarn "We cannot run vlc-cache-gen (most likely ROOT!=/)"
		ewarn "Please run /usr/$(get_libdir)/vlc/vlc-cache-gen manually"
		ewarn "If you do not do it, vlc will take a long time to load."
	fi
}

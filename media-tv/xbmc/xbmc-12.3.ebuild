# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-tv/xbmc/xbmc-12.3.ebuild,v 1.11 2015/04/08 18:15:30 mgorny Exp $

EAPI="5"

# Does not work with py3 here
# It might work with py:2.5 but I didn't test that
PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="sqlite"

inherit eutils python-single-r1 multiprocessing autotools

BACKPORTS_VERSION=1

case ${PV} in
9999)
	EGIT_REPO_URI="git://github.com/xbmc/xbmc.git"
	inherit git-2
	SRC_URI="!java? ( mirror://gentoo/${P}-20121224-generated-addons.tar.xz )"
	;;
*_alpha*|*_beta*|*_rc*)
	MY_PV="Frodo_${PV#*_}"
	MY_P="${PN}-${MY_PV}"
	SRC_URI="https://github.com/xbmc/xbmc/archive/${MY_PV}.tar.gz -> ${P}.tar.gz
		!java? ( mirror://gentoo/${P}-generated-addons.tar.xz )"
	KEYWORDS="~amd64 ~x86"
	;;
*)
	MY_P=${P/_/-*_}
	SRC_URI="http://mirrors.xbmc.org/releases/source/${MY_P}.tar.gz
		mirror://gentoo/${PN}_backports-12-${BACKPORTS_VERSION}.tar.bz2
		mirror://gentoo/${P}-generated-addons.tar.xz"
	KEYWORDS="~amd64 ~x86"
	;;
esac

DESCRIPTION="XBMC is a free and open source media-player and entertainment hub"
HOMEPAGE="http://xbmc.org/"

LICENSE="GPL-2"
SLOT="0"
IUSE="airplay alsa altivec avahi bluetooth bluray caps cec css debug gles goom java joystick midi mysql neon nfs +opengl profile +projectm pulseaudio pvr +rsxs rtmp +samba +sdl cpu_flags_x86_sse cpu_flags_x86_sse2 sftp udisks upnp upower +usb vaapi vdpau webserver +X +xrandr"
REQUIRED_USE="
	pvr? ( mysql )
	rsxs? ( X )
	X? ( sdl )
	xrandr? ( X )
"

COMMON_DEPEND="${PYTHON_DEPS}
	app-arch/bzip2
	app-arch/unzip
	app-arch/zip
	app-i18n/enca
	airplay? ( app-pda/libplist )
	dev-libs/boost
	dev-libs/fribidi
	dev-libs/libcdio[-minimal]
	cec? ( >=dev-libs/libcec-2.1 )
	dev-libs/libpcre[cxx]
	>=dev-libs/lzo-2.04
	dev-libs/tinyxml[stl]
	dev-libs/yajl
	dev-python/simplejson[${PYTHON_USEDEP}]
	media-libs/alsa-lib
	media-libs/flac
	media-libs/fontconfig
	media-libs/freetype
	>=media-libs/glew-1.5.6
	media-libs/jasper
	media-libs/jbigkit
	>=media-libs/libass-0.9.7
	bluray? ( media-libs/libbluray )
	css? ( media-libs/libdvdcss )
	media-libs/libmad
	media-libs/libmodplug
	media-libs/libmpeg2
	media-libs/libogg
	media-libs/libpng
	projectm? ( media-libs/libprojectm )
	media-libs/libsamplerate
	sdl? ( media-libs/libsdl[sound,opengl,video,X] )
	alsa? ( media-libs/libsdl[alsa] )
	>=media-libs/taglib-1.8
	media-libs/libvorbis
	sdl? (
		media-libs/sdl-gfx
		>=media-libs/sdl-image-1.2.10[gif,jpeg,png]
		media-libs/sdl-mixer
		media-libs/sdl-sound
	)
	media-libs/tiff
	pulseaudio? ( media-sound/pulseaudio )
	media-sound/wavpack
	|| ( media-libs/libpostproc media-video/ffmpeg:0 )
	>=virtual/ffmpeg-0.6[encode]
	rtmp? ( media-video/rtmpdump )
	avahi? ( net-dns/avahi )
	nfs? ( net-fs/libnfs )
	webserver? ( net-libs/libmicrohttpd[messages] )
	sftp? ( net-libs/libssh[sftp] )
	net-misc/curl
	samba? ( >=net-fs/samba-3.4.6[smbclient(+)] )
	bluetooth? ( net-wireless/bluez )
	sys-apps/dbus
	caps? ( sys-libs/libcap )
	sys-libs/zlib
	virtual/jpeg
	usb? ( virtual/libusb )
	mysql? ( virtual/mysql )
	opengl? (
		virtual/glu
		virtual/opengl
	)
	gles? (
		virtual/opengl
		media-libs/mesa[gles2]
	)
	vaapi? ( x11-libs/libva[opengl] )
	vdpau? (
		|| ( x11-libs/libvdpau >=x11-drivers/nvidia-drivers-180.51 )
		virtual/ffmpeg[vdpau]
	)
	X? (
		x11-apps/xdpyinfo
		x11-apps/mesa-progs
		x11-libs/libXinerama
		xrandr? ( x11-libs/libXrandr )
		x11-libs/libXrender
	)"
RDEPEND="${COMMON_DEPEND}
	!media-tv/kodi
	udisks? ( sys-fs/udisks:0 )
	upower? ( || ( sys-power/upower sys-power/upower-pm-utils ) )"
DEPEND="${COMMON_DEPEND}
	app-arch/xz-utils
	dev-lang/swig
	dev-util/gperf
	X? ( x11-proto/xineramaproto )
	dev-util/cmake
	x86? ( dev-lang/nasm )
	java? ( virtual/jre )"

S=${WORKDIR}/${MY_P}-Frodo

pkg_setup() {
	python-single-r1_pkg_setup
}

src_unpack() {
	[[ ${PV} == "9999" ]] && git-2_src_unpack || default
}

src_prepare() {
	epatch "${FILESDIR}"/${PN}-12.1-nomythtv.patch
	epatch "${FILESDIR}"/${PN}-9999-no-arm-flags.patch #400617
	epatch "${FILESDIR}"/${PN}-12.3-no-sse2.patch #475266
	# Backported fixes
	EPATCH_MULTI_MSG="Applying patches backported from master..." \
		EPATCH_SUFFIX="patch" \
		epatch "${WORKDIR}/${PN}_backports"
	# The mythtv patch touches configure.ac, so force a regen
	rm -f configure

	# some dirs ship generated autotools, some dont
	multijob_init
	local d
	for d in $(printf 'f:\n\t@echo $(BOOTSTRAP_TARGETS)\ninclude bootstrap.mk\n' | emake -f - f) ; do
		[[ -e ${d} ]] && continue
		pushd ${d/%configure/.} >/dev/null || die
		AT_NOELIBTOOLIZE="yes" AT_TOPLEVEL_EAUTORECONF="yes" \
		multijob_child_init eautoreconf
		popd >/dev/null
	done
	multijob_finish
	elibtoolize

	# Disable internal func checks as our USE/DEPEND
	# stuff handles this just fine already #408395
	export ac_cv_lib_avcodec_ff_vdpau_vc1_decode_picture=yes

	local squish #290564
	use altivec && squish="-DSQUISH_USE_ALTIVEC=1 -maltivec"
	use cpu_flags_x86_sse && squish="-DSQUISH_USE_SSE=1 -msse"
	use cpu_flags_x86_sse2 && squish="-DSQUISH_USE_SSE=2 -msse2"
	sed -i \
		-e '/^CXXFLAGS/{s:-D[^=]*=.::;s:-m[[:alnum:]]*::}' \
		-e "1iCXXFLAGS += ${squish}" \
		lib/libsquish/Makefile.in || die

	# Fix XBMC's final version string showing as "exported"
	# instead of the SVN revision number.
	export HAVE_GIT=no GIT_REV=${EGIT_VERSION:-exported}

	# avoid long delays when powerkit isn't running #348580
	sed -i \
		-e '/dbus_connection_send_with_reply_and_block/s:-1:3000:' \
		xbmc/linux/*.cpp || die

	epatch_user #293109

	# Tweak autotool timestamps to avoid regeneration
	find . -type f -exec touch -r configure {} +
}

src_configure() {
	# Disable documentation generation
	export ac_cv_path_LATEX=no
	# Avoid help2man
	export HELP2MAN=$(type -P help2man || echo true)
	# No configure flage for this #403561
	export ac_cv_lib_bluetooth_hci_devid=$(usex bluetooth)
	# Requiring java is asine #434662
	export ac_cv_path_JAVA_EXE=$(which $(usex java java true))

	econf \
		--docdir=/usr/share/doc/${PF} \
		--disable-ccache \
		--disable-optimizations \
		--enable-external-libraries \
		$(use_enable airplay) \
		$(use_enable avahi) \
		$(use_enable bluray libbluray) \
		$(use_enable caps libcap) \
		$(use_enable cec libcec) \
		$(use_enable css dvdcss) \
		$(use_enable debug) \
		$(use_enable gles) \
		$(use_enable goom) \
		--disable-hal \
		$(use_enable joystick) \
		$(use_enable midi mid) \
		$(use_enable mysql) \
		$(use_enable neon) \
		$(use_enable nfs) \
		$(use_enable opengl gl) \
		$(use_enable profile profiling) \
		$(use_enable projectm) \
		$(use_enable pulseaudio pulse) \
		$(use_enable pvr mythtv) \
		$(use_enable rsxs) \
		$(use_enable rtmp) \
		$(use_enable samba) \
		$(use_enable sdl) \
		$(use_enable sftp ssh) \
		$(use_enable usb libusb) \
		$(use_enable upnp) \
		$(use_enable vaapi) \
		$(use_enable vdpau) \
		$(use_enable webserver) \
		$(use_enable X x11) \
		$(use_enable xrandr)
}

src_install() {
	default
	rm "${ED}"/usr/share/doc/*/{LICENSE.GPL,copying.txt}*

	domenu tools/Linux/xbmc.desktop
	newicon tools/Linux/xbmc-48x48.png xbmc.png

	python_domodule tools/EventClients/lib/python/xbmcclient.py
	python_newscript "tools/EventClients/Clients/XBMC Send/xbmc-send.py" xbmc-send
}

pkg_postinst() {
	elog "Visit http://wiki.xbmc.org/?title=XBMC_Online_Manual"
}

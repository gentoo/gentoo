# Copyright 2022-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..14} )
inherit edo optfeature python-any-r1 wine

WINE_GECKO=2.47.4
WINE_MONO=10.4.1
WINE_P=wine-$(ver_cut 1-2)

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://gitlab.winehq.org/wine/wine-staging.git"
	WINE_EGIT_REPO_URI="https://gitlab.winehq.org/wine/wine.git"
else
	(( $(ver_cut 2) )) && WINE_SDIR=$(ver_cut 1).x || WINE_SDIR=$(ver_cut 1).0
	SRC_URI="
		https://dl.winehq.org/wine/source/${WINE_SDIR}/${WINE_P}.tar.xz
		https://github.com/wine-staging/wine-staging/archive/v${PV}.tar.gz -> ${P}.tar.gz
	"
	KEYWORDS="-* ~amd64 ~arm64 ~x86"
fi

DESCRIPTION="Free implementation of Windows(tm) on Unix, with Wine-Staging patchset"
HOMEPAGE="
	https://wiki.winehq.org/Wine-Staging
	https://gitlab.winehq.org/wine/wine-staging/
"
S=${WORKDIR}/${WINE_P}

LICENSE="
	LGPL-2.1+
	BSD BSD-2 IJG MIT OPENLDAP ZLIB gsm libpng2 libtiff
	|| ( WTFPL-2 public-domain )
"
SLOT="${PV}"
IUSE="
	+X +alsa bluetooth capi cups +dbus dos llvm-libunwind ffmpeg
	+fontconfig +gecko gphoto2 +gstreamer kerberos +mono netapi
	nls odbc opencl +opengl pcap perl pulseaudio samba scanner
	+sdl selinux smartcard +ssl +truetype udev +unwind usb v4l
	+vulkan wayland xinerama
"
REQUIRED_USE="
	X? ( truetype )
	bluetooth? ( dbus )
	opengl? ( || ( X wayland ) )
"

# tests are non-trivial to run, can hang easily, don't play well with
# sandbox, and several need real opengl/vulkan or network access
RESTRICT="test"

# `grep WINE_CHECK_SONAME configure.ac` + if not directly linked
WINE_DLOPEN_DEPEND="
	X? (
		x11-libs/libXcomposite[${WINE_USEDEP}]
		x11-libs/libXcursor[${WINE_USEDEP}]
		x11-libs/libXfixes[${WINE_USEDEP}]
		x11-libs/libXi[${WINE_USEDEP}]
		x11-libs/libXrandr[${WINE_USEDEP}]
		x11-libs/libXrender[${WINE_USEDEP}]
		x11-libs/libXxf86vm[${WINE_USEDEP}]
		xinerama? ( x11-libs/libXinerama[${WINE_USEDEP}] )
	)
	cups? ( net-print/cups[${WINE_USEDEP}] )
	dbus? ( sys-apps/dbus[${WINE_USEDEP}] )
	fontconfig? ( media-libs/fontconfig[${WINE_USEDEP}] )
	kerberos? ( virtual/krb5[${WINE_USEDEP}] )
	netapi? ( net-fs/samba[${WINE_USEDEP}] )
	odbc? ( dev-db/unixODBC[${WINE_USEDEP}] )
	opengl? ( media-libs/libglvnd[X?,${WINE_USEDEP}] )
	sdl? ( media-libs/libsdl2[haptic,joystick,${WINE_USEDEP}] )
	ssl? ( net-libs/gnutls:=[${WINE_USEDEP}] )
	truetype? ( media-libs/freetype[${WINE_USEDEP}] )
	v4l? ( media-libs/libv4l[${WINE_USEDEP}] )
	vulkan? ( media-libs/vulkan-loader[X?,wayland?,${WINE_USEDEP}] )
"
WINE_COMMON_DEPEND="
	${WINE_DLOPEN_DEPEND}
	X? (
		x11-libs/libX11[${WINE_USEDEP}]
		x11-libs/libXext[${WINE_USEDEP}]
	)
	alsa? ( media-libs/alsa-lib[${WINE_USEDEP}] )
	capi? ( net-libs/libcapi:=[${WINE_USEDEP}] )
	ffmpeg? ( media-video/ffmpeg:=[${WINE_USEDEP}] )
	gphoto2? ( media-libs/libgphoto2:=[${WINE_USEDEP}] )
	gstreamer? (
		dev-libs/glib:2[${WINE_USEDEP}]
		media-libs/gst-plugins-base:1.0[${WINE_USEDEP}]
		media-libs/gstreamer:1.0[${WINE_USEDEP}]
	)
	opencl? ( virtual/opencl[${WINE_USEDEP}] )
	pcap? ( net-libs/libpcap[${WINE_USEDEP}] )
	pulseaudio? ( media-libs/libpulse[${WINE_USEDEP}] )
	scanner? ( media-gfx/sane-backends[${WINE_USEDEP}] )
	smartcard? ( sys-apps/pcsc-lite[${WINE_USEDEP}] )
	udev? ( virtual/libudev:=[${WINE_USEDEP}] )
	unwind? (
		llvm-libunwind? ( llvm-runtimes/libunwind[${WINE_USEDEP}] )
		!llvm-libunwind? ( sys-libs/libunwind:=[${WINE_USEDEP}] )
	)
	usb? ( dev-libs/libusb:1[${WINE_USEDEP}] )
	wayland? (
		dev-libs/wayland[${WINE_USEDEP}]
		x11-libs/libxkbcommon[${WINE_USEDEP}]
	)
"
RDEPEND="
	${WINE_COMMON_DEPEND}
	app-emulation/wine-desktop-common
	dos? (
		|| (
			games-emulation/dosbox
			games-emulation/dosbox-staging
		)
	)
	gecko? (
		app-emulation/wine-gecko:${WINE_GECKO}[${WINE_USEDEP}]
		wow64? ( app-emulation/wine-gecko[abi_x86_32] )
	)
	gstreamer? ( media-plugins/gst-plugins-meta:1.0[${WINE_USEDEP}] )
	mono? ( app-emulation/wine-mono:${WINE_MONO} )
	perl? (
		dev-lang/perl
		dev-perl/XML-LibXML
	)
	samba? ( net-fs/samba[winbind] )
	selinux? ( sec-policy/selinux-wine )
"
DEPEND="
	${WINE_COMMON_DEPEND}
	sys-kernel/linux-headers
	X? ( x11-base/xorg-proto )
	bluetooth? ( net-wireless/bluez )
"
BDEPEND="
	${PYTHON_DEPS}
	dev-vcs/git
	sys-devel/bison
	sys-devel/flex
	virtual/pkgconfig
	nls? ( sys-devel/gettext )
	wayland? ( dev-util/wayland-scanner )
"

QA_CONFIG_IMPL_DECL_SKIP=(
	__clear_cache # unused on amd64+x86 (bug #900334)
	res_getservers # false positive
)
QA_TEXTRELS="usr/lib/*/wine/i386-unix/*.so" # uses -fno-PIC -Wl,-z,notext
# intentionally ignored: https://gitlab.winehq.org/wine/wine/-/commit/433c2f8c06
QA_FLAGS_IGNORED="usr/lib/.*/wine/.*-unix/wine-preloader"

PATCHES=(
	"${FILESDIR}"/${PN}-7.17-noexecstack.patch
	"${FILESDIR}"/${PN}-7.20-unwind.patch
	"${FILESDIR}"/${PN}-8.13-rpath.patch
)

src_unpack() {
	if [[ ${PV} == 9999 ]]; then
		EGIT_CHECKOUT_DIR=${WORKDIR}/${P}
		git-r3_src_unpack

		# hack: use subshell to preserve state (including what git-r3 unpack
		# sets) for smart-live-rebuild as this is not the repo to look at
		(
			EGIT_COMMIT=$(<"${EGIT_CHECKOUT_DIR}"/staging/upstream-commit) || die
			EGIT_REPO_URI=${WINE_EGIT_REPO_URI}
			EGIT_CHECKOUT_DIR=${S}
			einfo "Fetching Wine commit matching the current patchset by default (${EGIT_COMMIT})"
			git-r3_src_unpack
		)
	else
		default
	fi
}

src_prepare() {
	local patchinstallargs=(
		--all
		--no-autoconf
		${MY_WINE_STAGING_CONF}
	)

	edo "${PYTHON}" ../${P}/staging/patchinstall.py "${patchinstallargs[@]}"

	wine_src_prepare
}

src_configure() {
	local wineconfargs=(
		$(use_enable gecko mshtml)
		$(use_enable mono mscoree)
		--disable-tests

		$(use_with X x)
		$(use_with alsa)
		$(use_with capi)
		$(use_with cups)
		$(use_with dbus)
		$(use_with ffmpeg)
		$(use_with fontconfig)
		$(use_with gphoto2 gphoto)
		$(use_with gstreamer)
		--without-hwloc # currently only used on FreeBSD
		$(use_with kerberos gssapi)
		$(use_with kerberos krb5)
		$(use_with netapi)
		$(use_with nls gettext)
		$(use_with opencl)
		$(use_with opengl)
		--without-oss # media-sound/oss is not packaged (OSSv4)
		$(use_with pcap)
		$(use_with pulseaudio pulse)
		$(use_with scanner sane)
		$(use_with sdl)
		$(use_with smartcard pcsclite)
		$(use_with ssl gnutls)
		$(use_with truetype freetype)
		$(use_with udev)
		$(use_with unwind)
		$(use_with usb)
		$(use_with v4l v4l2)
		$(use_with vulkan)
		$(use_with wayland)
		$(use_with xinerama)

		$(usev !bluetooth '
			ac_cv_header_bluetooth_bluetooth_h=no
			ac_cv_header_bluetooth_rfcomm_h=no
		')
		$(usev !odbc ac_cv_lib_soname_odbc=)
	)

	wine_src_configure
}

src_install() {
	use perl || local WINE_SKIP_INSTALL=(
		${WINE_DATADIR}/man/man1/wine{dump,maker}.1
		${WINE_PREFIX}/bin/{function_grep.pl,wine{dump,maker}}
	)

	wine_src_install

	dodoc ANNOUNCE* AUTHORS README* documentation/README*
}

pkg_postinst() {
	wine_pkg_postinst

	optfeature "/dev/hidraw* access used for *some* controllers (e.g. DualShock4)" \
		games-util/game-device-udev-rules
}

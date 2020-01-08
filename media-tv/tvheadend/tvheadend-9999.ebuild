# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit git-r3 linux-info systemd toolchain-funcs user

DESCRIPTION="Tvheadend is a TV streaming server and digital video recorder"
HOMEPAGE="https://tvheadend.org/"
EGIT_REPO_URI="https://github.com/${PN}/${PN}.git"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""

IUSE="dbus debug +ddci dvbcsa +dvb +ffmpeg hdhomerun +imagecache +inotify iptv libressl opus satip systemd +timeshift uriparser vpx x264 x265 xmltv zeroconf zlib"

BDEPEND="
	sys-devel/gettext
	virtual/pkgconfig"

RDEPEND="
	virtual/libiconv
	dbus? ( sys-apps/dbus )
	dvbcsa? ( media-libs/libdvbcsa )
	ffmpeg? ( media-video/ffmpeg:0=[opus?,vpx?,x264?,x265?] )
	hdhomerun? ( media-libs/libhdhomerun )
	!libressl? ( dev-libs/openssl:0= )
	libressl? ( dev-libs/libressl:= )
	uriparser? ( dev-libs/uriparser )
	zeroconf? ( net-dns/avahi )
	zlib? ( sys-libs/zlib )"

# ffmpeg sub-dependencies needed for headers only. Check under
# src/transcoding/codec/codecs/libs for include statements.

DEPEND="
	${RDEPEND}
	dvb? ( virtual/linuxtv-dvb-headers )
	ffmpeg? (
		opus? ( media-libs/opus )
		vpx? ( media-libs/libvpx )
		x264? ( media-libs/x264 )
		x265? ( media-libs/x265 )
	)"

RDEPEND+="
	dvb? ( media-tv/dtv-scan-tables )
	xmltv? ( media-tv/xmltv )"

REQUIRED_USE="
	ddci? ( dvb )
"

# Some patches from:
# https://github.com/rpmfusion/tvheadend

PATCHES=(
	"${FILESDIR}"/${PN}-4.0.9-use_system_queue.patch
	"${FILESDIR}"/${PN}-4.3-hdhomerun.patch
	"${FILESDIR}"/${PN}-4.2.2-dtv_scan_tables.patch
	"${FILESDIR}"/${PN}-4.2.7-python3.patch
)

DOCS=( README.md )

pkg_setup() {
	use inotify &&
		CONFIG_CHECK="~INOTIFY_USER" linux-info_pkg_setup

	enewuser tvheadend -1 -1 /etc/tvheadend video
}

# We unconditionally enable codecs that do not require additional
# dependencies when building tvheadend. If support is missing from
# ffmpeg at runtime then tvheadend will simply disable these codecs.

# It is not necessary to specific all the --disable-*-static options as
# most of them only take effect when --enable-ffmpeg_static is given.

src_configure() {
	CC="$(tc-getCC)" \
	PKG_CONFIG="${CHOST}-pkg-config" \
	econf \
		--disable-bundle \
		--disable-ccache \
		--disable-dvbscan \
		--disable-ffmpeg_static \
		--disable-hdhomerun_static \
		--enable-libfdkaac \
		--enable-libtheora \
		--enable-libvorbis \
		--nowerror \
		$(use_enable dbus dbus_1) \
		$(use_enable debug trace) \
		$(use_enable ddci) \
		$(use_enable dvb linuxdvb) \
		$(use_enable dvbcsa) \
		$(use_enable dvbcsa capmt) \
		$(use_enable dvbcsa cccam) \
		$(use_enable dvbcsa constcw) \
		$(use_enable dvbcsa cwc) \
		$(use_enable ffmpeg libav) \
		$(use_enable hdhomerun hdhomerun_client) \
		$(use_enable imagecache) \
		$(use_enable inotify) \
		$(use_enable iptv) \
		$(use_enable opus libopus) \
		$(use_enable satip satip_server) \
		$(use_enable satip satip_client) \
		$(use_enable systemd libsystemd_daemon) \
		$(use_enable timeshift) \
		$(use_enable uriparser) \
		$(use_enable vpx libvpx) \
		$(use_enable x264 libx264) \
		$(use_enable x265 libx265) \
		$(use_enable zeroconf avahi) \
		$(use_enable zlib)
}

src_compile() {
	emake CC="$(tc-getCC)"
}

src_install() {
	default

	newinitd "${FILESDIR}"/tvheadend.initd tvheadend
	newconfd "${FILESDIR}"/tvheadend.confd tvheadend

	use systemd &&
		systemd_dounit "${FILESDIR}"/tvheadend.service

	dodir /etc/tvheadend
	fperms 0700 /etc/tvheadend
	fowners tvheadend:video /etc/tvheadend
}

pkg_postinst() {
	elog "The Tvheadend web interface can be reached at:"
	elog "http://localhost:9981/"
	elog
	elog "Make sure that you change the default username"
	elog "and password via the Configuration / Access control"
	elog "tab in the web interface."
}

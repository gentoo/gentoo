# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit linux-info systemd toolchain-funcs

DESCRIPTION="Tvheadend is a TV streaming server and digital video recorder"
HOMEPAGE="https://tvheadend.org/"
SRC_URI="https://github.com/${PN}/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"

IUSE="+capmt +constcw +cwc dbus debug dvbcsa dvben50221 +dvb +ffmpeg hdhomerun +imagecache +inotify iptv libressl satip systemd +timeshift uriparser xmltv zeroconf zlib"

BDEPEND="
	sys-devel/gettext
	virtual/pkgconfig"

RDEPEND="
	acct-user/tvheadend
	virtual/libiconv
	dbus? ( sys-apps/dbus )
	dvbcsa? ( media-libs/libdvbcsa )
	dvben50221? ( media-tv/linuxtv-dvb-apps )
	ffmpeg? ( media-video/ffmpeg:0= )
	hdhomerun? ( media-libs/libhdhomerun )
	!libressl? ( dev-libs/openssl:0= )
	libressl? ( dev-libs/libressl:= )
	uriparser? ( dev-libs/uriparser )
	zeroconf? ( net-dns/avahi )
	zlib? ( sys-libs/zlib )"

DEPEND="
	${RDEPEND}
	dvb? ( virtual/linuxtv-dvb-headers )"

RDEPEND+="
	dvb? ( media-tv/dtv-scan-tables )
	xmltv? ( media-tv/xmltv )"

REQUIRED_USE="dvbcsa? ( || ( capmt constcw cwc dvben50221 ) )"

# Some patches from:
# https://github.com/rpmfusion/tvheadend

PATCHES=(
	"${FILESDIR}"/${PN}-4.0.9-use_system_queue.patch
	"${FILESDIR}"/${PN}-4.2.{1,8}-hdhomerun.patch
	"${FILESDIR}"/${PN}-4.2.2-dtv_scan_tables.patch
	"${FILESDIR}"/${PN}-4.2.7-python3.patch
	"${FILESDIR}"/${PN}-4.2.8-gcc9.patch
	"${FILESDIR}"/${PN}-4.2.8-no-dvb-fix.patch
)

DOCS=( README.md )

pkg_setup() {
	use inotify &&
		CONFIG_CHECK="~INOTIFY_USER" linux-info_pkg_setup
}

src_configure() {
	CC="$(tc-getCC)" \
	PKG_CONFIG="${CHOST}-pkg-config" \
	econf \
		--disable-bundle \
		--disable-ccache \
		--disable-dvbscan \
		--disable-ffmpeg_static \
		--disable-hdhomerun_static \
		--nowerror \
		$(use_enable capmt) \
		$(use_enable constcw) \
		$(use_enable cwc) \
		$(use_enable dbus dbus_1) \
		$(use_enable debug trace) \
		$(use_enable dvb linuxdvb) \
		$(use_enable dvbcsa) \
		$(use_enable dvben50221) \
		$(use_enable ffmpeg libav) \
		$(use_enable hdhomerun hdhomerun_client) \
		$(use_enable imagecache) \
		$(use_enable inotify) \
		$(use_enable iptv) \
		$(use_enable satip satip_server) \
		$(use_enable satip satip_client) \
		$(use_enable systemd libsystemd_daemon) \
		$(use_enable timeshift) \
		$(use_enable uriparser) \
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
}

pkg_postinst() {
	elog "The Tvheadend web interface can be reached at:"
	elog "http://localhost:9981/"
	elog
	elog "Make sure that you change the default username"
	elog "and password via the Configuration / Access control"
	elog "tab in the web interface."

	. "${EROOT}"/etc/conf.d/tvheadend &>/dev/null

	if [[ ${TVHEADEND_CONFIG} = ${EPREFIX}/etc/tvheadend ]]; then
		echo
		ewarn "The HOME directory for the tvheadend user has changed from"
		ewarn "${EPREFIX}/etc/tvheadend to ${EPREFIX}/var/lib/tvheadend. The daemon will continue"
		ewarn "to use the old location until you update TVHEADEND_CONFIG in"
		ewarn "${EPREFIX}/etc/conf.d/tvheadend. Please manually move your existing files"
		ewarn "before you do so."
	fi
}

# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit eutils linux-info systemd toolchain-funcs user

DTV_SCAN_TABLES_VERSION="2015-02-08-f2053b3"

DESCRIPTION="Tvheadend is a TV streaming server and digital video recorder"
HOMEPAGE="https://tvheadend.org/"
SRC_URI="https://github.com/${PN}/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
		dvbscan? ( http://linuxtv.org/downloads/dtv-scan-tables/dtv-scan-tables-${DTV_SCAN_TABLES_VERSION}.tar.bz2 )"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="avahi capmt constcw +cwc dbus +dvb +dvbscan ffmpeg hdhomerun libav imagecache inotify iptv satip +timeshift uriparser xmltv zlib"

# does not build with ffmpeg-3 - bug 574990
# https://tvheadend.org/issues/3597
RDEPEND="dev-libs/openssl:=
	virtual/libiconv
	avahi? ( net-dns/avahi )
	dbus? ( sys-apps/dbus )
	ffmpeg? (
		!libav? ( <media-video/ffmpeg-3:= )
		libav? ( media-video/libav:= )
	)
	hdhomerun? ( media-libs/libhdhomerun )
	uriparser? ( dev-libs/uriparser )
	zlib? ( sys-libs/zlib )"

DEPEND="${RDEPEND}
	dvb? ( virtual/linuxtv-dvb-headers )
	capmt? ( virtual/linuxtv-dvb-headers )
	virtual/pkgconfig"

RDEPEND+="
	xmltv? ( media-tv/xmltv )"

CONFIG_CHECK="~INOTIFY_USER"

DOCS=( README.md )
PATCHES=( "${FILESDIR}/${P}-hdhomerun-include.patch" )

src_unpack() {
	unpack "${P}.tar.gz"

	if use dvbscan; then
		mkdir "${S}/data/dvb-scan" || die
		cd "${T}" || die
		unpack dtv-scan-tables-${DTV_SCAN_TABLES_VERSION}.tar.bz2
		rmdir "${S}/data/dvb-scan" || die
		mv "${T}/usr/share/dvb" "${S}/data/dvb-scan" || die

		# This is needed to prevent make from removing files
		touch "${S}/data/dvb-scan/.stamp" || die
	fi
}

pkg_setup() {
	enewuser tvheadend -1 -1 /dev/null video
}

src_configure() {
	econf --prefix="${EPREFIX}"/usr \
		--datadir="${EPREFIX}"/usr/share \
		--disable-ccache \
		--nowerror \
		--disable-hdhomerun_static \
		$(use_enable avahi) \
		$(use_enable capmt) \
		$(use_enable constcw) \
		$(use_enable cwc) \
		$(use_enable dbus dbus_1) \
		$(use_enable dvbscan) \
		$(use_enable dvb linuxdvb) \
		$(use_enable ffmpeg libav) \
		$(use_enable hdhomerun hdhomerun_client) \
		$(use_enable imagecache) \
		$(use_enable inotify) \
		$(use_enable iptv) \
		$(use_enable satip satip_server) \
		$(use_enable satip satip_client) \
		$(use_enable timeshift) \
		$(use_enable uriparser) \
		$(use_enable zlib)
}

src_compile() {
	emake CC="$(tc-getCC)"
}

src_install() {
	default

	newinitd "${FILESDIR}/tvheadend.initd" tvheadend
	newconfd "${FILESDIR}/tvheadend.confd" tvheadend

	systemd_dounit "${FILESDIR}/tvheadend.service"

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

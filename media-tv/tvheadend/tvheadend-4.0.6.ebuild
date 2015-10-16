# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils linux-info systemd toolchain-funcs user

DESCRIPTION="Tvheadend is a TV streaming server and digital video recorder"
HOMEPAGE="https://tvheadend.org/"
SRC_URI="https://github.com/${PN}/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
		dvbscan? ( http://linuxtv.org/downloads/dtv-scan-tables/dtv-scan-tables-2015-02-08-f2053b3.tar.bz2 )"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="avahi ccache capmt constcw +cwc dbus +dvb +dvbscan epoll ffmpeg hdhomerun libav iconv imagecache inotify iptv satip +timeshift uriparser xmltv zlib"

RDEPEND="dev-libs/openssl:=
	avahi? ( net-dns/avahi )
	capmt? ( virtual/linuxtv-dvb-headers )
	ccache? ( dev-util/ccache sys-libs/zlib )
	dbus? ( sys-apps/dbus )
	dvb? ( virtual/linuxtv-dvb-headers )
	ffmpeg? (
		!libav? ( media-video/ffmpeg:0= )
		libav? ( media-video/libav:= )
	)
	hdhomerun? ( media-libs/libhdhomerun )
	iconv? ( virtual/libiconv )
	imagecache? ( net-misc/curl )
	uriparser? ( dev-libs/uriparser )
	zlib? ( sys-libs/zlib )
	xmltv? ( media-tv/xmltv )"

DEPEND="${DEPEND}
	virtual/pkgconfig"

CONFIG_CHECK="~INOTIFY_USER"

DOCS=( README.md )

src_unpack() {
	unpack "${P}.tar.gz"

	if use dvbscan; then
		mkdir "${S}/data/dvb-scan" || die
		cd "${T}" || die
		unpack dtv-scan-tables-2015-02-08-f2053b3.tar.bz2
		rmdir "${S}/data/dvb-scan" || die
		mv "${T}/usr/share/dvb" "${S}/data/dvb-scan" || die

		# This is needed to prevent make from removing files
		touch "${S}/data/dvb-scan/.stamp" || die
	fi
}

pkg_setup() {
	enewuser tvheadend -1 -1 /dev/null video
}

src_prepare() {
	# remove '-Werror' wrt bug #438424
	sed -e 's:-Werror::' -i Makefile || die 'sed failed!'
	epatch "${FILESDIR}/${PV}-use-glibc-version-iconv.patch"
}

src_configure() {
	econf --prefix="${EPREFIX}"/usr \
		--datadir="${EPREFIX}"/usr/share \
		--mandir="${EPREFIX}"/usr/share/man/man1 \
		$(use_enable avahi) \
		$(use_enable ccache) \
		$(use_enable capmt) \
		$(use_enable constcw) \
		$(use_enable cwc) \
		$(use_enable dbus) \
		$(use_enable dvb linuxdvb) \
		$(use_enable dvbscan) \
		$(use_enable epoll) \
		--disable-kqueue \
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

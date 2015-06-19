# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-tv/tvheadend/tvheadend-9999.ebuild,v 1.2 2014/06/22 20:05:06 prometheanfire Exp $

EAPI=5

inherit eutils git-2 linux-info systemd toolchain-funcs user

DESCRIPTION="Tvheadend is a TV streaming server and digital video recorder"
HOMEPAGE="https://tvheadend.org/"
EGIT_REPO_URI="git://github.com/tvheadend/tvheadend.git"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""

IUSE="avahi ccache +dvb +dvbscan ffmpeg imagecache inotify uriparser xmltv zlib"

DEPEND="dev-libs/openssl
	avahi? ( net-dns/avahi )
	ccache? ( dev-util/ccache )
	dvb? ( virtual/linuxtv-dvb-headers )
	ffmpeg? ( virtual/ffmpeg )
	uriparser? ( dev-libs/uriparser )
	zlib? ( sys-libs/zlib )
	virtual/pkgconfig"

RDEPEND="${DEPEND}
	dvbscan? ( media-tv/linuxtv-dvb-apps )
	xmltv? ( media-tv/xmltv )"

CONFIG_CHECK="~INOTIFY_USER"

DOCS=( README.md )

pkg_setup() {
	enewuser tvheadend -1 -1 /dev/null video
}

src_prepare() {
	# remove '-Werror' wrt bug #438424
	sed -e 's:-Werror::' -i Makefile || die 'sed failed!'
}

src_configure() {
	econf --prefix="${EPREFIX}"/usr \
		--datadir="${EPREFIX}"/usr/share \
		$(use_enable avahi) \
		$(use_enable ccache) \
		--disable-dvbscan \
		$(use_enable dvb linuxdvb) \
		$(use_enable ffmpeg libav) \
		$(use_enable imagecache) \
		$(use_enable inotify) \
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

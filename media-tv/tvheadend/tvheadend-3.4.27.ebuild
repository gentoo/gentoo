# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-tv/tvheadend/tvheadend-3.4.27.ebuild,v 1.3 2014/07/06 00:58:47 twitch153 Exp $

EAPI=5

inherit eutils linux-info systemd toolchain-funcs user

MY_PV="3.4patch1"

DESCRIPTION="Tvheadend is a TV streaming server and digital video recorder"
HOMEPAGE="https://tvheadend.org/"
SRC_URI="https://github.com/${PN}/${PN}/archive/${MY_PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="avahi +dvb +dvbscan ffmpeg imagecache inotify xmltv zlib"

REQUIRED_USE="dvbscan? ( dvb )"

DEPEND="dev-libs/openssl
	avahi? ( net-dns/avahi )
	dvb? ( virtual/linuxtv-dvb-headers )
	ffmpeg? ( virtual/ffmpeg )
	imagecache? ( net-misc/curl )
	zlib? ( sys-libs/zlib )
	virtual/pkgconfig"

RDEPEND="${DEPEND}
	dvbscan? ( media-tv/linuxtv-dvb-apps )
	xmltv? ( media-tv/xmltv )"

S="${WORKDIR}/${PN}-${MY_PV}"

CONFIG_CHECK="~INOTIFY_USER"

DOCS=( README )

pkg_setup() {
	enewuser tvheadend -1 -1 /dev/null video
}

src_prepare() {
	# set the version number
	echo "const char *tvheadend_version = \"${PV}\";" \
		> src/version.c || die "setting version failed!"

	# remove '-Werror' wrt bug #438424
	sed -e 's:-Werror::' -i Makefile || die 'sed failed!'
}

src_configure() {
	econf --prefix="${EPREFIX}"/usr \
		--datadir="${EPREFIX}"/usr/share \
		--mandir="${EPREFIX}"/usr/share/man/man1 \
		$(use_enable avahi) \
		--disable-dvbscan \
		$(use_enable dvb linuxdvb) \
		$(use_enable ffmpeg libav) \
		$(use_enable imagecache) \
		$(use_enable inotify) \
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

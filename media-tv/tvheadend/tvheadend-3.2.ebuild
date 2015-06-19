# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-tv/tvheadend/tvheadend-3.2.ebuild,v 1.2 2014/06/21 21:15:09 prometheanfire Exp $

EAPI=4

inherit eutils toolchain-funcs user

DESCRIPTION="A combined DVB receiver, Digital Video Recorder and Live TV streaming server"
HOMEPAGE="https://www.lonelycoder.com/redmine/projects/tvheadend/"
SRC_URI="mirror://github/tvheadend/tvheadend/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="avahi xmltv zlib"

DEPEND="dev-libs/openssl
	virtual/linuxtv-dvb-headers
	avahi? ( net-dns/avahi )
	zlib? ( sys-libs/zlib )"
RDEPEND="${DEPEND}
	xmltv? ( media-tv/xmltv )"

DOCS=( README )

pkg_setup() {
	enewuser tvheadend -1 -1 /dev/null video
}

src_prepare() {
	# set the correct version number
	sed -e "s:(3.1.694):(${PV}):" -i debian/changelog || die 'sed failed!'

	# remove '-Werror' wrt bug #438424
	sed -e 's:-Werror::' -i Makefile || die 'sed failed!'
}

src_configure() {
	econf --prefix="${EPREFIX}"/usr \
		--datadir="${EPREFIX}"/usr/share/"${PN}" \
		--mandir="${EPREFIX}"/usr/share/man/man1 \
		--release \
		--disable-dvbscan \
		$(use_enable avahi) \
		$(use_enable zlib)
}

src_compile() {
	emake CC="$(tc-getCC)"
}

src_install() {
	default

	newinitd "${FILESDIR}/tvheadend.initd" tvheadend
	newconfd "${FILESDIR}/tvheadend.confd" tvheadend

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

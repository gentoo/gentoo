# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-tv/tvheadend/tvheadend-2.12.ebuild,v 1.3 2012/10/16 07:09:34 pinkbyte Exp $

EAPI=4

inherit eutils toolchain-funcs user

MY_PN="hts-${PN}"

DESCRIPTION="A combined DVB receiver, Digital Video Recorder and Live TV streaming server"
HOMEPAGE="http://www.lonelycoder.com/hts/"
SRC_URI="http://www.lonelycoder.com/debian/dists/hts/main/source/${MY_PN}_${PV}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="avahi xmltv"

DEPEND="virtual/linuxtv-dvb-headers"
RDEPEND="${DEPEND}
	avahi? ( net-dns/avahi )
	xmltv? ( media-tv/xmltv )"

S="${WORKDIR}/${MY_PN}-${PV}"

pkg_setup() {
	enewuser tvheadend -1 -1 /dev/null video
}

src_prepare() {
	# set version number to avoid subversion and git dependencies
	sed -e 's:\$(shell support/version.sh):${PV}:' \
		-i Makefile || die "sed failed!"

	# remove stripping
	sed -e 's:install -s:install:' \
		-i support/posix.mk || die "sed failed!"

	# remove '-Werror' wrt bug #438424
	sed -i 's:-Werror::' Makefile || die "sed on removing '-Werror' failed!"
}

src_configure() {
	econf $(use_enable avahi) --release
}

src_compile() {
	emake CC="$(tc-getCC)"
}

src_install() {
	emake DESTDIR="${D}" install

	dodoc ChangeLog README
	doman man/tvheadend.1

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

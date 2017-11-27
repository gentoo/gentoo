# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Clock randomness gathering daemon"
HOMEPAGE="http://echelon.pl/pubs/"
SRC_URI="http://echelon.pl/pubs/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"

src_configure() {
	econf --bindir="${EPREFIX}"/usr/sbin
}

src_install() {
	default

	newinitd "${FILESDIR}"/${PN}-init.d ${PN}
	newconfd "${FILESDIR}"/${PN}-conf.d ${PN}
}

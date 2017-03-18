# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit eutils

DESCRIPTION="Security and system auditing tool"
HOMEPAGE="http://yasat.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~sparc ~x86"

S=${WORKDIR}/${PN}

src_prepare() {
	epatch "${FILESDIR}"/${P}-remove-absent-tests.patch
}

src_compile() { :; }

src_install() {
	emake install DESTDIR="${D}" PREFIX="/usr" SYSCONFDIR="/etc"

	dodoc README CHANGELOG
	doman man/yasat.8
}

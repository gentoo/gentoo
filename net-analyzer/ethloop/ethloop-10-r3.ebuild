# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/ethloop/ethloop-10-r3.ebuild,v 1.5 2014/07/11 10:28:42 jer Exp $

EAPI=5

inherit eutils toolchain-funcs

DESCRIPTION="Local simulator for testing Linux QoS disciplines"
HOMEPAGE="http://luxik.cdi.cz/~devik/qos/ethloop/"
SRC_URI="http://luxik.cdi.cz/~devik/qos/ethloop/ethloop10.tgz"

LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="~amd64 ~ppc x86"
RESTRICT="mirror bindist"

S=${WORKDIR}/${PN}

src_prepare() {
	epatch "${FILESDIR}"/${P}-gcc45.patch
}

src_compile() {
	emake CC=$(tc-getCC) CFLAGS="${CFLAGS}"
}

src_install() {
	dosbin ethloop
}

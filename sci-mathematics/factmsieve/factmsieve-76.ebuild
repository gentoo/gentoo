# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-mathematics/factmsieve/factmsieve-76.ebuild,v 1.1 2012/11/30 07:25:15 patrick Exp $

EAPI=4
DESCRIPTION="Convenient factorization helper script using msieve and ggnfs"
HOMEPAGE="http://gladman.plushost.co.uk/oldsite/computing/factoring.php"
SRC_URI="http://gladman.plushost.co.uk/oldsite/computing/${PN}.${PV}.zip"

inherit eutils

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

# I guess no one really "needs" python 2.6, but I'm a nice person
RDEPEND="|| ( dev-lang/python:2.7 dev-lang/python:2.6 )
	sci-mathematics/msieve
	sci-mathematics/ggnfs"
DEPEND=""

S=${WORKDIR}

src_prepare() {
	epatch "${FILESDIR}/${P}.patch"
}

src_compile() { :;
}

src_install() {
	mkdir -p "${D}/usr/bin/"
	cp "${S}/${PN}.py" "${D}/usr/bin/${PN}" 	|| die "Failed to install"
	chmod +x "${D}/usr/bin/${PN}" || die
}

# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit eutils toolchain-funcs

DESCRIPTION="TCP Load Balancing Port Forwarder"
HOMEPAGE="http://www.inlab.de/balance.html"
SRC_URI="http://www.inlab.de/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="doc"

DEPEND="doc? ( app-text/ghostscript-gpl
		sys-apps/groff )"
RDEPEND=""

src_prepare() {
	epatch "${FILESDIR}"/${P}-Makefile.patch
	tc-export CC
	use doc || touch balance.pdf
}

src_install() {
	default

	#autocreated on program start, if missing
	rmdir "${D}"/var/run/${PN}

	use doc && dodoc balance.pdf
}

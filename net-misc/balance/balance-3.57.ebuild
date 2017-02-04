# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit toolchain-funcs

DESCRIPTION="TCP Load Balancing Port Forwarder"
HOMEPAGE="http://www.inlab.de/balance.html"
SRC_URI="http://www.inlab.de/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

DEPEND=""
RDEPEND=""

PATCHES=( "${FILESDIR}"/${P}-Makefile.patch )

src_prepare() {
	default

	tc-export CC
}

src_install() {
	default

	#autocreated on program start, if missing
	rmdir "${D}"/var/run/${PN}
}

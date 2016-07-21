# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit eutils

DESCRIPTION="Important Quartet Puzzling and NNI Operation"
HOMEPAGE="http://www.cibiv.at/software/iqpnni/"
SRC_URI="http://www.cibiv.at/software/iqpnni/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="doc"

DEPEND=""
RDEPEND="${DEPEND}"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${P}-*.patch
}

src_install() {
	dobin src/iqpnni

	dodoc ChangeLog AUTHORS README NEWS TODO
	if use doc ; then
		dohtml manual/iqpnni-manual.html
		insinto /usr/share/doc/${P}
		doins manual/iqpnni-manual.pdf
	fi
}

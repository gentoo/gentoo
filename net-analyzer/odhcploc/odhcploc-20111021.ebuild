# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit toolchain-funcs

DESCRIPTION="Open DHCP Locator"
HOMEPAGE="http://odhcploc.sourceforge.net/"
SRC_URI="mirror://sourceforge/project/${PN}/${PV}/${P}.tar.gz"

LICENSE="ISC"
SLOT="0"
KEYWORDS="~amd64"

src_prepare() {
	tc-export CC
}

src_install() {
	dobin ${PN}
	doman ${PN}.8
	dodoc AUTHORS
}

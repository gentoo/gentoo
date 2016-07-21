# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit toolchain-funcs

DESCRIPTION="An interpreter for Psion 5(MX) file formats"
HOMEPAGE="http://huizen.dds.nl/~frodol/psiconv"
SRC_URI="http://huizen.dds.nl/~frodol/${PN}/${P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
IUSE="static-libs"
KEYWORDS="~alpha ~amd64 ~hppa ~mips ~ppc ~sparc ~x86"

src_prepare() {
	tc-export AR
}

src_configure() {
	econf $(use_enable static-libs static)
}

src_install() {
	default
	use static-libs || rm -fr "${D}"usr/lib*/lib${PN}.la
}

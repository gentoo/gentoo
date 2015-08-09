# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit base toolchain-funcs

DESCRIPTION="Read, Set or disable the idle3 timer of Western Digital drives"
HOMEPAGE="http://idle3-tools.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tgz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

src_compile() {
	emake CC="$(tc-getCC)" CFLAGS="-Wall ${CFLAGS}" LDFLAGS="${LDFLAGS}" || die
}

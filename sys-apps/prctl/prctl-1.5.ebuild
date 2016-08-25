# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4
inherit toolchain-funcs

DESCRIPTION="Tool to query and modify process behavior"
HOMEPAGE="https://sourceforge.net/projects/prctl/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha ia64"
IUSE=""

RDEPEND=""
DEPEND="sys-apps/groff"

src_compile() {
	emake CC="$(tc-getCC)" CFLAGS="${CFLAGS}" LDFLAGS="${LDFLAGS}"
}

src_install() {
	dobin prctl
	doman prctl.1
	dodoc ChangeLog
}

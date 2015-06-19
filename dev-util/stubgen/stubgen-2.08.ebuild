# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/stubgen/stubgen-2.08.ebuild,v 1.3 2013/04/09 18:26:58 ago Exp $

EAPI=4
inherit toolchain-funcs

DESCRIPTION="a member function stub generator for C++"
HOMEPAGE="http://www.radwin.org/michael/projects/stubgen/"
SRC_URI="http://www.radwin.org/michael/projects/${PN}/dist/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

src_compile() {
	make CC="$(tc-getCC)" CFLAGS="${CFLAGS}" LFLAGS="${LDFLAGS}"
}

src_install() {
	dobin ${PN}
	dodoc ChangeLog README
	doman ${PN}.1
}

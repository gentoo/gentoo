# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="A member function stub generator for C++"
HOMEPAGE="http://www.radwin.org/michael/projects/stubgen/"
SRC_URI="http://www.radwin.org/michael/projects/${PN}/dist/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

src_compile() {
	emake CC="$(tc-getCC)" CFLAGS="${CFLAGS}" LFLAGS="${LDFLAGS}"
}

src_install() {
	dobin ${PN}
	dodoc ChangeLog README
	doman ${PN}.1
}

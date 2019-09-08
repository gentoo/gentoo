# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="Z80 macro cross-assembler"
HOMEPAGE="http://www.tim-mann.org/trs80resources.html"
SRC_URI="http://www.tim-mann.org/trs80/${PN}${PV//.}.zip"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="amd64 x86"

BDEPEND="app-arch/unzip"

S="${WORKDIR}"

src_compile() {
	emake CC="$(tc-getCC)" CFLAGS="${CFLAGS} ${LDFLAGS}"
}

src_install() {
	dobin zmac
	doman zmac.1
	dodoc ChangeLog MAXAM NEWS README
}

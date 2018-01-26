# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs

DESCRIPTION="Switch user and group id and exec"
HOMEPAGE="https://github.com/ncopa/su-exec"
SRC_URI="https://github.com/ncopa/su-exec/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

src_prepare() {
	default
	sed -i -e "s/-Werror//" Makefile || die
}

src_compile() {
	CC=$(tc-getCC) emake
}

src_install() {
	dobin ${PN}
	dodoc README.md
}

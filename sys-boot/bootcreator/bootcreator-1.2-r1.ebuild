# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="Simple generator for Forth based BootMenu scripts for Pegasos machines"
HOMEPAGE="http://tbs-software.com/morgoth/projects.html"
SRC_URI="http://tbs-software.com/morgoth/files/bootcreator-src.tar.gz"
S=${WORKDIR}

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="-* ppc"

src_compile() {
	emake CC="$(tc-getCC)"
}

src_install() {
	dosbin src/bootcreator
	dodoc doc/README

	insinto /etc
	newins examples/example.bc bootmenu.example
}

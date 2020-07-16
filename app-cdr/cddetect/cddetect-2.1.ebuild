# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="Tool for detecting the type of a CD/DVD without mounting it"
HOMEPAGE="http://www.bellut.net/projects.html"
SRC_URI="http://www.bellut.net/files/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

S=${WORKDIR}

PATCHES=( "${FILESDIR}"/"${P}"-fix-include.patch ) #337628

src_compile() {
	emake CC="$(tc-getCC)" CFLAGS="-Wall ${CFLAGS}"
}

src_install() {
	dobin ${PN}
}

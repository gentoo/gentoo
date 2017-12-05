# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils toolchain-funcs

DESCRIPTION="Performance Test of Filesystem I/O using standard C library calls"
HOMEPAGE="http://www.textuality.com/bonnie/"
SRC_URI="http://www.textuality.com/bonnie/bonnie.tar.gz"

LICENSE="bonnie"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86"
IUSE=""

S=${WORKDIR}

PATCHES=( "${FILESDIR}/bonnie_man.patch"
	  "${FILESDIR}/Makefile.patch"
	  "${FILESDIR}/${P}-includes.patch" )

src_compile() {
	emake CC=$(tc-getCC) SYSFLAGS="${CFLAGS}"
}

src_install() {
	newbin Bonnie bonnie
	doman bonnie.1
	dodoc Instructions
}

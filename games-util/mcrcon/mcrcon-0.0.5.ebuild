# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-util/mcrcon/mcrcon-0.0.5.ebuild,v 1.1 2015/03/06 23:50:22 chewi Exp $

EAPI=5

inherit toolchain-funcs games

DESCRIPTION="Remote connection client for Minecraft servers"
HOMEPAGE="http://sourceforge.net/projects/mcrcon/"
SRC_URI="mirror://sourceforge/${PN}/${P}-src.zip"
LICENSE="ZLIB"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

S="${WORKDIR}"

src_compile() {
	# Flags taken from COMPILING.txt.
	$(tc-getCC) ${CFLAGS} ${LDFLAGS} -std=gnu11 -pedantic -Wall -Wextra -o "${PN}" "${PN}.c" || die
}

src_install() {
	dogamesbin "${PN}"
	dodoc README.txt
}

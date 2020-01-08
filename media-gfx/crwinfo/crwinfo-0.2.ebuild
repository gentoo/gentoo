# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="Canon raw image (CRW) information and thumbnail extractor"
HOMEPAGE="http://freshmeat.net/projects/crwinfo/"
SRC_URI="http://neuemuenze.heim1.tu-clausthal.de/~sven/crwinfo/CRWInfo-${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 hppa ia64 ppc ppc64 sparc x86"

S="${WORKDIR}/CRWInfo-${PV}"

PATCHES=( "${FILESDIR}"/${P}.patch )

src_compile() {
	tc-export CC
	emake crwinfo
}

src_install() {
	dobin crwinfo
	dodoc README spec
}

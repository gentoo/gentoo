# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=0

inherit eutils

DESCRIPTION="A portable assembler for processors of the PowerPC family"
SRC_URI="http://devnull.owl.de/~frank/${PN}.tar.gz"
HOMEPAGE="http://sun.hasenbraten.de/~frank/projects/"
LICENSE="GPL-2"
SLOT="0"
IUSE=""
KEYWORDS="~ppc ~ppc-macos"

src_unpack() {
	mkdir -p "${S}"/LinuxPPC
	cd "${S}"
	unpack ${A}
	epatch "${FILESDIR}/${P}-ppc.patch"
}

src_compile() {
	emake || die "Compilation failed"
}

src_install () {
	dobin pasm || die "Failed to install pasm binary"
	dodoc pasm.doc || die "Failed to install pasm documentation"
}

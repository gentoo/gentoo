# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs

DESCRIPTION="A program to align cDNA and genomic DNA"
HOMEPAGE="http://globin.cse.psu.edu/html/docs/sim4.html"
SRC_URI="http://globin.cse.psu.edu/ftp/dist/sim4/sim4.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

S=${WORKDIR}/${PN}.2003-09-21

PATCHES=( "${FILESDIR}"/${PN}-20030921-fix-build-system.patch )

src_configure() {
	tc-export CC
}

src_install() {
	dobin ${PN}
	einstalldocs
}

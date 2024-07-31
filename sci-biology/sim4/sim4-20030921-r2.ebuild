# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="A program to align cDNA and genomic DNA"
HOMEPAGE="http://globin.cse.psu.edu/html/docs/sim4.html"
SRC_URI="mirror://gentoo/${P}.tar.gz"
S="${WORKDIR}/${PN}.2003-09-21"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"

PATCHES=( "${FILESDIR}"/${PN}-20030921-fix-build-system.patch )

src_configure() {
	tc-export CC
}

src_install() {
	dobin ${PN}
	einstalldocs
}

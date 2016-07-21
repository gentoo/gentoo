# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit autotools eutils

DESCRIPTION="An advanced suite for testing the randomness of RNG's"
HOMEPAGE="http://www.phy.duke.edu/~rgb/General/dieharder.php"
SRC_URI="http://www.phy.duke.edu/~rgb/General/${PN}/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

RDEPEND="sci-libs/gsl"
DEPEND="${RDEPEND}
	doc? ( dev-tex/latex2html )"

src_prepare() {
	epatch "${FILESDIR}/${P}-build.patch"
	eautoreconf
}

src_compile() {
	emake -j1
	use doc && emake -C manual
}

src_install() {
	default
	dodoc NOTES
	docinto "dieharder"
	dodoc dieharder/README dieharder/NOTES
	docinto "libdieharder"
	dodoc libdieharder/README libdieharder/NOTES

	if use doc ; then
		dodoc ChangeLog dieharder.html
		docinto "manual"
		dodoc manual/dieharder.pdf manual/dieharder.ps
	fi
}

# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/dpic/dpic-20130310.ebuild,v 1.3 2013/06/25 18:43:36 ago Exp $

EAPI=5

inherit toolchain-funcs

DESCRIPTION="Converts PIC plots into pstricks, PGF/TikZ, PostScript, MetaPost and TeX"
HOMEPAGE="http://ece.uwaterloo.ca/~aplevich/dpic"
SRC_URI="https://ece.uwaterloo.ca/~aplevich/dpic/${PN}-2013.03.10.tar.gz"

LICENSE="BSD-2 CC-BY-3.0 GPL-2+"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="examples"

DEPEND=""
RDEPEND=""

S="${WORKDIR}/${PN}"

src_compile () {
	emake CC="$(tc-getCC)"
}

src_install () {
	dobin dpic
	doman doc/dpic.1
	dodoc README CHANGES doc/dpicdoc.pdf doc/gpic.pdf
	if use examples; then
		dodoc -r examples
		docompress -x /usr/share/doc/${PF}/examples
	fi
}

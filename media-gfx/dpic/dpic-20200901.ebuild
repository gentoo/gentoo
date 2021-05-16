# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Converts PIC plots into pstricks, PGF/TikZ, PostScript, MetaPost and TeX"
HOMEPAGE="https://ece.uwaterloo.ca/~aplevich/dpic"
SRC_URI="https://ece.uwaterloo.ca/~aplevich/dpic/${PN}-2020.09.01.tar.gz"

# dpic: BSD-2, dpicdoc.pdf: CC-BY-3.0, p2c: GPL
LICENSE="BSD-2 CC-BY-3.0 GPL-2+"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="examples"

S="${WORKDIR}/${PN}-2020.09.01"

src_install() {
	dobin dpic
	doman doc/dpic.1

	einstalldocs

	if use examples; then
		dodoc -r examples
		docompress -x /usr/share/doc/${PF}/examples
	fi
}

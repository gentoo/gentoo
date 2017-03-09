# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 vcs-snapshot

DESCRIPTION="Pymol ScrIpt COllection"
HOMEPAGE="https://github.com/speleo3/pymol-psico/"
SRC_URI="https://github.com/speleo3/pymol-psico/tarball/${PV} -> ${P}.tar.gz"

SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
LICENSE="BSD-2"
IUSE="minimal"

RDEPEND="
	dev-python/numpy[${PYTHON_USEDEP}]
	sci-biology/biopython[${PYTHON_USEDEP}]
	sci-libs/mmtk[${PYTHON_USEDEP}]
	sci-chemistry/pymol[${PYTHON_USEDEP}]
	!minimal? (
		media-libs/qhull
		media-video/mplayer
		sci-biology/stride
		sci-chemistry/dssp
		sci-chemistry/mm-align
		sci-chemistry/pdbmat
		sci-chemistry/theseus
		sci-chemistry/tm-align
		sci-mathematics/diagrtb
	)"

pkg_postinst() {
	if ! use minimal; then
		elog "For full functionality you need to get DynDom from"
		elog "http://fizz.cmp.uea.ac.uk/dyndom/dyndomMain.do"
	fi
}

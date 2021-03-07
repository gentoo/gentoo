# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{7..9} )

inherit distutils-r1

DESCRIPTION="Python package for drawing Feynman diagrams"
HOMEPAGE="http://pyfeyn.hepforge.org/ https://pypi.org/project/pyfeyn/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="latex"

DEPEND=""
RDEPEND=">=dev-python/pyx-0.15[${PYTHON_USEDEP}]
	latex? ( dev-texlive/texlive-mathscience )"

PATCHES=( "${FILESDIR}"/${P}.patch )

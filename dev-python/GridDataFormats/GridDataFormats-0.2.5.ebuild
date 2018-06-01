# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Reading and writing of data on regular grids in Python"
HOMEPAGE="https://pypi.org/project/GridDataFormats/ https://github.com/MDAnalysis/GridDataFormats"
SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz"

SLOT="0"
LICENSE="LGPL-3"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE=""

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND="
	>=dev-python/numpy-1.0.3[${PYTHON_USEDEP}]
	sci-libs/scipy[${PYTHON_USEDEP}]"

# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{2_7,3_5,3_6} )

inherit distutils-r1

DESCRIPTION="A python library to analyze and manipulate molecular dynamics trajectories"
HOMEPAGE="https://www.mdanalysis.org"
SRC_URI="mirror://pypi/M/${PN}/${P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="test"

RDEPEND="
	dev-python/numpy[${PYTHON_USEDEP}]
	sci-libs/scipy[${PYTHON_USEDEP}]
	sci-biology/biopython[${PYTHON_USEDEP}]
	dev-python/networkx[${PYTHON_USEDEP}]
	dev-python/GridDataFormats[${PYTHON_USEDEP}]
	dev-python/netcdf4-python[${PYTHON_USEDEP}]
	dev-python/mmtf-python[${PYTHON_USEDEP}]
	dev-python/gsd[${PYTHON_USEDEP}]
	dev-python/mock[${PYTHON_USEDEP}]
	dev-python/duecredit[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}
	test? ( dev-python/nose[${PYTHON_USEDEP}] )"

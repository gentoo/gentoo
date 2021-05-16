# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )

inherit distutils-r1

DESCRIPTION="A python library to analyze and manipulate molecular dynamics trajectories"
HOMEPAGE="https://www.mdanalysis.org"
SRC_URI="mirror://pypi/M/${PN}/${P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="test"

RDEPEND="
	>=dev-python/numpy-1.13.3[${PYTHON_USEDEP}]
	>=dev-python/scipy-1.0.0[${PYTHON_USEDEP}]
	>=sci-biology/biopython-1.71[${PYTHON_USEDEP}]
	>=dev-python/networkx-1.0[${PYTHON_USEDEP}]
	>=dev-python/GridDataFormats-0.4.0[${PYTHON_USEDEP}]
	>=dev-python/joblib-0.12[${PYTHON_USEDEP}]
	>=dev-python/matplotlib-1.5.1[${PYTHON_USEDEP}]
	dev-python/netcdf4-python[${PYTHON_USEDEP}]
	>=dev-python/mmtf-python-1.0.0[${PYTHON_USEDEP}]
	>=dev-python/gsd-1.9.3[${PYTHON_USEDEP}]
	dev-python/mock[${PYTHON_USEDEP}]
	dev-python/duecredit[${PYTHON_USEDEP}]
	>=dev-python/six-1.4.0[${PYTHON_USEDEP}]
	>=dev-python/tqdm-4.43.0[${PYTHON_USEDEP}]
"
BDEPEND="${RDEPEND}"

distutils_enable_tests nose

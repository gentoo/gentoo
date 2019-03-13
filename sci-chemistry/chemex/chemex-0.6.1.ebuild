# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
DISTUTILS_SINGLE_IMPL="yes"
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Program to fit chemical exchange induced shift and relaxation data"
HOMEPAGE="https://github.com/gbouvignies/chemex"
SRC_URI="https://github.com/gbouvignies/chemex/archive/${PV}.tar.gz -> ${P}.tar.gz"

SLOT="0"
LICENSE="BSD"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="
	>=dev-python/matplotlib-1.1[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
	>=sci-libs/scipy-0.11[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
"

src_prepare() {
	# Fix quotes to detect the version properly
	sed -i -e 's/matplotlib>=1.3.1/matplotlib>="1.3.1"/' setup.py || die
	distutils-r1_python_prepare_all
}

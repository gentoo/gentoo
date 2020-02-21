# Copyright 1999-2020 Gentoo Authors
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
	$(python_gen_cond_dep '
		|| (
			>=dev-python/matplotlib-python2-1.1[${PYTHON_MULTI_USEDEP}]
			>=dev-python/matplotlib-1.1[${PYTHON_MULTI_USEDEP}]
		)
		|| (
			dev-python/numpy-python2[${PYTHON_MULTI_USEDEP}]
			dev-python/numpy[${PYTHON_MULTI_USEDEP}]
		)
		|| (
			>=sci-libs/scipy-python2-0.11[${PYTHON_MULTI_USEDEP}]
			>=sci-libs/scipy-0.11[${PYTHON_MULTI_USEDEP}]
		)
	')
"
DEPEND="${RDEPEND}"

src_prepare() {
	# Fix quotes to detect the version properly
	sed -i -e 's/matplotlib>=1.3.1/matplotlib>="1.3.1"/' setup.py || die
	distutils-r1_python_prepare_all
}

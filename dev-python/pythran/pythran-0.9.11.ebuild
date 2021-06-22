# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..9} )
inherit distutils-r1 multiprocessing

DESCRIPTION="Ahead of Time compiler for numeric kernels"
HOMEPAGE="
	https://pypi.org/project/pythran/
	https://github.com/serge-sans-paille/pythran/"
SRC_URI="
	https://github.com/serge-sans-paille/pythran/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	=dev-python/beniget-0.3*[${PYTHON_USEDEP}]
	dev-python/decorator[${PYTHON_USEDEP}]
	=dev-python/gast-0.4*[${PYTHON_USEDEP}]
	>=dev-python/networkx-2[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
	>=dev-python/ply-3.4[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]"
BDEPEND="
	test? (
		dev-python/ipython[${PYTHON_USEDEP}]
		dev-python/pytest-xdist[${PYTHON_USEDEP}]
		dev-python/scipy[${PYTHON_USEDEP}]
		dev-python/wheel[${PYTHON_USEDEP}]
		virtual/cblas
	)"

distutils_enable_tests pytest

src_prepare() {
	sed -i -e '/pytest-runner/d' setup.py || die
	distutils-r1_src_prepare
}

python_test() {
	local -x COLUMNS=80
	epytest -n "$(makeopts_jobs "${MAKEOPTS}" "$(get_nproc)")"
}

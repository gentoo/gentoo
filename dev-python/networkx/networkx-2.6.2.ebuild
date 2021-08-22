# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..10} )
inherit distutils-r1 virtualx

DESCRIPTION="Python tools to manipulate graphs and complex networks"
HOMEPAGE="https://networkx.org/ https://github.com/networkx/networkx"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~riscv x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos"
IUSE="examples extras xml yaml"

RDEPEND="
	>=dev-python/matplotlib-3.3[${PYTHON_USEDEP}]
	>=dev-python/numpy-1.19[${PYTHON_USEDEP}]
	>=dev-python/pandas-1.1[${PYTHON_USEDEP}]
	>=dev-python/scipy-1.6.2[${PYTHON_USEDEP}]
	extras? (
		>=dev-python/pydot-1.4.1[${PYTHON_USEDEP}]
		$(python_gen_cond_dep '
			>=dev-python/pygraphviz-1.7[${PYTHON_USEDEP}]
			>=sci-libs/gdal-1.10.0[python,${PYTHON_USEDEP}]
		' python3_{8..9})
	)
	xml? ( >=dev-python/lxml-4.5[${PYTHON_USEDEP}] )
	yaml? ( >=dev-python/pyyaml-3.13[${PYTHON_USEDEP}] )"

distutils_enable_tests pytest

python_test() {
	local deselect=()
	virtx epytest -p no:django ${deselect[@]/#/--deselect }
}

python_install_all() {
	use examples && dodoc -r examples

	distutils-r1_python_install_all
}

# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7} )
inherit distutils-r1 virtualx

DESCRIPTION="Python tools to manipulate graphs and complex networks"
HOMEPAGE="http://networkx.github.io/ https://github.com/networkx/networkx"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.zip"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm64 x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos"
IUSE="examples extras pandas scipy test xml yaml"
RESTRICT="!test? ( test )"

REQUIRED_USE="
	test? ( extras pandas scipy xml yaml )"

COMMON_DEPEND="
	>=dev-python/matplotlib-2.2.2[${PYTHON_USEDEP}]
	extras? (
		>=dev-python/pydot-1.2.4[${PYTHON_USEDEP}]
		>=dev-python/pygraphviz-1.5[${PYTHON_USEDEP}]
		>=sci-libs/gdal-1.10.0[python,${PYTHON_USEDEP}]
	)
	pandas? ( >=dev-python/pandas-0.23.3[${PYTHON_USEDEP}] )
	scipy? ( >=sci-libs/scipy-1.1.0[${PYTHON_USEDEP}] )
	xml? ( >=dev-python/lxml-4.2.3[${PYTHON_USEDEP}] )
	yaml? ( >=dev-python/pyyaml-3.13[${PYTHON_USEDEP}] )"
DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	>=dev-python/decorator-4.3.0[${PYTHON_USEDEP}]
	${COMMON_DEPEND}
	test? (
		dev-python/nose[${PYTHON_USEDEP}]
	)"
RDEPEND="
	>=dev-python/decorator-4.3.0[${PYTHON_USEDEP}]
	${COMMON_DEPEND}
	examples? (
		dev-python/pyparsing[${PYTHON_USEDEP}]
	)"

PATCHES=(
)

python_test() {
	virtx nosetests -vv
}

python_install_all() {
	use examples && dodoc -r examples

	distutils-r1_python_install_all
}

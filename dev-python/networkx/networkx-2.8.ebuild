# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..10} )
inherit distutils-r1 optfeature virtualx

DESCRIPTION="Python tools to manipulate graphs and complex networks"
HOMEPAGE="https://networkx.org/ https://github.com/networkx/networkx"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 arm arm64 ~ppc64 ~riscv x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos"

BDEPEND="
	test? (
		>=dev-python/lxml-4.5[${PYTHON_USEDEP}]
		>=dev-python/numpy-1.19[${PYTHON_USEDEP}]
		>=dev-python/pyyaml-3.13[${PYTHON_USEDEP}]
		>=dev-python/scipy-1.6.2[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

python_test() {
	virtx epytest -p no:django
}

src_install() {
	distutils-r1_src_install
	# those examples use various assets and pre-compressed files
	docompress -x /usr/share/doc/${PF}/examples
}

pkg_postinst() {
	optfeature "recommended dependencies" "dev-python/matplotlib dev-python/numpy dev-python/pandas dev-python/scipy"
	optfeature "graph drawing and graph layout algorithms" "dev-python/pygraphviz dev-python/pydot"
	optfeature "YAML format reading and writing" "dev-python/pyyaml"
	optfeature "shapefile format reading and writing" "dev-python/gdal"
	optfeature "GraphML XML format" "dev-python/lxml"
}

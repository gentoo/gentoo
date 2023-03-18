# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_FULLY_TESTED=( python3_{9..11} )
PYTHON_COMPAT=( "${PYTHON_FULLY_TESTED[@]}" )

inherit distutils-r1 optfeature multiprocessing virtualx pypi

DESCRIPTION="Python tools to manipulate graphs and complex networks"
HOMEPAGE="
	https://networkx.org/
	https://github.com/networkx/networkx/
	https://pypi.org/project/networkx/
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 arm arm64 ~ia64 ~loong ~ppc64 ~riscv ~sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos"

BDEPEND="
	test? (
		>=dev-python/lxml-4.5[${PYTHON_USEDEP}]
		dev-python/pytest-xdist[${PYTHON_USEDEP}]
		>=dev-python/pyyaml-3.13[${PYTHON_USEDEP}]
		$(python_gen_cond_dep '
			>=dev-python/numpy-1.20[${PYTHON_USEDEP}]
			>=dev-python/scipy-1.6.2[${PYTHON_USEDEP}]
		' "${PYTHON_FULLY_TESTED[@]}")
	)
"

distutils_enable_tests pytest

src_test() {
	virtx distutils-r1_src_test
}

python_test() {
	local EPYTEST_DESELECT=()
	if ! has_version "dev-python/scipy[${PYTHON_USEDEP}]"; then
		EPYTEST_DESELECT+=(
			networkx/drawing/tests/test_pylab.py::test_draw
		)
	fi
	# virtx implies nonfatal
	nonfatal epytest -p no:django -n "$(makeopts_jobs)" || die
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
	optfeature "shapefile format reading and writing" "sci-libs/gdal[python]"
	optfeature "GraphML XML format" "dev-python/lxml"
}

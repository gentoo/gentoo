# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_FULLY_TESTED=( python3_{10..12} )
PYTHON_COMPAT=( "${PYTHON_FULLY_TESTED[@]}" )

inherit distutils-r1 multiprocessing optfeature pypi virtualx

DESCRIPTION="Python tools to manipulate graphs and complex networks"
HOMEPAGE="
	https://networkx.org/
	https://github.com/networkx/networkx/
	https://pypi.org/project/networkx/
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 arm arm64 ~loong ~ppc64 ~riscv ~sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos"

BDEPEND="
	test? (
		>=dev-python/lxml-4.6[${PYTHON_USEDEP}]
		dev-python/pytest-xdist[${PYTHON_USEDEP}]
		$(python_gen_cond_dep '
			>=dev-python/matplotlib-3.5[${PYTHON_USEDEP}]
			>=dev-python/numpy-1.22[${PYTHON_USEDEP}]
			>=dev-python/pandas-1.4[${PYTHON_USEDEP}]
			>=dev-python/scipy-1.11.2[${PYTHON_USEDEP}]
		' "${PYTHON_FULLY_TESTED[@]}")
	)
"

distutils_enable_tests pytest

src_test() {
	virtx distutils-r1_src_test
}

python_test() {
	if use x86 ; then
		EPYTEST_DESELECT+=(
			# https://github.com/networkx/networkx/issues/5913 (bug #921958)
			networkx/algorithms/approximation/tests/test_traveling_salesman.py::test_asadpour_tsp
		)
	fi

	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	# virtx implies nonfatal
	nonfatal epytest -p xdist -n "$(makeopts_jobs)" --dist=worksteal || die
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

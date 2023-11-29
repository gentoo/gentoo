# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )
DISTUTILS_USE_PEP517=setuptools

inherit distutils-r1 pypi

DESCRIPTION="Tools to provide lightweight pipelining in Python"
HOMEPAGE="
	https://joblib.readthedocs.io/en/latest/
	https://github.com/joblib/joblib/
	https://pypi.org/project/joblib/
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ~ppc ppc64 ~riscv x86 ~arm64-macos ~x64-macos"

RDEPEND="
	dev-python/cloudpickle[${PYTHON_USEDEP}]
	dev-python/loky[${PYTHON_USEDEP}]
"
# joblib is imported by setup.py so we need ${RDEPEND}
BDEPEND="
	${RDEPEND}
	test? (
		dev-python/threadpoolctl[${PYTHON_USEDEP}]
	)
"

PATCHES=(
	# Borrowed from Fedora: https://github.com/joblib/joblib/issues/1478
	"${FILESDIR}/${P}-py3.12-no-depr-warn.patch"
	# https://github.com/joblib/joblib/pull/1518
	"${FILESDIR}/${P}-py3.12-avoid-ast.num-and-node.n.patch"
)

distutils_enable_tests pytest

EPYTEST_DESELECT=(
	# https://github.com/joblib/joblib/issues/1115
	joblib/test/test_memory.py::test_parallel_call_cached_function_defined_in_jupyter
	# unexpectedly pickleable?
	joblib/test/test_hashing.py::test_hashing_pickling_error
)

python_prepare_all() {
	# unbundle
	rm -r joblib/externals || die
	sed -e "/joblib.externals/d" -i pyproject.toml || die
	find -name '*.py' -exec \
		sed -e 's:\(joblib\)\?\.externals\.::' \
			-e 's:from \.externals ::' \
			-i {} + || die

	distutils-r1_python_prepare_all
}

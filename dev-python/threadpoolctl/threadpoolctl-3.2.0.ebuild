# Copyright 2020-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=flit
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1

DESCRIPTION="Limit the number of threads used in native libs that have their own threadpool"
HOMEPAGE="
	https://github.com/joblib/threadpoolctl/
	https://pypi.org/project/threadpoolctl/
"
SRC_URI="
	https://github.com/joblib/${PN}/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ~ppc ppc64 ~riscv x86 ~arm64-macos ~x64-macos"

BDEPEND="
	dev-python/cython[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest

EPYTEST_DESELECT=(
	# Asserts against a hardcoded list of CPUs.  Either we skip it
	# or file bugs about missing architectures until upstream realizes
	# how bad idea that were.
	tests/test_threadpoolctl.py::test_architecture
	# This test fails if the Python executable (or any library that it
	# links to) uses OpenMP.  This can particularly be the case with
	# CPython 3.12 that links to app-crypt/libb2.
	# https://github.com/joblib/threadpoolctl/issues/146
	tests/test_threadpoolctl.py::test_command_line_empty
)

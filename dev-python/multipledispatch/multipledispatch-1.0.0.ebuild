# Copyright 2021-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1

DESCRIPTION="Multiple dispatch"
HOMEPAGE="
	https://pypi.org/project/multipledispatch/
	https://github.com/mrocklin/multipledispatch/
"
SRC_URI="
	https://github.com/mrocklin/multipledispatch/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ~loong ~riscv x86"

distutils_enable_tests pytest

EPYTEST_DESELECT=(
	multipledispatch/tests/test_core.py::test_multipledispatch
	multipledispatch/tests/test_benchmark.py
)

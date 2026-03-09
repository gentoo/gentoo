# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYPI_VERIFY_REPO=https://github.com/binaryornot/binaryornot
PYTHON_COMPAT=( python3_{11..14} pypy3_11 )

inherit distutils-r1 pypi

DESCRIPTION="Ultra-lightweight pure Python package to guess whether a file is binary or text"
HOMEPAGE="
	https://github.com/binaryornot/binaryornot/
	https://pypi.org/project/binaryornot/
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~riscv ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

BDEPEND="
	test? (
		dev-python/hypothesis[${PYTHON_USEDEP}]
	)
"

EPYTEST_PLUGINS=()
distutils_enable_tests pytest

EPYTEST_DESELECT=(
	# missing data files
	# https://github.com/binaryornot/binaryornot/issues/641
	tests/test_check.py::TestIsBinary::test_negative_binary
	# sdist test, requires Internet
	tests/test_sdist.py::TestSdistContents::test_sdist_includes_pyc_fixtures
)

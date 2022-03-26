# Copyright 2019-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..10} pypy3 )
inherit distutils-r1

DESCRIPTION="Library for testing asyncio code with pytest"
HOMEPAGE="https://github.com/pytest-dev/pytest-asyncio
	https://pypi.org/project/pytest-asyncio/"
SRC_URI="https://github.com/pytest-dev/pytest-asyncio/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~x64-macos"

RDEPEND="
	>=dev-python/pytest-5.4.0[${PYTHON_USEDEP}]"
BDEPEND="
	dev-python/setuptools_scm[${PYTHON_USEDEP}]
	test? (
		dev-python/flaky[${PYTHON_USEDEP}]
		>=dev-python/hypothesis-3.64[${PYTHON_USEDEP}]
	)"

distutils_enable_tests pytest

export SETUPTOOLS_SCM_PRETEND_VERSION=${PV}

EPYTEST_DESELECT=(
	# rely on precise warning counts
	tests/modes/test_legacy_mode.py
	tests/trio/test_fixtures.py::test_strict_mode_ignores_trio_fixtures
)

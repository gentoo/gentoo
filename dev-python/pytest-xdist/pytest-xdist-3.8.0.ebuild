# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYPI_VERIFY_REPO=https://github.com/pytest-dev/pytest-xdist
PYTHON_COMPAT=( python3_{11..15} python3_{13..15}t pypy3_11 )

inherit distutils-r1 pypi

DESCRIPTION="Distributed testing and loop-on-failing modes"
HOMEPAGE="
	https://pypi.org/project/pytest-xdist/
	https://github.com/pytest-dev/pytest-xdist/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~x64-macos"

RDEPEND="
	>=dev-python/execnet-2.1[${PYTHON_USEDEP}]
	dev-python/psutil[${PYTHON_USEDEP}]
	>=dev-python/pytest-7.0.0[${PYTHON_USEDEP}]
"

BDEPEND="
	dev-python/setuptools-scm[${PYTHON_USEDEP}]
	test? (
		dev-python/filelock[${PYTHON_USEDEP}]
	)
"

EPYTEST_PLUGIN_LOAD_VIA_ENV=1
EPYTEST_PLUGINS=( "${PN}" )
distutils_enable_tests pytest

PATCHES=(
	# https://github.com/pytest-dev/pytest-xdist/commit/0c984478f39d7a01aa24c061f2581bdfd071cb6a
	# https://github.com/pytest-dev/pytest-xdist/commit/44f4bea2652e06e7cd5d4a063aa2673b5ef701ee
	"${FILESDIR}/${P}-pytest-9.patch"
)

python_test() {
	epytest -o tmp_path_retention_count=1
}
